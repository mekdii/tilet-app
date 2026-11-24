import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static const String baseUrl = 'https://tiletshop.duckdns.org';

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

  /// Helper to turn relative media paths (e.g. "/media/...") into full URLs
  static String resolveMediaUrl(String url) {
    if (url.isEmpty || url.startsWith('http')) return url;
    return '$baseUrl${url.startsWith('/') ? '' : '/'}$url';
  }
}