/// Model for product details API response data
/// Contains the complete response structure from the products/{id} API endpoint
class ProductDetailsResponseModel {
  final bool success;
  final String message;
  final int code;
  final ProductDetailsDataModel data;
  final String timestamp;

  ProductDetailsResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a ProductDetailsResponseModel from JSON data
  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data: ProductDetailsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts ProductDetailsResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'ProductDetailsResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductDetailsResponseModel &&
        other.success == success &&
        other.message == message &&
        other.code == code &&
        other.data == data &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      code.hashCode ^
      data.hashCode ^
      timestamp.hashCode;
}

/// Model for the product details data section
/// Contains all product information including attributes and related products
class ProductDetailsDataModel {
  final int id;
  final String name;
  final String description;
  final String baseImage;
  final List<String> images;
  final String basePrice;
  final String dicount;
  final String finalPrice;
  final int quantity;
  final bool isLiked;
  final List<ProductAttributeModel> attributes;
  final List<RelatedProductModel> relatedProducts;

  ProductDetailsDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.baseImage,
    required this.images,
    required this.basePrice,
    required this.dicount,
    required this.finalPrice,
    required this.quantity,
    required this.isLiked,
    required this.attributes,
    required this.relatedProducts,
  });

  /// Creates a ProductDetailsDataModel from JSON data
  factory ProductDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsDataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      baseImage: json['base_image'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList() ?? [],
      basePrice: json['base_price'] as String? ?? '0.00',
      dicount: json['dicount'] as String? ?? '0.00',
      finalPrice: json['final_price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((item) => ProductAttributeModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      relatedProducts: (json['related_products'] as List<dynamic>?)
          ?.map((item) => RelatedProductModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Converts ProductDetailsDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'base_image': baseImage,
      'images': images,
      'base_price': basePrice,
      'dicount': dicount,
      'final_price': finalPrice,
      'quantity': quantity,
      'is_liked': isLiked,
      'attributes': attributes.map((item) => item.toJson()).toList(),
      'related_products': relatedProducts.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ProductDetailsDataModel(id: $id, name: $name, description: $description, baseImage: $baseImage, images: $images, basePrice: $basePrice, dicount: $dicount, finalPrice: $finalPrice, quantity: $quantity, isLiked: $isLiked, attributes: $attributes, relatedProducts: $relatedProducts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductDetailsDataModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.baseImage == baseImage &&
        other.images == images &&
        other.basePrice == basePrice &&
        other.dicount == dicount &&
        other.finalPrice == finalPrice &&
        other.quantity == quantity &&
        other.isLiked == isLiked &&
        other.attributes == attributes &&
        other.relatedProducts == relatedProducts;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      baseImage.hashCode ^
      images.hashCode ^
      basePrice.hashCode ^
      dicount.hashCode ^
      finalPrice.hashCode ^
      quantity.hashCode ^
      isLiked.hashCode ^
      attributes.hashCode ^
      relatedProducts.hashCode;
}

/// Model for product attributes (like size, flavor, etc.)
/// Contains attribute information and its associated products
class ProductAttributeModel {
  final int attributeId;
  final String attributeName;
  final List<ProductVariantModel> products;

  ProductAttributeModel({
    required this.attributeId,
    required this.attributeName,
    required this.products,
  });

  /// Creates a ProductAttributeModel from JSON data
  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      attributeId: json['attribute_id'] as int? ?? 0,
      attributeName: json['attribute_name'] as String? ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => ProductVariantModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Converts ProductAttributeModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'attribute_name': attributeName,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ProductAttributeModel(attributeId: $attributeId, attributeName: $attributeName, products: $products)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductAttributeModel &&
        other.attributeId == attributeId &&
        other.attributeName == attributeName &&
        other.products == products;
  }

  @override
  int get hashCode =>
      attributeId.hashCode ^
      attributeName.hashCode ^
      products.hashCode;
}

/// Model for product variants within an attribute
/// Contains variant-specific product information
class ProductVariantModel {
  final int productId;
  final String name;
  final String? description;
  final int groupId;
  final String groupName;
  final String basePrice;
  final String dicount;
  final String finalPrice;
  final int quantity;
  final bool selected;

  ProductVariantModel({
    required this.productId,
    required this.name,
    this.description,
    required this.groupId,
    required this.groupName,
    required this.basePrice,
    required this.dicount,
    required this.finalPrice,
    required this.quantity,
    required this.selected,
  });

  /// Creates a ProductVariantModel from JSON data
  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      productId: json['product_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      groupId: json['group_id'] as int? ?? 0,
      groupName: json['group_name'] as String? ?? '',
      basePrice: json['base_price'] as String? ?? '0.00',
      dicount: json['dicount'] as String? ?? '0.00',
      finalPrice: json['final_price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      selected: json['selected'] as bool? ?? false,
    );
  }

  /// Converts ProductVariantModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'group_id': groupId,
      'group_name': groupName,
      'base_price': basePrice,
      'dicount': dicount,
      'final_price': finalPrice,
      'quantity': quantity,
      'selected': selected,
    };
  }

  @override
  String toString() {
    return 'ProductVariantModel(productId: $productId, name: $name, description: $description, groupId: $groupId, groupName: $groupName, basePrice: $basePrice, dicount: $dicount, finalPrice: $finalPrice, quantity: $quantity, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductVariantModel &&
        other.productId == productId &&
        other.name == name &&
        other.description == description &&
        other.groupId == groupId &&
        other.groupName == groupName &&
        other.basePrice == basePrice &&
        other.dicount == dicount &&
        other.finalPrice == finalPrice &&
        other.quantity == quantity &&
        other.selected == selected;
  }

  @override
  int get hashCode =>
      productId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      groupId.hashCode ^
      groupName.hashCode ^
      basePrice.hashCode ^
      dicount.hashCode ^
      finalPrice.hashCode ^
      quantity.hashCode ^
      selected.hashCode;
}

/// Model for related products
/// Contains basic information about related products
class RelatedProductModel {
  final int id;
  final String name;
  final String basePrice;
  final String dicount;
  final String finalPrice;
  final String baseImage;

  RelatedProductModel({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.dicount,
    required this.finalPrice,
    required this.baseImage,
  });

  /// Creates a RelatedProductModel from JSON data
  factory RelatedProductModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      basePrice: json['base_price'] as String? ?? '0.00',
      dicount: json['dicount'] as String? ?? '0.00',
      finalPrice: json['final_price'] as String? ?? '0.00',
      baseImage: json['base_image'] as String? ?? '',
    );
  }

  /// Converts RelatedProductModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'dicount': dicount,
      'final_price': finalPrice,
      'base_image': baseImage,
    };
  }

  @override
  String toString() {
    return 'RelatedProductModel(id: $id, name: $name, basePrice: $basePrice, dicount: $dicount, finalPrice: $finalPrice, baseImage: $baseImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RelatedProductModel &&
        other.id == id &&
        other.name == name &&
        other.basePrice == basePrice &&
        other.dicount == dicount &&
        other.finalPrice == finalPrice &&
        other.baseImage == baseImage;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      basePrice.hashCode ^
      dicount.hashCode ^
      finalPrice.hashCode ^
      baseImage.hashCode;
}
