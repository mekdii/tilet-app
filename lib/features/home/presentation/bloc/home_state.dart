import 'package:equatable/equatable.dart';
import 'package:tilet/features/home/data/models/category_model.dart';
import 'package:tilet/features/home/data/models/product_model.dart';

class HomeState extends Equatable {
  const HomeState({
    this.products = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.selectedTab = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final int selectedTab;
  final bool isLoading;
  final String? errorMessage;

  String get selectedCategoryTitle {
    if (selectedCategoryId == null) return 'All Collection';
    final match = categories.where((c) => c.id == selectedCategoryId);
    return match.isNotEmpty ? match.first.name : 'All Collection';
  }

  HomeState copyWith({
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
    bool clearCategory = false,
    int? selectedTab,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        selectedCategoryId,
        selectedTab,
        isLoading,
        errorMessage,
      ];
}