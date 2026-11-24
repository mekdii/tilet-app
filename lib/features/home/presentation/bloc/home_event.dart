import 'package:equatable/equatable.dart';

sealed class HomeEvent  extends Equatable{
  const HomeEvent();


  @override
  List<Object?> get props => []; 


}
final class HomeStarted extends HomeEvent{
  const HomeStarted();
}

final class HomeTabChanged extends HomeEvent{
  const HomeTabChanged(this.index);
  final int index;

  @override 
  List<Object?> get props => [index];
}

final class HomeFavoriteToggled extends HomeEvent{
  const HomeFavoriteToggled(this.productId);
  final String productId;

  @override 
  List<Object?> get props => [productId];
  
  }

  final class HomeCategorySelected extends HomeEvent {
  const HomeCategorySelected(this.categoryId);

  /// `null` means "All"
  final int? categoryId;

  @override
  List<Object?> get props => [categoryId];
}
