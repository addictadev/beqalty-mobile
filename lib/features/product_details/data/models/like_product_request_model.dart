import 'package:equatable/equatable.dart';

class LikeProductRequestModel extends Equatable {
  final int productId;

  const LikeProductRequestModel({
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
