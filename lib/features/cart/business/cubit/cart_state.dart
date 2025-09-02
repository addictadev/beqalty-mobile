part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> cartItems;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final bool isCartSaved;

  const CartLoaded({
    required this.cartItems,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.isCartSaved,
  });

  @override
  List<Object> get props => [
    cartItems,
    subTotal,
    deliveryFee,
    discount,
    total,
    isCartSaved,
  ];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
