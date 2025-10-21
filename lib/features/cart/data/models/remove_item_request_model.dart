import 'package:equatable/equatable.dart';

class RemoveItemRequestModel extends Equatable {
  final int productId;

  const RemoveItemRequestModel({
    required this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
    };
  }

  @override
  List<Object?> get props => [productId];
}
