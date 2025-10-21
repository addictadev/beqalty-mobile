import 'package:equatable/equatable.dart';

class OrderDetailsResponseModel extends Equatable {
  final bool success;
  final String message;
  final OrderDetailsDataModel data;
  final int code;

  const OrderDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory OrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderDetailsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'code': code,
    };
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class OrderDetailsDataModel extends Equatable {
  final int id;
  final String code;
  final String deliveryFees;
  final String discountValue;
  final String status;
  final String totalPrice;
  final int itemsCount;
  final List<OrderItemDetailsModel> items;
  final List<OrderPaymentModel> payments;
  final String warehouse;
  final OrderAddressModel address;
  final bool canRating;
  final bool isRating;
  final dynamic rating;

  const OrderDetailsDataModel({
    required this.id,
    required this.code,
    required this.deliveryFees,
    required this.discountValue,
    required this.status,
    required this.totalPrice,
    required this.itemsCount,
    required this.items,
    required this.payments,
    required this.warehouse,
    required this.address,
    required this.canRating,
    required this.isRating,
    required this.rating,
  });

  factory OrderDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsDataModel(
      id: json['id'] as int,
      code: json['code'] as String,
      deliveryFees: json['delivery_fees'] as String,
      discountValue: json['discount_value'] as String,
      status: json['status'] as String,
      totalPrice: json['total_price'] as String,
      itemsCount: json['items_count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemDetailsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((payment) => OrderPaymentModel.fromJson(payment as Map<String, dynamic>))
          .toList(),
      warehouse: json['warehouse'] as String,
      address: OrderAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      canRating: json['can_rating'] as bool,
      isRating: json['is_rating'] as bool,
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'delivery_fees': deliveryFees,
      'discount_value': discountValue,
      'status': status,
      'total_price': totalPrice,
      'items_count': itemsCount,
      'items': items.map((item) => item.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'warehouse': warehouse,
      'address': address.toJson(),
      'can_rating': canRating,
      'is_rating': isRating,
      'rating': rating,
    };
  }

  @override
  List<Object?> get props => [
        id,
        code,
        deliveryFees,
        discountValue,
        status,
        totalPrice,
        itemsCount,
        items,
        payments,
        warehouse,
        address,
        canRating,
        isRating,
        rating,
      ];
}

class OrderItemDetailsModel extends Equatable {
  final int productId;
  final String name;
  final int quantity;
  final String total;

  const OrderItemDetailsModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.total,
  });

  factory OrderItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemDetailsModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      total: json['total'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'total': total,
    };
  }

  @override
  List<Object?> get props => [productId, name, quantity, total];
}

class OrderPaymentModel extends Equatable {
  final int id;
  final String amount;
  final String type;
  final String status;

  const OrderPaymentModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
  });

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentModel(
      id: json['id'] as int,
      amount: json['amount'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [id, amount, type, status];
}

class OrderAddressModel extends Equatable {
  final String city;
  final String street;
  final String? details;

  const OrderAddressModel({
    required this.city,
    required this.street,
    this.details,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderAddressModel(
      city: json['city'] as String,
      street: json['street'] as String,
      details: json['details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'details': details,
    };
  }

  @override
  List<Object?> get props => [city, street, details];
}
