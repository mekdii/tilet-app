import 'package:dio/dio.dart';
import 'package:tilet/core/network/api_client.dart';
import 'package:tilet/features/home/data/models/category_model.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

class ProductRepository {
  ProductRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;

  Future<List<ProductModel>> fetchProducts({
    int? categoryId,
    int page = 1,
  }) async {
    final response = await _dio.get(
      '/api/products/', // <-- confirm exact path in Swagger
      queryParameters: {
        'page': page,
        if (categoryId != null) 'category': categoryId,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];

    return results
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('/api/categories/'); // <-- confirm path in Swagger
    final data = response.data;

    // Handles both paginated ({results: [...]}) and plain list ([...]) responses
    final List<dynamic> list =
        data is Map<String, dynamic> ? (data['results'] as List<dynamic>? ?? []) : (data as List<dynamic>);

    return list
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}