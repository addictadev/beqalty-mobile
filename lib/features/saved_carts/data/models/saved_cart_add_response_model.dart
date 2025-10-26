import 'package:equatable/equatable.dart';

class SavedCartAddResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final SavedCartAddDataModel data;

  const SavedCartAddResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory SavedCartAddResponseModel.fromJson(Map<String, dynamic> json) {
    return SavedCartAddResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: SavedCartAddDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, code, data];
}

class SavedCartAddDataModel extends Equatable {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final String addedAt;
  final String createdAt;
  final String updatedAt;

  const SavedCartAddDataModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedCartAddDataModel.fromJson(Map<String, dynamic> json) {
    return SavedCartAddDataModel(
      id: json['id'] as int,
      cartId: json['cart_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      addedAt: json['added_at'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'added_at': addedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, cartId, productId, quantity, addedAt, createdAt, updatedAt];
}
