import 'package:equatable/equatable.dart';

class SubcategoryProductsResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final SubcategoryProductsData data;
  final String timestamp;

  const SubcategoryProductsResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  factory SubcategoryProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryProductsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: SubcategoryProductsData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }

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
  List<Object?> get props => [success, message, code, data, timestamp];
}

class SubcategoryProductsData extends Equatable {
  final int subcategoryId;
  final String subcategoryName;
  final List<ProductModel> products;
  final WarehouseInfo warehouse;
  final MetaInfo meta;

  const SubcategoryProductsData({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.products,
    required this.warehouse,
    required this.meta,
  });

  factory SubcategoryProductsData.fromJson(Map<String, dynamic> json) {
    return SubcategoryProductsData(
      subcategoryId: json['subcategory_id'] ?? 0,
      subcategoryName: json['subcategory_name'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .toList() ??
          [],
      warehouse: WarehouseInfo.fromJson(json['warehouse'] ?? {}),
      meta: MetaInfo.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subcategory_id': subcategoryId,
      'subcategory_name': subcategoryName,
      'products': products.map((product) => product.toJson()).toList(),
      'warehouse': warehouse.toJson(),
      'meta': meta.toJson(),
    };
  }

  @override
  List<Object?> get props => [subcategoryId, subcategoryName, products, warehouse, meta];
}

class ProductModel extends Equatable {
  final int id;
  final String baseImage;
  final String name;
  final String? description;
  final String basePrice;
  final String discount;
  final String finalPrice;
  final int quantity;

  const ProductModel({
    required this.id,
    required this.baseImage,
    required this.name,
    this.description,
    required this.basePrice,
    required this.discount,
    required this.finalPrice,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      baseImage: json['base_image'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      basePrice: json['base_price'] ?? '0.00',
      discount: json['dicount'] ?? '0.00', // Note: API has typo "dicount"
      finalPrice: json['final_price'] ?? '0.00',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'base_image': baseImage,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'dicount': discount,
      'final_price': finalPrice,
      'quantity': quantity,
    };
  }

  // Helper getters for easier usage
  double get basePriceDouble => double.tryParse(basePrice) ?? 0.0;
  double get discountDouble => double.tryParse(discount) ?? 0.0;
  double get finalPriceDouble => double.tryParse(finalPrice) ?? 0.0;
  bool get hasDiscount => discountDouble > 0;
  double get discountPercentage => basePriceDouble > 0 ? (discountDouble / basePriceDouble) * 100 : 0;

  @override
  List<Object?> get props => [id, baseImage, name, description, basePrice, discount, finalPrice, quantity];
}

class WarehouseInfo extends Equatable {
  final bool available;
  final String message;
  final Warehouse warehouse;

  const WarehouseInfo({
    required this.available,
    required this.message,
    required this.warehouse,
  });

  factory WarehouseInfo.fromJson(Map<String, dynamic> json) {
    return WarehouseInfo(
      available: json['available'] ?? false,
      message: json['message'] ?? '',
      warehouse: Warehouse.fromJson(json['warehouse'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'message': message,
      'warehouse': warehouse.toJson(),
    };
  }

  @override
  List<Object?> get props => [available, message, warehouse];
}

class Warehouse extends Equatable {
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

  const Warehouse({
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

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      warId: json['war_id'] ?? 0,
      warNameEn: json['war_name_en'] ?? '',
      warNameAr: json['war_name_ar'] ?? '',
      warPhone: json['war_phone'] ?? '',
      warAddressEn: json['war_address_en'] ?? '',
      warAddressAr: json['war_address_ar'] ?? '',
      warLat: json['war_lat'] ?? '0.0',
      warLng: json['war_lng'] ?? '0.0',
      warIsActive: json['war_is_active'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

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

  // Helper getters
  double get latitude => double.tryParse(warLat) ?? 0.0;
  double get longitude => double.tryParse(warLng) ?? 0.0;
  bool get isActive => warIsActive == 1;

  @override
  List<Object?> get props => [
        warId,
        warNameEn,
        warNameAr,
        warPhone,
        warAddressEn,
        warAddressAr,
        warLat,
        warLng,
        warIsActive,
        createdAt,
        updatedAt,
      ];
}

class MetaInfo extends Equatable {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const MetaInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory MetaInfo.fromJson(Map<String, dynamic> json) {
    return MetaInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }

  // Helper getters
  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [currentPage, perPage, total, lastPage];
}
