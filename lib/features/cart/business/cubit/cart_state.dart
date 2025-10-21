part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartItemAdded extends CartState {
  final AddToCartResponseModel cartItem;

  const CartItemAdded({required this.cartItem});

  @override
  List<Object> get props => [cartItem];
}

final class CartLoaded extends CartState {
  final CartDataModel cartData;

  const CartLoaded({required this.cartData});

  @override
  List<Object> get props => [cartData];
}

final class CartUpdated extends CartState {
  final CartDataModel cartData;

  const CartUpdated({required this.cartData});

  @override
  List<Object> get props => [cartData];
}

final class CartItemRemoved extends CartState {
  final CartDataModel cartData;

  const CartItemRemoved({required this.cartData});

  @override
  List<Object> get props => [cartData];
}

final class CartCleared extends CartState {
  final String message;

  const CartCleared({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartEmpty extends CartState {
  final String message;

  const CartEmpty({required this.message});

  @override
  List<Object> get props => [message];
}

final class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}