import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
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
import 'cart_service.dart';

class CartServiceImpl implements CartService {
  @override
  Future<ApiResponse<AddToCartResponseModel>> addToCart(AddToCartRequestModel request) async {
    return await DioHelper.post<AddToCartResponseModel>(
      EndPoints.addToCart,
      data: request.toJson(),
      requiresAuth: true,
      fromJson: (json) => AddToCartResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<CartResponseModel>> getAllCart() async {
    return await DioHelper.get<CartResponseModel>(
      EndPoints.getAllCart,
      requiresAuth: true,
      fromJson: (json) => CartResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<CartResponseModel>> updateCartItem(UpdateCartItemRequestModel request) async {
    return await DioHelper.put<CartResponseModel>(
      EndPoints.updateCartItem,
      requiresAuth: true,
      data: request.toJson(),
      fromJson: (json) => CartResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<CartResponseModel>> removeCartItem(RemoveCartItemRequestModel request) async {
    return await DioHelper.delete<CartResponseModel>(
      EndPoints.removeCartItem,
      requiresAuth: true,
      data: request.toJson(),
      fromJson: (json) => CartResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<CartMinusResponseModel>> cartMinus(CartMinusRequestModel request) async {
    return await DioHelper.post<CartMinusResponseModel>(
      EndPoints.cartMinus,
      requiresAuth: true,
      data: request.toJson(),
      fromJson: (json) => CartMinusResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<RemoveItemResponseModel>> removeItem(RemoveItemRequestModel request) async {
    return await DioHelper.post<RemoveItemResponseModel>(
      EndPoints.removeItem,
      requiresAuth: true,
      data: request.toJson(),
      fromJson: (json) => RemoveItemResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<ClearCartResponseModel>> clearCart() async {
    return await DioHelper.post<ClearCartResponseModel>(
      EndPoints.clearCart,
      requiresAuth: true,
      fromJson: (json) => ClearCartResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<SaveCartResponseModel>> saveCart(SaveCartRequestModel request) async {
    return await DioHelper.post<SaveCartResponseModel>(
      EndPoints.saveMainCart,
      data: request.toFormData(),
      requiresAuth: true,
      fromJson: (json) => SaveCartResponseModel.fromJson(json),
    );
  }
}
