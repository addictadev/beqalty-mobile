import 'favorite_item_model.dart';
import 'package:equatable/equatable.dart';

/// Response model for favorite items API
class FavoriteItemsResponseModel {
  final bool success;
  final String message;
  final FavoriteItemsDataModel data;
  final int code;
  final String timestamp;

  FavoriteItemsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
    required this.timestamp,
  });

  /// Creates a FavoriteItemsResponseModel from JSON data
  factory FavoriteItemsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataValue = json['data'];
    
    // Handle both cases: data as array or data as object
    FavoriteItemsDataModel dataModel;
    if (dataValue is List) {
      // Data is a direct array of products
      dataModel = FavoriteItemsDataModel(
        products: dataValue
            .map((item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        warehouse: FavoriteWarehouseModel(
          available: false,
          message: '',
          warehouse: null,
        ),
      );
    } else if (dataValue is Map<String, dynamic>) {
      // Data is an object with products and warehouse
      dataModel = FavoriteItemsDataModel.fromJson(dataValue);
    } else {
      // Fallback: empty data
      dataModel = FavoriteItemsDataModel(
        products: [],
        warehouse: FavoriteWarehouseModel(
          available: false,
          message: '',
          warehouse: null,
        ),
      );
    }
    
    return FavoriteItemsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataModel,
      code: json['code'] as int? ?? 0,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts FavoriteItemsResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'code': code,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'FavoriteItemsResponseModel(success: $success, message: $message, data: ${data.products.length} items, code: $code, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItemsResponseModel &&
        other.success == success &&
        other.message == message &&
        other.data == data &&
        other.code == code &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      data.hashCode ^
      code.hashCode ^
      timestamp.hashCode;
}

/// Model for favorite items data section
class FavoriteItemsDataModel extends Equatable {
  final List<FavoriteItemModel> products;
  final FavoriteWarehouseModel warehouse;

  const FavoriteItemsDataModel({
    required this.products,
    required this.warehouse,
  });

  /// Creates a FavoriteItemsDataModel from JSON data
  factory FavoriteItemsDataModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemsDataModel(
      products: (json['products'] as List<dynamic>?)
          ?.map((item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      warehouse: json['warehouse'] != null
          ? FavoriteWarehouseModel.fromJson(json['warehouse'] as Map<String, dynamic>)
          : FavoriteWarehouseModel(
              available: false,
              message: '',
              warehouse: null,
            ),
    );
  }

  /// Converts FavoriteItemsDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((item) => item.toJson()).toList(),
      'warehouse': warehouse.toJson(),
    };
  }

  @override
  List<Object?> get props => [products, warehouse];
}

/// Model for warehouse info in favorite items
class FavoriteWarehouseModel extends Equatable {
  final bool available;
  final String message;
  final FavoriteWarehouseDetailsModel? warehouse;

  const FavoriteWarehouseModel({
    required this.available,
    required this.message,
    this.warehouse,
  });

  factory FavoriteWarehouseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteWarehouseModel(
      available: json['available'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      warehouse: json['warehouse'] != null
        ? FavoriteWarehouseDetailsModel.fromJson(json['warehouse'] as Map<String, dynamic>)
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

/// Model for warehouse details in favorite items
class FavoriteWarehouseDetailsModel extends Equatable {
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

  const FavoriteWarehouseDetailsModel({
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

  factory FavoriteWarehouseDetailsModel.fromJson(Map<String, dynamic> json) {
    return FavoriteWarehouseDetailsModel(
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
