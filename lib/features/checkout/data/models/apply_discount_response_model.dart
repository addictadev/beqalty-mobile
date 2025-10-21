import 'package:equatable/equatable.dart';

class ApplyDiscountResponseModel extends Equatable {
  final bool success;
  final String message;
  final int? discountId;
  final String? discountAmount;
  final double? newShippingCost;
  final List<String>? errors;

  const ApplyDiscountResponseModel({
    required this.success,
    required this.message,
    this.discountId,
    this.discountAmount,
    this.newShippingCost,
    this.errors,
  });

  factory ApplyDiscountResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplyDiscountResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      discountId: json['discount_id'] as int?,
      discountAmount: json['discount_amount'] as String?,
      newShippingCost: json['new_shipping_cost'] != null 
          ? (json['new_shipping_cost'] as num).toDouble() 
          : null,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (discountId != null) 'discount_id': discountId,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (newShippingCost != null) 'new_shipping_cost': newShippingCost,
      if (errors != null) 'errors': errors,
    };
  }

  @override
  List<Object?> get props => [
        success,
        message,
        discountId,
        discountAmount,
        newShippingCost,
        errors,
      ];
}
