import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tilet/core/network/auth_interceptor.dart';
import 'package:tilet/core/storage/token_storage.dart';

class ApiClient {
  ApiClient._();

  static const String baseUrl = 'https://tiletshop.duckdns.org';
  static final TokenStorage tokenStorage = TokenStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static void attachAuthInterceptor({required void Function() onSessionExpired}) {
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: tokenStorage,
        onSessionExpired: onSessionExpired,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          error: true,
          logPrint: (obj) => debugPrint('🌐 API: $obj'),
        ),
      );
    }
  }

  static String resolveMediaUrl(String url) {
    if (url.isEmpty || url.startsWith('http')) return url;
    return '$baseUrl${url.startsWith('/') ? '' : '/'}$url';
  }
}