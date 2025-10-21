import 'package:equatable/equatable.dart';

class CheckoutResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final CheckoutDataModel data;
  final String timestamp;

  const CheckoutResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: CheckoutDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
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

class CheckoutDataModel extends Equatable {
  final int cartId;
  final int addressId;
  final int warehouseId;
  final int availableQty;
  final List<CheckoutItemModel> items;
  final int subtotal;
  final String deliveryFee;
  final int total;
  final bool warning;
  final List<PaymentTypeModel> paymentTypes;
  final WalletStatusModel walletStatus;

  const CheckoutDataModel({
    required this.cartId,
    required this.addressId,
    required this.warehouseId,
    required this.availableQty,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.warning,
    required this.paymentTypes,
    required this.walletStatus,
  });

  factory CheckoutDataModel.fromJson(Map<String, dynamic> json) {
    return CheckoutDataModel(
      cartId: json['cart_id'] as int,
      addressId: json['address_id'] as int,
      warehouseId: json['warehouse_id'] as int,
      availableQty: json['available_qty'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => CheckoutItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as int,
      deliveryFee: json['delivery_fee'] as String,
      total: json['total'] as int,
      warning: json['warning'] as bool,
      paymentTypes: (json['payment_types'] as List<dynamic>)
          .map((type) => PaymentTypeModel.fromJson(type as Map<String, dynamic>))
          .toList(),
      walletStatus: WalletStatusModel.fromJson(json['wallet_status'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'address_id': addressId,
      'warehouse_id': warehouseId,
      'available_qty': availableQty,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total': total,
      'warning': warning,
      'payment_types': paymentTypes.map((type) => type.toJson()).toList(),
      'wallet_status': walletStatus.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        cartId,
        addressId,
        warehouseId,
        availableQty,
        items,
        subtotal,
        deliveryFee,
        total,
        warning,
        paymentTypes,
        walletStatus,
      ];
}

class CheckoutItemModel extends Equatable {
  final int productId;
  final int quantity;
  final String productName;
  final String finalPrice;
  final int subtotal;
  final bool isAvailable;
  final String statusMessage;

  const CheckoutItemModel({
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.finalPrice,
    required this.subtotal,
    required this.isAvailable,
    required this.statusMessage,
  });

  factory CheckoutItemModel.fromJson(Map<String, dynamic> json) {
    return CheckoutItemModel(
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      productName: json['product_name'] as String,
      finalPrice: json['final_price'] as String,
      subtotal: json['subtotal'] as int,
      isAvailable: json['is_available'] as bool,
      statusMessage: json['status_message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'product_name': productName,
      'final_price': finalPrice,
      'subtotal': subtotal,
      'is_available': isAvailable,
      'status_message': statusMessage,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        quantity,
        productName,
        finalPrice,
        subtotal,
        isAvailable,
        statusMessage,
      ];
}

class PaymentTypeModel extends Equatable {
  final int id;
  final String name;

  const PaymentTypeModel({
    required this.id,
    required this.name,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class WalletStatusModel extends Equatable {
  final bool canOrder;
  final String? message;

  const WalletStatusModel({
    required this.canOrder,
    this.message,
  });

  factory WalletStatusModel.fromJson(Map<String, dynamic> json) {
    return WalletStatusModel(
      canOrder: json['can_order'] as bool,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_order': canOrder,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [canOrder, message];
}
