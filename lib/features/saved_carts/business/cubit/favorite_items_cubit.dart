import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/favorite_item_model.dart';
import '../../data/services/favorite_items_service.dart';

part 'favorite_items_state.dart';

/// Cubit for managing favorite items state
/// Handles loading, displaying, and error states for favorite items
class FavoriteItemsCubit extends Cubit<FavoriteItemsState> {
  final FavoriteItemsService _favoriteItemsService;

  FavoriteItemsCubit(this._favoriteItemsService) : super(FavoriteItemsInitial());

  /// Fetches all favorite items with optional search parameter
  /// 
  /// [search] - Optional search query to filter favorite items
  /// 
  /// Emits [FavoriteItemsLoading] while fetching
  /// Emits [FavoriteItemsLoaded] on success with favorite items data
  /// Emits [FavoriteItemsError] on failure with error message
  Future<void> getAllFavoriteItems({String? search}) async {
    try {
      emit(FavoriteItemsLoading());

      final response = await _favoriteItemsService.getAllFavoriteItems(search: search);

      if (response.status && response.data != null) {
        emit(FavoriteItemsLoaded(favoriteItems: response.data!.data.products));
      } else {
        emit(FavoriteItemsError(
          message: response.message ?? 'Failed to load favorite items',
        ));
      }
    } catch (e) {
      emit(FavoriteItemsError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Refreshes the favorite items list
  /// 
  /// [search] - Optional search query to filter favorite items
  Future<void> refreshFavoriteItems({String? search}) async {
    await getAllFavoriteItems(search: search);
  }

  /// Removes an item from the current list
  void removeItem(int index) {
    final currentState = state;
    if (currentState is FavoriteItemsLoaded) {
      final updatedItems = List<FavoriteItemModel>.from(currentState.favoriteItems);
      if (index >= 0 && index < updatedItems.length) {
        updatedItems.removeAt(index);
        emit(FavoriteItemsLoaded(favoriteItems: updatedItems));
      }
    }
  }

  /// Resets the state to initial
  void reset() {
    emit(FavoriteItemsInitial());
  }
}
