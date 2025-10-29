import 'package:equatable/equatable.dart';

class RemoveItemRequestModel extends Equatable {
  final int productId;
  final int? sharedCartId;

  const RemoveItemRequestModel({
    required this.productId,
    this.sharedCartId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
    };
    
    if (sharedCartId != null) {
      data['shared_cart_id'] = sharedCartId;
    }
    
    return data;
  }

  @override
  List<Object?> get props => [productId];
}
