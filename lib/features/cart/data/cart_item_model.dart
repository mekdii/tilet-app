import 'package:equatable/equatable.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

class CartItemModel extends Equatable {
  const CartItemModel({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  final ProductModel product;
  final String size;
  final int quantity;

  /// Extracts numeric price from strings like 'ETB 2,500' -> 2500
  int get unitPrice {
    final digits = product.price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  int get lineTotal => unitPrice * quantity;

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      product: product,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, size, quantity];
}