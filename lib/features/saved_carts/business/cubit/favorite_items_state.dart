part of 'favorite_items_cubit.dart';

/// Base state for favorite items
abstract class FavoriteItemsState extends Equatable {
  const FavoriteItemsState();

  @override
  List<Object> get props => [];
}

/// Initial state when the cubit is first created
final class FavoriteItemsInitial extends FavoriteItemsState {
  const FavoriteItemsInitial();
}

/// State when favorite items are being loaded
final class FavoriteItemsLoading extends FavoriteItemsState {
  const FavoriteItemsLoading();
}

/// State when favorite items are successfully loaded
final class FavoriteItemsLoaded extends FavoriteItemsState {
  final List<FavoriteItemModel> favoriteItems;

  const FavoriteItemsLoaded({required this.favoriteItems});

  @override
  List<Object> get props => [favoriteItems.length, ...favoriteItems];

  @override
  String toString() => 'FavoriteItemsLoaded(favoriteItems: ${favoriteItems.length} items)';
}

/// State when there's an error loading favorite items
final class FavoriteItemsError extends FavoriteItemsState {
  final String message;

  const FavoriteItemsError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'FavoriteItemsError(message: $message)';
}
