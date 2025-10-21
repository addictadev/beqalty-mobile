import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/checkout/data/models/checkout_response_model.dart';
import 'package:baqalty/features/checkout/data/models/create_order_request_model.dart';
import 'package:baqalty/features/checkout/data/models/create_order_response_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_request_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_response_model.dart';
import 'package:baqalty/features/checkout/data/services/checkout_service.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutService _checkoutService;

  CheckoutCubit(this._checkoutService) : super(CheckoutInitial());

  Future<void> checkout({required int cartId}) async {
    emit(CheckoutLoading());
    
    try {
      final response = await _checkoutService.checkout(cartId: cartId);
      emit(CheckoutLoaded(checkoutData: response.data));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  Future<void> createOrder({
    required CreateOrderRequestModel request,
  }) async {
    emit(CreateOrderLoading());
    
    try {
      final response = await _checkoutService.createOrder(request: request);
      
      if (response.success && response.data != null) {
        emit(CreateOrderSuccess(orderData: response.data!));
      } else {
        emit(CreateOrderError(message: response.message));
      }
    } catch (e) {
      emit(CreateOrderError(message: e.toString()));
    }
  }

  Future<void> applyDiscount({
    required ApplyDiscountRequestModel request,
  }) async {
    emit(ApplyDiscountLoading());
    
    try {
      final response = await _checkoutService.applyDiscount(request: request);
      emit(ApplyDiscountSuccess(discountData: response));
    } catch (e) {
      // The service now handles error parsing and returns the specific error message
      emit(ApplyDiscountError(message: e.toString()));
    }
  }

  void resetState() {
    emit(CheckoutInitial());
  }
}
