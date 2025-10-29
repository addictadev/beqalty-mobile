import 'package:equatable/equatable.dart';

class UpdateCartItemRequestModel extends Equatable {
  final int cartItemId;
  final int quantity;

  const UpdateCartItemRequestModel({
    required this.cartItemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class RemoveCartItemRequestModel extends Equatable {
  final int cartItemId;

  const RemoveCartItemRequestModel({
    required this.cartItemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
    };
  }

  @override
  List<Object?> get props => [cartItemId];
}
