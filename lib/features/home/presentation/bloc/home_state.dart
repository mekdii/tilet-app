import 'package:equatable/equatable.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

class HomeState extends Equatable{
  const HomeState({
    this.selectedTab = 0,
    this.cartCount = 2,
    this.products = const []

  });

  final int selectedTab;
  final int cartCount;
  final List<ProductModel> products;


HomeState copyWith({
  int? selectedTab,
  int? cartCount,
  List <ProductModel>? products,
}){
  return HomeState(
    selectedTab: selectedTab ?? this.selectedTab,
    cartCount:  cartCount ?? this.cartCount,
    products: products ?? this.products
  );

}

@override
  List<Object?> get props => [selectedTab, cartCount, products];


}