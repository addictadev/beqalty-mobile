import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/add_to_cart_request_model.dart';
import '../../data/models/add_to_cart_response_model.dart';
import '../../data/models/cart_response_model.dart';
import '../../data/models/update_cart_request_model.dart';
import '../../data/models/cart_minus_request_model.dart';
import '../../data/models/remove_item_request_model.dart';
import '../../data/services/cart_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService;

  CartCubit(this._cartService) : super(CartInitial());

  /// Adds a product to the cart
  Future<void> addToCart({
    required int productId,
    required int quantity,
    required int warehouseId,
  }) async {
    try {
      log('CartCubit: Starting addToCart with productId: $productId, quantity: $quantity');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final request = AddToCartRequestModel(
        productId: productId,
        quantity: quantity,
        warehouseId: warehouseId,
      );

      final response = await _cartService.addToCart(request);
      log('CartCubit: Received response - status: ${response.status}, data: ${response.data}');

      if (response.status && response.data != null) {
        log('CartCubit: Emitting CartItemAdded with message: ${response.data!.message}');
        emit(CartItemAdded(cartItem: response.data!));
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to add item to cart'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Gets all cart items
  Future<void> getAllCart() async {
    try {
      log('CartCubit: Starting getAllCart');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final response = await _cartService.getAllCart();
      log('CartCubit: Received getAllCart response - status: ${response.status}, data: ${response.data}');

      if (response.status) {
        if (response.data != null && response.data!.data != null) {
          log('CartCubit: Emitting CartLoaded with ${response.data!.data!.items.length} items');
          emit(CartLoaded(cartData: response.data!.data!));
        } else {
          // Cart is empty - treat as empty state, not error
          log('CartCubit: Cart is empty, emitting CartEmpty');
          emit(CartEmpty(message: response.message ?? 'Cart is empty'));
        }
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to load cart'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred in getAllCart: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Updates cart item quantity using appropriate endpoints for increase and decrease
  Future<void> updateCartItem({
    required int cartItemId,
    required int productId,
    required int currentQuantity,
    required int newQuantity,
  }) async {
    try {
      log('CartCubit: Starting updateCartItem with cartItemId: $cartItemId, currentQuantity: $currentQuantity, newQuantity: $newQuantity');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final quantityDifference = newQuantity - currentQuantity;
      log('CartCubit: Quantity difference: $quantityDifference');

      if (quantityDifference > 0) {
        // Increasing quantity - use addToCart endpoint to add more items
        final request = AddToCartRequestModel(
          productId: productId,
          quantity: quantityDifference,
          warehouseId: 1, // Default warehouse ID - you might want to get this from user location or settings
        );

        final response = await _cartService.addToCart(request);
        log('CartCubit: Received addToCart response for increase - status: ${response.status}, data: ${response.data}');

        if (response.status && response.data != null) {
          log('CartCubit: addToCart successful for increase, refreshing cart data');
          await getAllCart();
        } else {
          log('CartCubit: Emitting CartError with message: ${response.message}');
          emit(CartError(message: response.message ?? 'Failed to increase cart item quantity'));
        }
      } else if (quantityDifference < 0) {
        // Decreasing quantity - use cart minus endpoint
        final request = CartMinusRequestModel(
          productId: productId,
          quantity: quantityDifference.abs(),
        );

        final response = await _cartService.cartMinus(request);
        log('CartCubit: Received cartMinus response for decrease - status: ${response.status}, data: ${response.data}');

        if (response.status && response.data != null) {
          log('CartCubit: cartMinus successful for decrease, refreshing cart data');
          await getAllCart();
        } else {
          log('CartCubit: Emitting CartError with message: ${response.message}');
          emit(CartError(message: response.message ?? 'Failed to decrease cart item quantity'));
        }
      }
    } catch (e) {
      log('CartCubit: Exception occurred in updateCartItem: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Removes cart item
  Future<void> removeCartItem({
    required int cartItemId,
  }) async {
    try {
      log('CartCubit: Starting removeCartItem with cartItemId: $cartItemId');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final request = RemoveCartItemRequestModel(
        cartItemId: cartItemId,
      );

      final response = await _cartService.removeCartItem(request);
      log('CartCubit: Received removeCartItem response - status: ${response.status}, data: ${response.data}');

      if (response.status && response.data != null) {
        log('CartCubit: removeCartItem successful, refreshing cart data');
        // Call getAllCart to get updated cart data
        await getAllCart();
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to remove cart item'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred in removeCartItem: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Decreases cart item quantity using the minus endpoint
  Future<void> cartMinus({
    required int productId,
    required int quantity,
  }) async {
    try {
      log('CartCubit: Starting cartMinus with productId: $productId, quantity: $quantity');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final request = CartMinusRequestModel(
        productId: productId,
        quantity: quantity,
      );

      final response = await _cartService.cartMinus(request);
      log('CartCubit: Received cartMinus response - status: ${response.status}, data: ${response.data}');

      if (response.status && response.data != null) {
        log('CartCubit: cartMinus successful, refreshing cart data');
        // Call getAllCart to get updated cart data
        await getAllCart();
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to update cart item quantity'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred in cartMinus: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Removes item completely from cart using product_id
  Future<void> removeItem({
    required int productId,
  }) async {
    try {
      log('CartCubit: Starting removeItem with productId: $productId');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final request = RemoveItemRequestModel(
        productId: productId,
      );

      final response = await _cartService.removeItem(request);
      log('CartCubit: Received removeItem response - status: ${response.status}, data: ${response.data}');

      if (response.status && response.data != null) {
        log('CartCubit: removeItem successful with message: ${response.data!.message}, refreshing cart data');
        // Call getAllCart to get updated cart data
        await getAllCart();
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to remove item from cart'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred in removeItem: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Clears all items from the cart
  Future<void> clearCart() async {
    try {
      log('CartCubit: Starting clearCart');
      emit(CartLoading());
      log('CartCubit: Emitted CartLoading state');

      final response = await _cartService.clearCart();
      log('CartCubit: Received clearCart response - status: ${response.status}, data: ${response.data}');

      if (response.status && response.data != null) {
        log('CartCubit: clearCart successful with message: ${response.data!.message}');
        emit(CartCleared(message: response.data!.message));
      } else {
        log('CartCubit: Emitting CartError with message: ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to clear cart'));
      }
    } catch (e) {
      log('CartCubit: Exception occurred in clearCart: $e');
      emit(CartError(message: e.toString()));
    }
  }

  /// Resets the state to initial
  void reset() {
    emit(CartInitial());
  }
}
