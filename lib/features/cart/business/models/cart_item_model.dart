import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final String id;
  final String productName;
  final String category;
  final String productImage;
  final double price;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  CartItemModel copyWith({
    String? id,
    String? productName,
    String? category,
    String? productImage,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, productName, category, productImage, price, quantity];
}
