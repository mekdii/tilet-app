import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/home/data/models/category_model.dart';
import 'package:tilet/features/home/data/repositories/product_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({ProductRepository? repository})
      : _repository = repository ?? ProductRepository(),
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeFavoriteToggled>(_onFavoriteToggled);
  }

  final ProductRepository _repository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final products = await _repository.fetchProducts();
      List<CategoryModel> categories = [];

      try {
        categories = await _repository.fetchCategories();
      } catch (_) {
        // Fallback if /api/categories/ isn't available yet: derive from products
        final names = products
            .map((p) => p.categoryName)
            .where((n) => n.isNotEmpty)
            .toSet()
            .toList();
        categories = [
          for (var i = 0; i < names.length; i++)
            CategoryModel(id: i + 1, name: names[i]),
        ];
      }

      emit(state.copyWith(
        products: products,
        categories: categories,
        isLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load collection. Pull to retry.',
      ));
    }
  }

  Future<void> _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) async {
    if (event.categoryId == state.selectedCategoryId) return;

    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      clearCategory: event.categoryId == null,
      isLoading: true,
      errorMessage: null,
    ));

    try {
      final products = await _repository.fetchProducts(
        categoryId: event.categoryId,
      );
      emit(state.copyWith(products: products, isLoading: false));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load this category.',
      ));
    }
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }

  void _onFavoriteToggled(
    HomeFavoriteToggled event,
    Emitter<HomeState> emit,
  ) {
    final updated = state.products.map((p) {
      if (p.id == event.productId) {
        return p.copyWith(isFavorite: !p.isFavorite);
      }
      return p;
    }).toList();
    emit(state.copyWith(products: updated));
  }
}