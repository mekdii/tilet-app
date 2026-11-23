import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/home/data/models/product_model.dart';
import 'package:tilet/features/home/presentation/bloc/home_event.dart';
import 'package:tilet/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeFavoriteToggled>(_onFavoriteToggled);
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        products: const [
          ProductModel(
            id: '1',
            image: 'assets/images/kemis_green.jpg',
            title: 'Green Embroidered Kemis',
            price: 'ETB 2,500',
            rating: '4.8 (120)',
            images: [
              'assets/images/kemis_green.jpg',
              'assets/images/home_hero.jpg',
              'assets/images/kemis_red.jpg',
            ],
          ),
          ProductModel(
            id: '2',
            image: 'assets/images/kemis_red.jpg',
            title: 'Red Heritage Kemis',
            price: 'ETB 2,500',
            rating: '4.8 (98)',
          ),
        ],
      ),
    );
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }

  void _onFavoriteToggled(HomeFavoriteToggled event, Emitter<HomeState> emit) {
    final updated = state.products.map((product) {
      if (product.id == event.productId) {
        return product.copyWith(isFavorite: !product.isFavorite!);
      }
      return product;
    }).toList();

    emit(state.copyWith(products: updated));
  }
}
