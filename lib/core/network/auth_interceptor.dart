import 'package:dio/dio.dart';
import 'package:tilet/core/storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required this.onSessionExpired,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: dio.options.baseUrl,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

  final Dio _dio;
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;
  final void Function() onSessionExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;

    if (!isUnauthorized || alreadyRetried) {
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    try {
      final response = await _refreshDio.post(
        '/api/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      final newAccess = response.data['access'] as String;
      // Handle refresh token rotation if Django returns a new refresh token
      final newRefresh = (response.data['refresh'] as String?) ?? refreshToken;

      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      // Retry the original failed request with the new access token
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccess';
      retryOptions.extra['_retried'] = true;

      final retryResponse = await _dio.fetch(retryOptions);
      return handler.resolve(retryResponse);
    } catch (_) {
      await _tokenStorage.clearTokens();
      onSessionExpired();
      return handler.next(err);
    }
  }
}