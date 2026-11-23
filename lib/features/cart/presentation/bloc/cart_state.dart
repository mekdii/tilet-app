import 'package:equatable/equatable.dart';
import 'package:tilet/features/cart/data/cart_item_model.dart';

class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItemModel> items;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => items.fold(0, (sum, item) => sum + item.lineTotal);

  String get formattedTotal {
    final str = totalPrice.toString();
    final formatted = str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'ETB $formatted';
  }

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}