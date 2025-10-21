class ApplyDiscountRequestModel {
  final String code;
  final double subtotal;
  final double shippingCost;

  ApplyDiscountRequestModel({
    required this.code,
    required this.subtotal,
    required this.shippingCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
    };
  }

  Map<String, dynamic> toFormData() {
    return {
      'code': code,
      'subtotal': subtotal.toString(),
      'shipping_cost': shippingCost.toString(),
    };
  }
}
