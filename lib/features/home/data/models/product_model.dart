import 'package:equatable/equatable.dart';
import 'package:tilet/core/network/api_client.dart';

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    required this.colorName,
    required this.size,
    required this.stock,
  });

  final int id;
  final String colorName;
  final String size;
  final int stock;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final color = json['color'] as Map<String, dynamic>?;
    return ProductVariant(
      id: json['id'] as int? ?? 0,
      colorName: color?['name'] as String? ?? '',
      size: json['size'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, colorName, size, stock];
}

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.rating,
    this.description = '',
    this.images = const [],
    this.variants = const [],
    this.categoryName = '',
    this.occasions = const [],
    this.displayCurrency = 'ETB',
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String image;
  final String price;
  final String rating;
  final String description;
  final List<String> images;
  final List<ProductVariant> variants;
  final String categoryName;
  final List<String> occasions;
  final String displayCurrency;
  final bool isFavorite;

  /// Unique available sizes from variants
  List<String> get availableSizes =>
      variants.where((v) => v.stock > 0).map((v) => v.size).toSet().toList();

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = (json['images'] as List<dynamic>? ?? [])
        .map((e) => ApiClient.resolveMediaUrl((e['image'] as String?) ?? ''))
        .where((url) => url.isNotEmpty)
        .toList();

    final rawVariants = (json['variants'] as List<dynamic>? ?? [])
        .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawOccasions = (json['ocasions'] as List<dynamic>? ?? [])
        .map((e) => (e['name'] as String?) ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final category = json['category'] as Map<String, dynamic>?;
    final currency = (json['display_currency'] as String?)?.isNotEmpty == true
        ? json['display_currency'] as String
        : 'ETB';
    final displayPrice = (json['display_price'] as String?)?.isNotEmpty == true
        ? json['display_price'] as String
        : (json['price']?.toString() ?? '0');

    final avgRating = (json['avg_rating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = json['review_count'] as int? ?? 0;

    return ProductModel(
      id: (json['id'] ?? '').toString(),
      title: json['name'] as String? ?? '',
      image: rawImages.isNotEmpty ? rawImages.first : '',
      images: rawImages,
      description: json['description'] as String? ?? '',
      price: '$currency $displayPrice',
      displayCurrency: currency,
      rating: '${avgRating.toStringAsFixed(1)} ($reviewCount)',
      variants: rawVariants,
      categoryName: category?['name'] as String? ?? '',
      occasions: rawOccasions,
    );
  }

  ProductModel copyWith({bool? isFavorite}) {
    return ProductModel(
      id: id,
      title: title,
      image: image,
      price: price,
      rating: rating,
      description: description,
      images: images,
      variants: variants,
      categoryName: categoryName,
      occasions: occasions,
      displayCurrency: displayCurrency,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        price,
        rating,
        description,
        images,
        variants,
        categoryName,
        occasions,
        displayCurrency,
        isFavorite,
      ];
}