import 'package:baqalty/core/network/dio/dio_helper.dart';
import '../models/add_to_cart_request_model.dart';
import '../models/add_to_cart_response_model.dart';
import '../models/cart_response_model.dart';
import '../models/update_cart_request_model.dart';
import '../models/cart_minus_request_model.dart';
import '../models/cart_minus_response_model.dart';
import '../models/remove_item_request_model.dart';
import '../models/remove_item_response_model.dart';
import '../models/clear_cart_response_model.dart';
import '../models/save_cart_request_model.dart';
import '../models/save_cart_response_model.dart';

abstract class CartService {
  Future<ApiResponse<AddToCartResponseModel>> addToCart(AddToCartRequestModel request);
  Future<ApiResponse<CartResponseModel>> getAllCart();
  Future<ApiResponse<CartResponseModel>> updateCartItem(UpdateCartItemRequestModel request);
  Future<ApiResponse<CartResponseModel>> removeCartItem(RemoveCartItemRequestModel request);
  Future<ApiResponse<CartMinusResponseModel>> cartMinus(CartMinusRequestModel request);
  Future<ApiResponse<RemoveItemResponseModel>> removeItem(RemoveItemRequestModel request);
  Future<ApiResponse<ClearCartResponseModel>> clearCart();
  Future<ApiResponse<SaveCartResponseModel>> saveCart(SaveCartRequestModel request);
}
