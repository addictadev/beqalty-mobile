import 'package:equatable/equatable.dart';

class CartMinusResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final CartMinusDataModel data;

  const CartMinusResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory CartMinusResponseModel.fromJson(Map<String, dynamic> json) {
    return CartMinusResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: CartMinusDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [success, message, code, data];
}

class CartMinusDataModel extends Equatable {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final String addedAt;
  final String createdAt;
  final String updatedAt;

  const CartMinusDataModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartMinusDataModel.fromJson(Map<String, dynamic> json) {
    return CartMinusDataModel(
      id: json['id'] as int,
      cartId: json['cart_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      addedAt: json['added_at'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cartId,
        productId,
        quantity,
        addedAt,
        createdAt,
        updatedAt,
      ];
}
