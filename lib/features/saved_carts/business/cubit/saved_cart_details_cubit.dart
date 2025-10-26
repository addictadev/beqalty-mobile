import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/saved_cart_details_response_model.dart';
import '../../data/models/saved_cart_item_action_request_model.dart';
import '../../data/services/saved_carts_service.dart';

part 'saved_cart_details_state.dart';

/// Cubit for managing saved cart details state
/// Handles loading, displaying, and error states for saved cart details
class SavedCartDetailsCubit extends Cubit<SavedCartDetailsState> {
  final SavedCartsService _savedCartsService;

  SavedCartDetailsCubit(this._savedCartsService) : super(SavedCartDetailsInitial());

  /// Fetches saved cart details by ID
  /// 
  /// [cartId] - The ID of the saved cart to retrieve
  /// Emits [SavedCartDetailsLoading] while fetching
  /// Emits [SavedCartDetailsLoaded] on success with cart details
  /// Emits [SavedCartDetailsError] on failure with error message
  Future<void> getSavedCartDetails(int cartId) async {
    try {
      emit(SavedCartDetailsLoading());

      final response = await _savedCartsService.getSavedCartDetails(cartId);
      emit(SavedCartDetailsLoaded(cartDetails: response.data));
    } catch (e) {
      emit(SavedCartDetailsError(message: e.toString()));
    }
  }

  /// Increases the quantity of an item in the saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [productId] - The ID of the product to increase quantity for
  /// Emits [SavedCartDetailsUpdated] on success with updated cart details
  /// Emits [SavedCartDetailsError] on failure with error message
  Future<void> increaseItemQuantity({required int cartId, required int productId, required int warehouseId}) async {
    try {
      final request = SavedCartItemActionRequestModel(productId: productId, quantity: 1, warehouseId: warehouseId);
      await _savedCartsService.plusItemFromSavedCart(
        cartId: cartId,
        request: request,
      );
      // After successful add, refresh the cart details
      await getSavedCartDetails(cartId);
    } catch (e) {
      emit(SavedCartDetailsError(message: e.toString()));
    }
  }

  /// Decreases the quantity of an item in the saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [productId] - The ID of the product to decrease quantity for
  /// Emits [SavedCartDetailsUpdated] on success with updated cart details
  /// Emits [SavedCartDetailsError] on failure with error message
  Future<void> decreaseItemQuantity({required int cartId, required int productId, required int warehouseId}) async {
    try {
      final request = SavedCartItemActionRequestModel(productId: productId, quantity: 1, warehouseId: warehouseId);
      final response = await _savedCartsService.minusItemFromSavedCart(
        cartId: cartId,
        request: request,
      );
      emit(SavedCartDetailsUpdated(cartDetails: response));
    } catch (e) {
      emit(SavedCartDetailsError(message: e.toString()));
    }
  }

  /// Removes an item from the saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [productId] - The ID of the product to remove
  /// Emits [SavedCartDetailsItemRemoved] on success with updated cart details
  /// Emits [SavedCartDetailsError] on failure with error message
  Future<void> removeItem({required int cartId, required int productId, required int warehouseId}) async {
    try {
      final request = SavedCartItemActionRequestModel(productId: productId, quantity: 1, warehouseId: warehouseId);
      final response = await _savedCartsService.removeItemFromSavedCart(
        cartId: cartId,
        request: request,
      );
      emit(SavedCartDetailsItemRemoved(cartDetails: response));
    } catch (e) {
      emit(SavedCartDetailsError(message: e.toString()));
    }
  }
}
