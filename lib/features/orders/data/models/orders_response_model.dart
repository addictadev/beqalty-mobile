import 'package:equatable/equatable.dart';

class OrdersResponseModel extends Equatable {
  final bool success;
  final String message;
  final List<OrderDataModel> data;
  final int code;

  const OrdersResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => OrderDataModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'code': code,
    };
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class OrderDataModel extends Equatable {
  final int id;
  final String code;
  final String status;
  final String totalPrice;
  final int itemsCount;

  const OrderDataModel({
    required this.id,
    required this.code,
    required this.status,
    required this.totalPrice,
    required this.itemsCount,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDataModel(
      id: json['id'] as int,
      code: json['code'] as String,
      status: json['status'] as String,
      totalPrice: json['total_price'] as String,
      itemsCount: json['items_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'status': status,
      'total_price': totalPrice,
      'items_count': itemsCount,
    };
  }

  @override
  List<Object?> get props => [id, code, status, totalPrice, itemsCount];
}
