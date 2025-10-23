/// Model for individual favorite item
class FavoriteItemModel {
  final int id;
  final String baseImage;
  final String name;
  final String description;
  final String basePrice;
  final String discount;
  final String finalPrice;
  final int quantity;
  final String subcategoryName;

  FavoriteItemModel({
    required this.id,
    required this.baseImage,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.discount,
    required this.finalPrice,
    required this.quantity,
    required this.subcategoryName,
  });

  /// Creates a FavoriteItemModel from JSON data
  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] as int? ?? 0,
      baseImage: json['base_image'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      basePrice: json['base_price'] as String? ?? '0.00',
      discount: json['discount'] as String? ?? '0.00',
      finalPrice: json['final_price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      subcategoryName: json['subcategory_name'] as String? ?? '',
    );
  }

  /// Converts FavoriteItemModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'base_image': baseImage,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'discount': discount,
      'final_price': finalPrice,
      'quantity': quantity,
      'subcategory_name': subcategoryName,
    };
  }

  @override
  String toString() {
    return 'FavoriteItemModel(id: $id, name: $name, basePrice: $basePrice, finalPrice: $finalPrice, quantity: $quantity, subcategoryName: $subcategoryName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItemModel &&
        other.id == id &&
        other.baseImage == baseImage &&
        other.name == name &&
        other.description == description &&
        other.basePrice == basePrice &&
        other.discount == discount &&
        other.finalPrice == finalPrice &&
        other.quantity == quantity &&
        other.subcategoryName == subcategoryName;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      baseImage.hashCode ^
      name.hashCode ^
      description.hashCode ^
      basePrice.hashCode ^
      discount.hashCode ^
      finalPrice.hashCode ^
      quantity.hashCode ^
      subcategoryName.hashCode;
}
