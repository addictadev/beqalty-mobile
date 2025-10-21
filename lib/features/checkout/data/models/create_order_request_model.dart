class CreateOrderRequestModel {
  final int cartId;
  final int addressId;
  final int warehouseId;
  final int paymentTypeId;
  final double shippingCost;
  final String? discountCode;

  CreateOrderRequestModel({
    required this.cartId,
    required this.addressId,
    required this.warehouseId,
    required this.paymentTypeId,
    required this.shippingCost,
    this.discountCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'cart_id': cartId,
      'address_id': addressId,
      'warehouse_id': warehouseId,
      'payment_type_id': paymentTypeId,
      'shipping_cost': shippingCost,
    };

    if (discountCode != null && discountCode!.isNotEmpty) {
      data['discount_code'] = discountCode;
    }

    return data;
  }

  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = {
      'cart_id': cartId.toString(),
      'address_id': addressId.toString(),
      'warehouse_id': warehouseId.toString(),
      'payment_type_id': paymentTypeId.toString(),
      'shipping_cost': shippingCost.toString(),
    };

    if (discountCode != null && discountCode!.isNotEmpty) {
      data['discount_code'] = discountCode!;
    }

    return data;
  }
}
