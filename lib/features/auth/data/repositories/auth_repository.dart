import 'package:dio/dio.dart';
import 'package:tilet/core/network/api_client.dart';
import 'package:tilet/core/storage/token_storage.dart';

class AuthRepository {
  AuthRepository({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? ApiClient.dio,
      _tokenStorage = tokenStorage ?? ApiClient.tokenStorage;

  final Dio _dio;
  final TokenStorage _tokenStorage;

  String _formatPhone(String phone) {
    // Remove spaces, dashes, and parentheses
    final cleaned = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.isEmpty) return cleaned;
    return cleaned.startsWith('+') ? cleaned : '+$cleaned';
  }

  Future<bool> isLoggedIn() => _tokenStorage.hasTokens();

  Future<void> login({required String phone, required String password}) async {
    try {
      final response = await _dio.post(
        '/api/auth/login/',
        data: {'phone': _formatPhone(phone), 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      await _tokenStorage.saveTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
      );
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Invalid phone or password.'));
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register/',
        data: {
          'phone': _formatPhone(phone),
          'password': password,
          'first_name': firstName.trim(),
          'last_name': lastName.trim(),
          'email': email.trim(),
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic> &&
          data['access'] != null &&
          data['refresh'] != null) {
        await _tokenStorage.saveTokens(
          accessToken: data['access'] as String,
          refreshToken: data['refresh'] as String,
        );
      } else {
        await login(phone: phone, password: password);
      }
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Registration failed.'));
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    try {
      if (refreshToken != null) {
        await _dio.post('/api/auth/logout/', data: {'refresh': refreshToken});
      }
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  /// Pulls the first readable DRF error message from response.data
  String _extractError(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['detail'] is String) return data['detail'] as String;
      for (final value in data.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
    }
    return fallback;
  }
}
