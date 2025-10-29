import 'package:equatable/equatable.dart';

/// Model for search API response data
/// Contains the complete response structure from the search-products API endpoint
class SearchResponseModel {
  final bool success;
  final String message;
  final int code;
  final SearchDataModel data;
  final String timestamp;

  SearchResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a SearchResponseModel from JSON data
  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data: SearchDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts SearchResponseModel to JSON data
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
    return 'SearchResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResponseModel &&
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

/// Model for the search data section
/// Contains products, warehouse info, and pagination metadata
class SearchDataModel extends Equatable {
  final List<SearchProductModel> products;
  final SearchWarehouseModel warehouse;
  final SearchMetaModel meta;

  const SearchDataModel({
    required this.products,
    required this.warehouse,
    required this.meta,
  });

  /// Creates a SearchDataModel from JSON data
  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    return SearchDataModel(
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => SearchProductModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      warehouse: SearchWarehouseModel.fromJson(json['warehouse'] as Map<String, dynamic>),
      meta: json['meta'] != null 
        ? SearchMetaModel.fromJson(json['meta'] as Map<String, dynamic>)
        : const SearchMetaModel(
            currentPage: 1,
            lastPage: 1,
            perPage: 15,
            total: 0,
          ),
    );
  }

  /// Converts SearchDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((item) => item.toJson()).toList(),
      'warehouse': warehouse.toJson(),
      'meta': meta.toJson(),
    };
  }

  @override
  List<Object?> get props => [products, warehouse, meta];
}

/// Model for individual search product data
/// Contains product information from the search API
class SearchProductModel extends Equatable {
  final int id;
  final String baseImage;
  final String name;
  final String? description;
  final String basePrice;
  final String discount;
  final String finalPrice;
  final int quantity;
  final bool isLiked;
  final SearchSubcategoryModel subcategory;
  final SearchParentCategoryModel parentCategory;

  const SearchProductModel({
    required this.id,
    required this.baseImage,
    required this.name,
    this.description,
    required this.basePrice,
    required this.discount,
    required this.finalPrice,
    required this.quantity,
    required this.isLiked,
    required this.subcategory,
    required this.parentCategory,
  });

  factory SearchProductModel.fromJson(Map<String, dynamic> json) {
    return SearchProductModel(
      id: json['id'] as int? ?? 0,
      baseImage: json['base_image'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      basePrice: json['base_price'] as String? ?? '0.00',
      discount: json['discount'] as String? ?? '0.00',
      finalPrice: json['final_price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      subcategory: SearchSubcategoryModel.fromJson(json['subcategory'] as Map<String, dynamic>),
      parentCategory: SearchParentCategoryModel.fromJson(json['parent_category'] as Map<String, dynamic>),
    );
  }

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
      'is_liked': isLiked,
      'subcategory': subcategory.toJson(),
      'parent_category': parentCategory.toJson(),
    };
  }

  // Helper getters for easier usage
  double get basePriceDouble => double.tryParse(basePrice) ?? 0.0;
  double get discountDouble => double.tryParse(discount) ?? 0.0;
  double get finalPriceDouble => double.tryParse(finalPrice) ?? 0.0;
  bool get hasDiscount => discountDouble > 0;
  double get discountPercentage => basePriceDouble > 0 ? (discountDouble / basePriceDouble) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        baseImage,
        name,
        description,
        basePrice,
        discount,
        finalPrice,
        quantity,
        isLiked,
        subcategory,
        parentCategory,
      ];
}

/// Model for subcategory information in search results
class SearchSubcategoryModel extends Equatable {
  final int id;
  final String name;
  final int level;

  const SearchSubcategoryModel({
    required this.id,
    required this.name,
    required this.level,
  });

  factory SearchSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchSubcategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      level: json['level'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }

  @override
  List<Object?> get props => [id, name, level];
}

/// Model for parent category information in search results
class SearchParentCategoryModel extends Equatable {
  final int id;
  final String name;

  const SearchParentCategoryModel({
    required this.id,
    required this.name,
  });

  factory SearchParentCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchParentCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

/// Model for warehouse information in search results
class SearchWarehouseModel extends Equatable {
  final bool available;
  final String message;
  final SearchWarehouseDetailsModel? warehouse;

  const SearchWarehouseModel({
    required this.available,
    required this.message,
    this.warehouse,
  });

  factory SearchWarehouseModel.fromJson(Map<String, dynamic> json) {
    return SearchWarehouseModel(
      available: json['available'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      warehouse: json['warehouse'] != null 
        ? SearchWarehouseDetailsModel.fromJson(json['warehouse'] as Map<String, dynamic>)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'message': message,
      'warehouse': warehouse?.toJson(),
    };
  }

  @override
  List<Object?> get props => [available, message, warehouse];
}

/// Model for warehouse details in search results
class SearchWarehouseDetailsModel extends Equatable {
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

  const SearchWarehouseDetailsModel({
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

  factory SearchWarehouseDetailsModel.fromJson(Map<String, dynamic> json) {
    return SearchWarehouseDetailsModel(
      warId: json['war_id'] as int? ?? 0,
      warNameEn: json['war_name_en'] as String? ?? '',
      warNameAr: json['war_name_ar'] as String? ?? '',
      warPhone: json['war_phone'] as String? ?? '',
      warAddressEn: json['war_address_en'] as String? ?? '',
      warAddressAr: json['war_address_ar'] as String? ?? '',
      warLat: json['war_lat'] as String? ?? '',
      warLng: json['war_lng'] as String? ?? '',
      warIsActive: json['war_is_active'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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

/// Model for pagination metadata in search results
class SearchMetaModel extends Equatable {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const SearchMetaModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory SearchMetaModel.fromJson(Map<String, dynamic> json) {
    return SearchMetaModel(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
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
