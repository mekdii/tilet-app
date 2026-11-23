import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/cart/data/cart_item_model.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_event.dart';
import 'package:tilet/features/cart/presentation/bloc/cart_state.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc()
      : super(
          const CartState(
            // Pre-loaded sample items so you can test Option 2 immediately
            items: [
              CartItemModel(
                product: ProductModel(
                  id: '1',
                  image: 'assets/images/kemis_green.jpg',
                  title: 'Green Embroidered Kemis',
                  price: 'ETB 2,500',
                  rating: '4.8 (120)',
                ),
                size: 'M',
                quantity: 1,
              ),
              CartItemModel(
                product: ProductModel(
                  id: '2',
                  image: 'assets/images/kemis_red.jpg',
                  title: 'Red Heritage Kemis',
                  price: 'ETB 2,500',
                  rating: '4.8 (98)',
                ),
                size: 'L',
                quantity: 1,
              ),
            ],
          ),
        ) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartCleared>((_, emit) => emit(const CartState()));
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final updated = List<CartItemModel>.from(state.items);
    final index = updated.indexWhere(
      (i) => i.product.id == event.product.id && i.size == event.size,
    );

    if (index >= 0) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
    } else {
      updated.add(CartItemModel(product: event.product, size: event.size));
    }

    emit(state.copyWith(items: updated));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updated = state.items
        .where((i) => !(i.product.id == event.productId && i.size == event.size))
        .toList();
    emit(state.copyWith(items: updated));
  }

  void _onQuantityChanged(CartQuantityChanged event, Emitter<CartState> emit) {
    final updated = <CartItemModel>[];

    for (final item in state.items) {
      if (item.product.id == event.productId && item.size == event.size) {
        final nextQty = item.quantity + event.delta;
        if (nextQty > 0) {
          updated.add(item.copyWith(quantity: nextQty));
        }
      } else {
        updated.add(item);
      }
    }

    emit(state.copyWith(items: updated));
  }
}