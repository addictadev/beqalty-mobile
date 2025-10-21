import 'package:equatable/equatable.dart';

class ReplacementOrderResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final List<ReplacementOrderModel> data;

  const ReplacementOrderResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory ReplacementOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return ReplacementOrderResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => ReplacementOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [success, message, code, data];
}

class ReplacementOrderModel extends Equatable {
  final int id;
  final String code;
  final String deliveryFees;
  final String discountValue;
  final String statusAr;
  final String statusEn;
  final String totalPrice;
  final int itemsCount;
  final List<ReplacementOrderItemModel> items;

  const ReplacementOrderModel({
    required this.id,
    required this.code,
    required this.deliveryFees,
    required this.discountValue,
    required this.statusAr,
    required this.statusEn,
    required this.totalPrice,
    required this.itemsCount,
    required this.items,
  });

  factory ReplacementOrderModel.fromJson(Map<String, dynamic> json) {
    return ReplacementOrderModel(
      id: json['id'] as int,
      code: json['code'] as String,
      deliveryFees: json['delivery_fees'] as String,
      discountValue: json['discount_value'] as String,
      statusAr: json['status_ar'] as String,
      statusEn: json['status_en'] as String,
      totalPrice: json['total_price'] as String,
      itemsCount: json['items_count'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => ReplacementOrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'delivery_fees': deliveryFees,
      'discount_value': discountValue,
      'status_ar': statusAr,
      'status_en': statusEn,
      'total_price': totalPrice,
      'items_count': itemsCount,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        code,
        deliveryFees,
        discountValue,
        statusAr,
        statusEn,
        totalPrice,
        itemsCount,
        items,
      ];
}

class ReplacementOrderItemModel extends Equatable {
  final int orderProductId;
  final int productId;
  final String nameAr;
  final String nameEn;
  final String baseImage;
  final int quantity;
  final String status;
  final String total;
  final List<ReplacementItemModel> replacements;

  const ReplacementOrderItemModel({
    required this.orderProductId,
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.baseImage,
    required this.quantity,
    required this.status,
    required this.total,
    required this.replacements,
  });

  factory ReplacementOrderItemModel.fromJson(Map<String, dynamic> json) {
    return ReplacementOrderItemModel(
      orderProductId: json['order_product_id'] as int,
      productId: json['product_id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      baseImage: json['base_image'] as String,
      quantity: json['quantity'] as int,
      status: json['status'] as String,
      total: json['total'] as String,
      replacements: (json['replacements'] as List<dynamic>)
          .map((item) => ReplacementItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_product_id': orderProductId,
      'product_id': productId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'base_image': baseImage,
      'quantity': quantity,
      'status': status,
      'total': total,
      'replacements': replacements.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        orderProductId,
        productId,
        nameAr,
        nameEn,
        baseImage,
        quantity,
        status,
        total,
        replacements,
      ];
}

class ReplacementItemModel extends Equatable {
  final int replacementId;
  final int productId;
  final String nameAr;
  final String nameEn;
  final String baseImage;
  final int quantity;
  final String discount;
  final String price;
  final int totalPrice;
  final int isSelected;

  const ReplacementItemModel({
    required this.replacementId,
    required this.productId,
    required this.nameAr,
    required this.nameEn,
    required this.baseImage,
    required this.quantity,
    required this.discount,
    required this.price,
    required this.totalPrice,
    required this.isSelected,
  });

  factory ReplacementItemModel.fromJson(Map<String, dynamic> json) {
    return ReplacementItemModel(
      replacementId: json['replacement_id'] as int,
      productId: json['product_id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      baseImage: json['base_image'] as String,
      quantity: json['quantity'] as int,
      discount: json['discount'] as String,
      price: json['price'] as String,
      totalPrice: json['total_price'] as int,
      isSelected: json['is_selected'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replacement_id': replacementId,
      'product_id': productId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'base_image': baseImage,
      'quantity': quantity,
      'discount': discount,
      'price': price,
      'total_price': totalPrice,
      'is_selected': isSelected,
    };
  }

  @override
  List<Object?> get props => [
        replacementId,
        productId,
        nameAr,
        nameEn,
        baseImage,
        quantity,
        discount,
        price,
        totalPrice,
        isSelected,
      ];
}
