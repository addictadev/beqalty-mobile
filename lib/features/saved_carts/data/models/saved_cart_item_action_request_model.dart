import 'package:equatable/equatable.dart';

class SavedCartItemActionRequestModel extends Equatable {
  final int productId;
  final int? quantity;
  final int? warehouseId;

  const SavedCartItemActionRequestModel({
    required this.productId,
    this.quantity,
    this.warehouseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (warehouseId != null) 'warehouse_id': warehouseId,
    };
  }

  Map<String, dynamic> toFormData() {
    return {
      'product_id': productId.toString(),
      if (quantity != null) 'quantity': quantity.toString(),
      if (warehouseId != null) 'warehouse_id': warehouseId.toString(),
    };
  }

  @override
  List<Object?> get props => [productId, quantity, warehouseId];
}
