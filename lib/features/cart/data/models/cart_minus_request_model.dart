import 'package:equatable/equatable.dart';

class CartMinusRequestModel extends Equatable {
  final int productId;
  final int quantity;
  final int? sharedCartId;

  const CartMinusRequestModel({
    required this.productId,
    required this.quantity,
    this.sharedCartId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'quantity': quantity,
    };
    
    if (sharedCartId != null) {
      data['shared_cart_id'] = sharedCartId;
    }
    
    return data;
  }

  @override
  List<Object?> get props => [productId, quantity];
}
