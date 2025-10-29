import 'package:equatable/equatable.dart';

class SavedCartDetailsResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final SavedCartDetailsDataModel data;
  final String? timestamp;

  const SavedCartDetailsResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    this.timestamp,
  });

  factory SavedCartDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return SavedCartDetailsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: SavedCartDetailsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [success, message, code, data, timestamp];
}

class SavedCartDetailsDataModel extends Equatable {
  final int id;
  final int userId;
  final String cartType;
  final String name;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  final int warehouseId;
  final List<SavedCartDetailsItemModel> items;
  final int cartTotal;
  final String deliveryFee;
  final int cartFinalTotal;

  const SavedCartDetailsDataModel({
    required this.id,
    required this.userId,
    required this.cartType,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.warehouseId,
    required this.items,
    required this.cartTotal,
    required this.deliveryFee,
    required this.cartFinalTotal,
  });

  factory SavedCartDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return SavedCartDetailsDataModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cartType: json['cart_type'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      warehouseId: json['warehouse_id'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => SavedCartDetailsItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cartTotal: json['cart_total'] as int,
      deliveryFee: json['delivery_fee'] as String,
      cartFinalTotal: json['cart_final_total'] as int,
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
      'warehouse_id': warehouseId,
      'items': items.map((item) => item.toJson()).toList(),
      'cart_total': cartTotal,
      'delivery_fee': deliveryFee,
      'cart_final_total': cartFinalTotal,
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
        warehouseId,
        items,
        cartTotal,
        deliveryFee,
        cartFinalTotal,
      ];
}

class SavedCartDetailsItemModel extends Equatable {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final String baseImage;
  final String productName;
  final String finalPrice;
  final String subcategoryName;
  final bool isAvailable;
  final String statusMessage;

  const SavedCartDetailsItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.baseImage,
    required this.productName,
    required this.finalPrice,
    required this.subcategoryName,
    required this.isAvailable,
    required this.statusMessage,
  });

  factory SavedCartDetailsItemModel.fromJson(Map<String, dynamic> json) {
    return SavedCartDetailsItemModel(
      id: json['id'] as int,
      cartId: json['cart_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      baseImage: json['base_image'] as String,
      productName: json['product_name'] as String,
      finalPrice: json['final_price'] as String,
      subcategoryName: json['subcategory_name'] as String,
      isAvailable: json['is_available'] as bool,
      statusMessage: json['status_message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'base_image': baseImage,
      'product_name': productName,
      'final_price': finalPrice,
      'subcategory_name': subcategoryName,
      'is_available': isAvailable,
      'status_message': statusMessage,
    };
  }

  @override
  List<Object?> get props => [
        id,
        cartId,
        productId,
        quantity,
        baseImage,
        productName,
        finalPrice,
        subcategoryName,
        isAvailable,
        statusMessage,
      ];
}
