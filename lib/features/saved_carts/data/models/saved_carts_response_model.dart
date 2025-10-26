import 'package:equatable/equatable.dart';

class SavedCartsResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final List<SavedCartDataModel> data;
  final String? timestamp;

  const SavedCartsResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    this.timestamp,
  });

  factory SavedCartsResponseModel.fromJson(Map<String, dynamic> json) {
    return SavedCartsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => SavedCartDataModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [success, message, code, data, timestamp];
}

class SavedCartDataModel extends Equatable {
  final int id;
  final int userId;
  final String cartType;
  final String name;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  final List<SavedCartItemDataModel> items;
  final int cartTotal;

  const SavedCartDataModel({
    required this.id,
    required this.userId,
    required this.cartType,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.cartTotal,
  });

  factory SavedCartDataModel.fromJson(Map<String, dynamic> json) {
    return SavedCartDataModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cartType: json['cart_type'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => SavedCartItemDataModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cartTotal: json['cart_total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'cart_type': cartType,
      'name': name,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'items': items.map((item) => item.toJson()).toList(),
      'cart_total': cartTotal,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        cartType,
        name,
        isActive,
        createdAt,
        updatedAt,
        items,
        cartTotal,
      ];
}

class SavedCartItemDataModel extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final String? subcategoryName;

  const SavedCartItemDataModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    this.subcategoryName,
  });

  factory SavedCartItemDataModel.fromJson(Map<String, dynamic> json) {
    return SavedCartItemDataModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      productImage: json['base_image'] as String, // Fixed field name
      quantity: json['quantity'] as int,
      price: double.parse(json['final_price'] as String), // Fixed field name and parsing
      subcategoryName: json['subcategory_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'base_image': productImage,
      'quantity': quantity,
      'final_price': price.toString(),
      if (subcategoryName != null) 'subcategory_name': subcategoryName,
    };
  }

  @override
  List<Object?> get props => [id, productId, productName, productImage, quantity, price, subcategoryName];
}
