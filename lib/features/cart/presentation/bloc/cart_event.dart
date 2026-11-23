import 'package:equatable/equatable.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded({required this.product, required this.size});
  final ProductModel product;
  final String size;

  @override
  List<Object?> get props => [product, size];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved({required this.productId, required this.size});
  final String productId;
  final String size;

  @override
  List<Object?> get props => [productId, size];
}

final class CartQuantityChanged extends CartEvent {
  const CartQuantityChanged({
    required this.productId,
    required this.size,
    required this.delta,
  });

  final String productId;
  final String size;
  final int delta; // +1 or -1

  @override
  List<Object?> get props => [productId, size, delta];
}

final class CartCleared extends CartEvent {
  const CartCleared();
}