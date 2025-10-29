/// Model for home API response data
/// Contains the complete response structure from the home API endpoint
class HomeResponseModel {
  final bool success;
  final String message;
  final int code;
  final HomeDataModel data;
  final String timestamp;

  HomeResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a HomeResponseModel from JSON data
  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: HomeDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }

  /// Converts HomeResponseModel to JSON data
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
    return 'HomeResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeResponseModel &&
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

/// Model for the home data section
/// Contains all home screen data including advertisements, categories, products, etc.
class HomeDataModel {
  final List<AdvertisementModel> advertisements;
  final List<CategoryModel> categories;
  final dynamic points; // Can be null
  final List<DiscountedProductModel> discountedProducts;
  final WarehouseInfoModel warehouse;
  final int merchantReplacementOrdersCount;
  final WalletStatusModel walletStatus;
  final List<SavedCartModel> savedCarts;

  HomeDataModel({
    required this.advertisements,
    required this.categories,
    required this.points,
    required this.discountedProducts,
    required this.warehouse,
    required this.merchantReplacementOrdersCount,
    required this.walletStatus,
    required this.savedCarts,
  });

  /// Creates a HomeDataModel from JSON data
  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      advertisements: (json['advertisements'] as List<dynamic>)
          .map(
            (item) => AdvertisementModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      points: json['points'],
      discountedProducts: (json['discounted_products'] as List<dynamic>)
          .map(
            (item) =>
                DiscountedProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      warehouse: WarehouseInfoModel.fromJson(
        json['warehouse'] as Map<String, dynamic>,
      ),
      merchantReplacementOrdersCount:
          json['merchant_replacement_orders_count'] as int,
      walletStatus: WalletStatusModel.fromJson(
        json['wallet_status'] as Map<String, dynamic>,
      ),
      savedCarts: (json['saved_carts'] as List<dynamic>?)
          ?.map((item) => SavedCartModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Converts HomeDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'advertisements': advertisements.map((item) => item.toJson()).toList(),
      'categories': categories.map((item) => item.toJson()).toList(),
      'points': points,
      'discounted_products': discountedProducts
          .map((item) => item.toJson())
          .toList(),
      'warehouse': warehouse.toJson(),
      'merchant_replacement_orders_count': merchantReplacementOrdersCount,
      'wallet_status': walletStatus.toJson(),
      'saved_carts': savedCarts.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'HomeDataModel(advertisements: $advertisements, categories: $categories, points: $points, discountedProducts: $discountedProducts, warehouse: $warehouse, merchantReplacementOrdersCount: $merchantReplacementOrdersCount, walletStatus: $walletStatus, savedCarts: $savedCarts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeDataModel &&
        other.advertisements == advertisements &&
        other.categories == categories &&
        other.points == points &&
        other.discountedProducts == discountedProducts &&
        other.warehouse == warehouse &&
        other.merchantReplacementOrdersCount ==
            merchantReplacementOrdersCount &&
        other.walletStatus == walletStatus &&
        other.savedCarts == savedCarts;
  }

  @override
  int get hashCode =>
      advertisements.hashCode ^
      categories.hashCode ^
      points.hashCode ^
      discountedProducts.hashCode ^
      warehouse.hashCode ^
      merchantReplacementOrdersCount.hashCode ^
      walletStatus.hashCode ^
      savedCarts.hashCode;
}

/// Model for advertisement data
/// Contains advertisement information displayed on home screen
class AdvertisementModel {
  final int advId;
  final String baseImage;
  final String advType;
  final int advTargetId;
  final String? advExternalUrl;
  final String advStartDate;
  final String advEndDate;

  AdvertisementModel({
    required this.advId,
    required this.baseImage,
    required this.advType,
    required this.advTargetId,
    required this.advExternalUrl,
    required this.advStartDate,
    required this.advEndDate,
  });

  /// Creates an AdvertisementModel from JSON data
  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      advId: json['adv_id'] as int,
      baseImage: json['base_image'] as String,
      advType: json['adv_type'] as String,
      advTargetId: json['adv_target_id'] as int,
      advExternalUrl: json['adv_external_url'] as String?,
      advStartDate: json['adv_start_date'] as String,
      advEndDate: json['adv_end_date'] as String,
    );
  }

  /// Converts AdvertisementModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'adv_id': advId,
      'base_image': baseImage,
      'adv_type': advType,
      'adv_target_id': advTargetId,
      'adv_external_url': advExternalUrl,
      'adv_start_date': advStartDate,
      'adv_end_date': advEndDate,
    };
  }

  @override
  String toString() {
    return 'AdvertisementModel(advId: $advId, baseImage: $baseImage, advType: $advType, advTargetId: $advTargetId, advExternalUrl: $advExternalUrl, advStartDate: $advStartDate, advEndDate: $advEndDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdvertisementModel &&
        other.advId == advId &&
        other.baseImage == baseImage &&
        other.advType == advType &&
        other.advTargetId == advTargetId &&
        other.advExternalUrl == advExternalUrl &&
        other.advStartDate == advStartDate &&
        other.advEndDate == advEndDate;
  }

  @override
  int get hashCode =>
      advId.hashCode ^
      baseImage.hashCode ^
      advType.hashCode ^
      advTargetId.hashCode ^
      advExternalUrl.hashCode ^
      advStartDate.hashCode ^
      advEndDate.hashCode;
}

/// Model for category data
/// Contains category information displayed on home screen
class CategoryModel {
  final int catId;
  final String catName;
  final String? catImage;
  final String? catDescription;

  CategoryModel({
    required this.catId,
    required this.catName,
    this.catImage,
    required this.catDescription,
  });

  /// Creates a CategoryModel from JSON data
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      catId: json['cat_id'] as int,
      catName: json['cat_name'] as String,
      catImage: json['cat_image'] as String?,
      catDescription: json['cat_description'] as String?,
    );
  }

  /// Converts CategoryModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_image': catImage,
      'cat_description': catDescription,
    };
  }

  @override
  String toString() {
    return 'CategoryModel(catId: $catId, catName: $catName, catImage: $catImage, catDescription: $catDescription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.catId == catId &&
        other.catName == catName &&
        other.catImage == catImage &&
        other.catDescription == catDescription;
  }

  @override
  int get hashCode =>
      catId.hashCode ^
      catName.hashCode ^
      catImage.hashCode ^
      catDescription.hashCode;
}

/// Model for discounted product data
/// Contains product information with discount details
class DiscountedProductModel {
  final int id;
  final String name;
  final String baseImage;
  final String description;
  final String basePrice;
  final String dicount;
  final String finalPrice;
  final ProductWarehouseModel warehouse;

  DiscountedProductModel({
    required this.id,
    required this.name,
    required this.baseImage,
    required this.description,
    required this.basePrice,
    required this.dicount,
    required this.finalPrice,
    required this.warehouse,
  });

  /// Creates a DiscountedProductModel from JSON data
  factory DiscountedProductModel.fromJson(Map<String, dynamic> json) {
    return DiscountedProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      baseImage: json['base_image'] as String,
      description: json['description'] as String,
      basePrice: json['base_price'] as String,
      dicount: json['dicount'] as String,
      finalPrice: json['final_price'] as String,
      warehouse: ProductWarehouseModel.fromJson(
        json['warehouse'] as Map<String, dynamic>,
      ),
    );
  }

  /// Converts DiscountedProductModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_image': baseImage,
      'description': description,
      'base_price': basePrice,
      'dicount': dicount,
      'final_price': finalPrice,
      'warehouse': warehouse.toJson(),
    };
  }

  @override
  String toString() {
    return 'DiscountedProductModel(id: $id, name: $name, baseImage: $baseImage, description: $description, basePrice: $basePrice, dicount: $dicount, finalPrice: $finalPrice, warehouse: $warehouse)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiscountedProductModel &&
        other.id == id &&
        other.name == name &&
        other.baseImage == baseImage &&
        other.description == description &&
        other.basePrice == basePrice &&
        other.dicount == dicount &&
        other.finalPrice == finalPrice &&
        other.warehouse == warehouse;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      baseImage.hashCode ^
      description.hashCode ^
      basePrice.hashCode ^
      dicount.hashCode ^
      finalPrice.hashCode ^
      warehouse.hashCode;
}

/// Model for product warehouse information
/// Contains warehouse details for a specific product
class ProductWarehouseModel {
  final int id;
  final int quantity;

  ProductWarehouseModel({required this.id, required this.quantity});

  /// Creates a ProductWarehouseModel from JSON data
  factory ProductWarehouseModel.fromJson(Map<String, dynamic> json) {
    return ProductWarehouseModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
    );
  }

  /// Converts ProductWarehouseModel to JSON data
  Map<String, dynamic> toJson() {
    return {'id': id, 'quantity': quantity};
  }

  @override
  String toString() {
    return 'ProductWarehouseModel(id: $id, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductWarehouseModel &&
        other.id == id &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode;
}

/// Model for warehouse information
/// Contains warehouse availability and details
class WarehouseInfoModel {
  final bool available;
  final String message;
  final WarehouseModel? warehouse;

  WarehouseInfoModel({
    required this.available,
    required this.message,
    this.warehouse,
  });

  /// Creates a WarehouseInfoModel from JSON data
  factory WarehouseInfoModel.fromJson(Map<String, dynamic> json) {
    return WarehouseInfoModel(
      available: json['available'] as bool,
      message: json['message'] as String,
      warehouse: json['warehouse'] != null 
        ? WarehouseModel.fromJson(json['warehouse'] as Map<String, dynamic>)
        : null,
    );
  }

  /// Converts WarehouseInfoModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'message': message,
      'warehouse': warehouse?.toJson(),
    };
  }

  @override
  String toString() {
    return 'WarehouseInfoModel(available: $available, message: $message, warehouse: $warehouse)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WarehouseInfoModel &&
        other.available == available &&
        other.message == message &&
        other.warehouse == warehouse;
  }

  @override
  int get hashCode =>
      available.hashCode ^ message.hashCode ^ (warehouse?.hashCode ?? 0);
}

/// Model for warehouse details
/// Contains complete warehouse information
class WarehouseModel {
  final int warId;
  final String warNameEn;
  final String warNameAr;
  final String warPhone;
  final String warAddressEn;
  final String warAddressAr;
  final String warLat;
  final String warLng;
  final int warIsActive;
  final String createdAt;
  final String updatedAt;

  WarehouseModel({
    required this.warId,
    required this.warNameEn,
    required this.warNameAr,
    required this.warPhone,
    required this.warAddressEn,
    required this.warAddressAr,
    required this.warLat,
    required this.warLng,
    required this.warIsActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a WarehouseModel from JSON data
  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      warId: json['war_id'] as int,
      warNameEn: json['war_name_en'] as String,
      warNameAr: json['war_name_ar'] as String,
      warPhone: json['war_phone'] as String,
      warAddressEn: json['war_address_en'] as String,
      warAddressAr: json['war_address_ar'] as String,
      warLat: json['war_lat'] as String,
      warLng: json['war_lng'] as String,
      warIsActive: json['war_is_active'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Converts WarehouseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'war_id': warId,
      'war_name_en': warNameEn,
      'war_name_ar': warNameAr,
      'war_phone': warPhone,
      'war_address_en': warAddressEn,
      'war_address_ar': warAddressAr,
      'war_lat': warLat,
      'war_lng': warLng,
      'war_is_active': warIsActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'WarehouseModel(warId: $warId, warNameEn: $warNameEn, warNameAr: $warNameAr, warPhone: $warPhone, warAddressEn: $warAddressEn, warAddressAr: $warAddressAr, warLat: $warLat, warLng: $warLng, warIsActive: $warIsActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WarehouseModel &&
        other.warId == warId &&
        other.warNameEn == warNameEn &&
        other.warNameAr == warNameAr &&
        other.warPhone == warPhone &&
        other.warAddressEn == warAddressEn &&
        other.warAddressAr == warAddressAr &&
        other.warLat == warLat &&
        other.warLng == warLng &&
        other.warIsActive == warIsActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      warId.hashCode ^
      warNameEn.hashCode ^
      warNameAr.hashCode ^
      warPhone.hashCode ^
      warAddressEn.hashCode ^
      warAddressAr.hashCode ^
      warLat.hashCode ^
      warLng.hashCode ^
      warIsActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

/// Model for wallet status information
/// Contains wallet ordering capability and status message
class WalletStatusModel {
  final bool canOrder;
  final String? message;

  WalletStatusModel({required this.canOrder, required this.message});

  /// Creates a WalletStatusModel from JSON data
  factory WalletStatusModel.fromJson(Map<String, dynamic> json) {
    return WalletStatusModel(
      canOrder: json['can_order'] as bool,
      message: json['message'] as String?,
    );
  }

  /// Converts WalletStatusModel to JSON data
  Map<String, dynamic> toJson() {
    return {'can_order': canOrder, 'message': message};
  }

  @override
  String toString() {
    return 'WalletStatusModel(canOrder: $canOrder, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletStatusModel &&
        other.canOrder == canOrder &&
        other.message == message;
  }

  @override
  int get hashCode => canOrder.hashCode ^ message.hashCode;
}

/// Model for saved cart data
/// Contains saved cart information from home API
class SavedCartModel {
  final int id;
  final int userId;
  final String cartType;
  final String name;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> items;

  SavedCartModel({
    required this.id,
    required this.userId,
    required this.cartType,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  /// Creates a SavedCartModel from JSON data
  factory SavedCartModel.fromJson(Map<String, dynamic> json) {
    return SavedCartModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      cartType: json['cart_type'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      items: json['items'] as List<dynamic>,
    );
  }

  /// Converts SavedCartModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'cart_type': cartType,
      'name': name,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'items': items,
    };
  }

  @override
  String toString() {
    return 'SavedCartModel(id: $id, userId: $userId, cartType: $cartType, name: $name, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedCartModel &&
        other.id == id &&
        other.userId == userId &&
        other.cartType == cartType &&
        other.name == name &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.items == items;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      cartType.hashCode ^
      name.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      items.hashCode;
}
