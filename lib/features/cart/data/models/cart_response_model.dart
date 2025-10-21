import 'package:equatable/equatable.dart';

class CartResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final CartDataModel? data;
  final String timestamp;

  const CartResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    required this.timestamp,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'] != null 
          ? CartDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String,
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
  List<Object?> get props => [success, message, code, data, timestamp];
}

class CartDataModel extends Equatable {
  final int id;
  final int userId;
  final String cartType;
  final String? name;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  final int warehouseId;
  final List<CartItemModel> items;
  final int cartTotal;
  final String deliveryFee;
  final int cartFinalTotal;
  final bool isSharedCart;
  final String url_shared_cart;
  final dynamic shared_cart_id;
  final dynamic shared_user_id;

  const CartDataModel({
    required this.id,
    required this.userId,
    required this.cartType,
    this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.warehouseId,
    required this.items,
    required this.cartTotal,
    required this.deliveryFee,
    required this.cartFinalTotal,
    required this.isSharedCart,
    required this.url_shared_cart,
    required this.shared_cart_id,
    required this.shared_user_id,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cartType: json['cart_type'] as String,
      name: json['name'] as String?,
      isActive: json['is_active'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      warehouseId: json['warhouse_id'] as int, // Note: API has typo "warhouse_id"
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      cartTotal: json['cart_total'] as int,
      deliveryFee: json['delivery_fee'] as String,
      cartFinalTotal: json['cart_final_total'] as int,
      isSharedCart: json['is_shared_cart'] as bool,
      url_shared_cart: json['url_shared_cart'] as String,
      shared_cart_id: json['shared_cart_id'] as dynamic,
      shared_user_id: json['shared_user_id'] as dynamic,
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
      'warhouse_id': warehouseId, // Note: API has typo "warhouse_id"
      'items': items.map((item) => item.toJson()).toList(),
      'cart_total': cartTotal,
      'delivery_fee': deliveryFee,
      'cart_final_total': cartFinalTotal,
      'is_shared_cart': isSharedCart,
      'url_shared_cart': url_shared_cart,
      'shared_cart_id': shared_cart_id,
      'shared_user_id': shared_user_id,
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
        isSharedCart,
        url_shared_cart,
        shared_cart_id,
        shared_user_id,
      ];
}

class CartItemModel extends Equatable {
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

  const CartItemModel({
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
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
