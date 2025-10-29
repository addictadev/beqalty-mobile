class AddToCartRequestModel {
  final int productId;
  final int quantity;
  final int warehouseId;
  final int? sharedCartId;

  AddToCartRequestModel({
    required this.productId,
    required this.quantity,
    required this.warehouseId,
    this.sharedCartId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'product_id': productId,
      'quantity': quantity,
      'warehouse_id': warehouseId,
    };
    
    if (sharedCartId != null) {
      data['shared_cart_id'] = sharedCartId;
    }
    
    return data;
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
