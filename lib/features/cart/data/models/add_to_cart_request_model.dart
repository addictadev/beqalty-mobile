class AddToCartRequestModel {
  final int productId;
  final int quantity;
  final int warehouseId;

  AddToCartRequestModel({
    required this.productId,
    required this.quantity,
    required this.warehouseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'warehouse_id': warehouseId,
    };
  }

  @override
  String toString() {
    return 'AddToCartRequestModel(productId: $productId, quantity: $quantity, warehouseId: $warehouseId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddToCartRequestModel &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.warehouseId == warehouseId;
  }

  @override
  int get hashCode => productId.hashCode ^ quantity.hashCode ^ warehouseId.hashCode;
}
