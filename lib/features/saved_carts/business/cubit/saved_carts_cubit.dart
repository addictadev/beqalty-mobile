import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/saved_carts_response_model.dart';
import '../../data/models/create_saved_cart_request_model.dart';
import '../../data/models/create_saved_cart_response_model.dart';
import '../../data/services/saved_carts_service.dart';

part 'saved_carts_state.dart';

/// Cubit for managing saved carts state
/// Handles loading, displaying, and error states for saved carts
class SavedCartsCubit extends Cubit<SavedCartsState> {
  final SavedCartsService _savedCartsService;

  SavedCartsCubit(this._savedCartsService) : super(SavedCartsInitial());

  /// Fetches all saved carts
  /// 
  /// [search] - Optional search query to filter saved carts
  /// Emits [SavedCartsLoading] while fetching
  /// Emits [SavedCartsLoaded] on success with saved carts data
  /// Emits [SavedCartsError] on failure with error message
  Future<void> getAllSavedCarts({String? search}) async {
    try {
      emit(SavedCartsLoading());

      final response = await _savedCartsService.getAllSavedCarts(search: search);
      emit(SavedCartsLoaded(savedCarts: response.data));
    } catch (e) {
      emit(SavedCartsError(message: e.toString()));
    }
  }

  /// Refreshes the saved carts list
  Future<void> refreshSavedCarts() async {
    await getAllSavedCarts();
  }

  /// Creates a new saved cart
  /// 
  /// [name] - The name for the new saved cart
  /// Emits [CreateSavedCartLoading] while creating
  /// Emits [CreateSavedCartSuccess] on success with created cart data
  /// Emits [CreateSavedCartError] on failure with error message
  Future<void> createSavedCart({required String name}) async {
    try {
      emit(CreateSavedCartLoading());

      final request = CreateSavedCartRequestModel(name: name);
      final response = await _savedCartsService.createSavedCart(request: request);
      
      emit(CreateSavedCartSuccess(cartData: response.data!));
    } catch (e) {
      emit(CreateSavedCartError(message: e.toString()));
    }
  }

  /// Deletes a saved cart by ID
  /// 
  /// [cartId] - The ID of the saved cart to delete
  /// Emits [DeleteSavedCartLoading] while deleting
  /// Emits [DeleteSavedCartSuccess] on success with deleted cart ID
  /// Emits [DeleteSavedCartError] on failure with error message
  Future<void> deleteSavedCart({required int cartId}) async {
    try {
      emit(DeleteSavedCartLoading());
      await _savedCartsService.deleteSavedCart(cartId: cartId);
            emit(DeleteSavedCartSuccess(deletedCartId: cartId));
    } catch (e) {

      emit(DeleteSavedCartError(message: e.toString()));
    }
  }

  /// Resets the state to initial
  void reset() {
    emit(SavedCartsInitial());
  }
}
