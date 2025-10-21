import 'package:equatable/equatable.dart';

class CartMinusRequestModel extends Equatable {
  final int productId;
  final int quantity;

  const CartMinusRequestModel({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [productId, quantity];
}
