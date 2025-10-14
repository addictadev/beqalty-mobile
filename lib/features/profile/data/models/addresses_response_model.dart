/// Model for addresses API response data
/// Contains the complete response structure from the addresses API endpoint
class AddressesResponseModel {
  final bool success;
  final String message;
  final int code;
  final List<AddressModel> data;
  final String timestamp;

  AddressesResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates an AddressesResponseModel from JSON data
  factory AddressesResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => AddressModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts AddressesResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'AddressesResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressesResponseModel &&
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

/// Model for individual address data
/// Contains address information from the addresses API
class AddressModel {
  final int id;
  final int userId;
  final String title;
  final String addressLine1;
  final String city;
  final String floor;
  final String apartment;
  final String buildingNo;
  final String marker;
  final String extraDetails;
  final bool isDefault;
  final double lat;
  final double lng;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.addressLine1,
    required this.city,
    required this.floor,
    required this.apartment,
    required this.buildingNo,
    required this.marker,
    required this.extraDetails,
    required this.isDefault,
    required this.lat,
    required this.lng,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates an AddressModel from JSON data
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      addressLine1: json['address_line_1'] as String? ?? '',
      city: json['city'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      apartment: json['apartment'] as String? ?? '',
      buildingNo: json['building_no'] as String? ?? '',
      marker: json['marker'] as String? ?? '',
      extraDetails: json['extra_details'] as String? ?? '',
      isDefault: (json['is_default'] as int? ?? 0) == 1,
      lat: double.tryParse(json['lat'] as String? ?? '0.0') ?? 0.0,
      lng: double.tryParse(json['lng'] as String? ?? '0.0') ?? 0.0,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  /// Converts AddressModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'address_line_1': addressLine1,
      'city': city,
      'floor': floor,
      'apartment': apartment,
      'building_no': buildingNo,
      'marker': marker,
      'extra_details': extraDetails,
      'is_default': isDefault ? 1 : 0,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Gets the full formatted address
  String get fullAddress {
    final parts = <String>[];

    if (addressLine1.isNotEmpty) parts.add(addressLine1);
    if (buildingNo.isNotEmpty) parts.add('Building $buildingNo');
    if (floor.isNotEmpty) parts.add('Floor $floor');
    if (apartment.isNotEmpty) parts.add('Apartment $apartment');
    if (city.isNotEmpty) parts.add(city);
    if (marker.isNotEmpty) parts.add('($marker)');

    return parts.join(', ');
  }

  /// Gets a short address for display
  String get shortAddress {
    final parts = <String>[];

    if (addressLine1.isNotEmpty) parts.add(addressLine1);
    if (city.isNotEmpty) parts.add(city);

    return parts.join(', ');
  }

  /// Checks if the address has valid coordinates
  bool get hasValidCoordinates => lat != 0.0 && lng != 0.0;

  /// Gets the address type based on title
  AddressType get addressType {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('home') || titleLower.contains('منزل')) {
      return AddressType.home;
    } else if (titleLower.contains('work') ||
        titleLower.contains('عمل') ||
        titleLower.contains('مكتب')) {
      return AddressType.work;
    } else {
      return AddressType.other;
    }
  }

  /// Creates a copy of this address with updated fields
  AddressModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? addressLine1,
    String? city,
    String? floor,
    String? apartment,
    String? buildingNo,
    String? marker,
    String? extraDetails,
    bool? isDefault,
    double? lat,
    double? lng,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      buildingNo: buildingNo ?? this.buildingNo,
      marker: marker ?? this.marker,
      extraDetails: extraDetails ?? this.extraDetails,
      isDefault: isDefault ?? this.isDefault,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, userId: $userId, title: $title, addressLine1: $addressLine1, city: $city, isDefault: $isDefault, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.addressLine1 == addressLine1 &&
        other.city == city &&
        other.floor == floor &&
        other.apartment == apartment &&
        other.buildingNo == buildingNo &&
        other.marker == marker &&
        other.extraDetails == extraDetails &&
        other.isDefault == isDefault &&
        other.lat == lat &&
        other.lng == lng &&
        other.deletedAt == deletedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      addressLine1.hashCode ^
      city.hashCode ^
      floor.hashCode ^
      apartment.hashCode ^
      buildingNo.hashCode ^
      marker.hashCode ^
      extraDetails.hashCode ^
      isDefault.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

/// Enum for address types
enum AddressType { home, work, other }

/// Extension for AddressType to get display names and icons
extension AddressTypeExtension on AddressType {
  String get displayName {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  String get displayNameAr {
    switch (this) {
      case AddressType.home:
        return 'المنزل';
      case AddressType.work:
        return 'العمل';
      case AddressType.other:
        return 'أخرى';
    }
  }
}
