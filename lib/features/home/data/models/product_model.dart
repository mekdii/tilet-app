import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    this.images = const [],
    this.description =
        'Handwoven Ethiopian cotton and artisan Tilet embroidery, featuring a graceful, traditional fit and intricate gold-threaded patterns.',
    this.isFavorite = false,
  });

  final String id;
  final String image;
  final List<String> images;
  final String title;
  final String price;
  final String rating;
  final String description;
  final bool isFavorite;

  /// Returns gallery images if provided, otherwise falls back to the main image.
  List<String> get gallery => images.isNotEmpty ? images : [image];

  ProductModel copyWith({bool? isFavorite}) {
    return ProductModel(
      id: id,
      image: image,
      images: images,
      title: title,
      price: price,
      rating: rating,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        image,
        images,
        title,
        price,
        rating,
        description,
        isFavorite,
      ];
}