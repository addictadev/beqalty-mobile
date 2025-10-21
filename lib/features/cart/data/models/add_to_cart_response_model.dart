class AddToCartResponseModel {
  final bool success;
  final String message;
  final int code;
  final AddToCartDataModel? data;
  final String timestamp;

  AddToCartResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    required this.timestamp,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'] != null 
          ? AddToCartDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'AddToCartResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddToCartResponseModel &&
        other.success == success &&
        other.message == message &&
        other.code == code &&
        other.data == data &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return success.hashCode ^
        message.hashCode ^
        code.hashCode ^
        data.hashCode ^
        timestamp.hashCode;
  }
}

class AddToCartDataModel {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final String addedAt;
  final String createdAt;
  final String updatedAt;

  AddToCartDataModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddToCartDataModel.fromJson(Map<String, dynamic> json) {
    return AddToCartDataModel(
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
  String toString() {
    return 'AddToCartDataModel(id: $id, cartId: $cartId, productId: $productId, quantity: $quantity, addedAt: $addedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddToCartDataModel &&
        other.id == id &&
        other.cartId == cartId &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.addedAt == addedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cartId.hashCode ^
        productId.hashCode ^
        quantity.hashCode ^
        addedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
