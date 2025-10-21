import 'package:equatable/equatable.dart';
import 'package:baqalty/features/cart/data/models/cart_response_model.dart';

abstract class SharedCartState extends Equatable {
  const SharedCartState();

  @override
  List<Object?> get props => [];
}

class SharedCartInitial extends SharedCartState {}

class SharedCartLoading extends SharedCartState {}

class SharedCartLoaded extends SharedCartState {
  final CartResponseModel cartData;

  const SharedCartLoaded(this.cartData);

  @override
  List<Object?> get props => [cartData];
}

class SharedCartError extends SharedCartState {
  final String message;

  const SharedCartError(this.message);

  @override
  List<Object?> get props => [message];
}
