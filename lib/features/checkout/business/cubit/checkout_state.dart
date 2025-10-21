part of 'checkout_cubit.dart';

abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final CheckoutDataModel checkoutData;

  const CheckoutLoaded({required this.checkoutData});
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});
}

class CreateOrderLoading extends CheckoutState {}

class CreateOrderSuccess extends CheckoutState {
  final CreateOrderDataModel orderData;

  const CreateOrderSuccess({required this.orderData});
}

class CreateOrderError extends CheckoutState {
  final String message;

  const CreateOrderError({required this.message});
}

class ApplyDiscountLoading extends CheckoutState {}

class ApplyDiscountSuccess extends CheckoutState {
  final ApplyDiscountResponseModel discountData;

  const ApplyDiscountSuccess({required this.discountData});
}

class ApplyDiscountError extends CheckoutState {
  final String message;
  final List<String>? errors;

  const ApplyDiscountError({required this.message, this.errors});
}
