/// Model for creating a new address via POST request
/// Matches the API form-data structure for adding addresses
class AddAddressRequestModel {
  final String title;
  final String street;
  final String city;
  final String floor;
  final String apartment;
  final String buildingNo;
  final String marker;
  final String extraDetails;
  final double lat;
  final double lng;
  final bool isDefault;

  AddAddressRequestModel({
    required this.title,
    required this.street,
    required this.city,
    required this.floor,
    required this.apartment,
    required this.buildingNo,
    required this.marker,
    required this.extraDetails,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  /// Converts AddAddressRequestModel to form-data Map for API requests
  /// Matches the exact API structure from the POST request
  Map<String, dynamic> toFormData() {
    return {
      'title': title,
      'street': street,
      'city': city,
      'floor': floor,
      'apartment': apartment,
      'building_no': buildingNo,
      'marker': marker,
      'extra_details': extraDetails,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'default': isDefault ? 1 : 0, // API uses 'default' not 'is_default'
    };
  }

  /// Converts AddAddressRequestModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'street': street,
      'city': city,
      'floor': floor,
      'apartment': apartment,
      'building_no': buildingNo,
      'marker': marker,
      'extra_details': extraDetails,
      'lat': lat,
      'lng': lng,
      'default': isDefault ? 1 : 0, // API uses 'default' not 'is_default'
    };
  }

  /// Creates a copy of this request with updated fields
  AddAddressRequestModel copyWith({
    String? title,
    String? street,
    String? city,
    String? floor,
    String? apartment,
    String? buildingNo,
    String? marker,
    String? extraDetails,
    double? lat,
    double? lng,
    bool? isDefault,
  }) {
    return AddAddressRequestModel(
      title: title ?? this.title,
      street: street ?? this.street,
      city: city ?? this.city,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      buildingNo: buildingNo ?? this.buildingNo,
      marker: marker ?? this.marker,
      extraDetails: extraDetails ?? this.extraDetails,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// Validates the address request data
  Map<String, String> validate() {
    final errors = <String, String>{};

    if (title.trim().isEmpty) {
      errors['title'] = 'Title is required';
    }

    if (street.trim().isEmpty) {
      errors['street'] = 'Street is required';
    }

    if (city.trim().isEmpty) {
      errors['city'] = 'City is required';
    }

    if (floor.trim().isEmpty) {
      errors['floor'] = 'Floor is required';
    }

    if (apartment.trim().isEmpty) {
      errors['apartment'] = 'Apartment is required';
    }

    if (buildingNo.trim().isEmpty) {
      errors['building_no'] = 'Building number is required';
    }

    if (marker.trim().isEmpty) {
      errors['marker'] = 'Marker is required';
    }

    if (lat == 0.0 && lng == 0.0) {
      errors['coordinates'] = 'Valid coordinates are required';
    }

    return errors;
  }

  /// Checks if the request data is valid
  bool get isValid => validate().isEmpty;

  /// Gets a formatted address string for display
  String get formattedAddress {
    final parts = <String>[];

    if (street.isNotEmpty) parts.add(street);
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

    if (street.isNotEmpty) parts.add(street);
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

  @override
  String toString() {
    return 'AddAddressRequestModel(title: $title, street: $street, city: $city, isDefault: $isDefault, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddAddressRequestModel &&
        other.title == title &&
        other.street == street &&
        other.city == city &&
        other.floor == floor &&
        other.apartment == apartment &&
        other.buildingNo == buildingNo &&
        other.marker == marker &&
        other.extraDetails == extraDetails &&
        other.lat == lat &&
        other.lng == lng &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      street.hashCode ^
      city.hashCode ^
      floor.hashCode ^
      apartment.hashCode ^
      buildingNo.hashCode ^
      marker.hashCode ^
      extraDetails.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      isDefault.hashCode;
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
