class CreateOrderResponseModel {
  final bool success;
  final String message;
  final CreateOrderDataModel? data;
  final int code;
  final String? timestamp;

  CreateOrderResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.code,
    this.timestamp,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CreateOrderDataModel.fromJson(json['data']) : null,
      code: json['code'] ?? 0,
      timestamp: json['timestamp'],
    );
  }
}

class CreateOrderDataModel {
  final int orderId;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String createdAt;

  CreateOrderDataModel({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  factory CreateOrderDataModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderDataModel(
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? '',
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }
}
