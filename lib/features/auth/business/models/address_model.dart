class AddressModel {
  final double lat;
  final double lng;
  final String city;
  final String apartment;
  final String buildingNo;
  final String marker;
  final String extraDetails;
  final String title;
  final String floor;
  final String street;

  const AddressModel({
    required this.lat,
    required this.lng,
    required this.city,
    required this.apartment,
    required this.buildingNo,
    required this.marker,
    required this.extraDetails,
    required this.title,
    required this.floor,
    required this.street,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'city': city,
      'apartment': apartment,
      'building_no': buildingNo,
      'marker': marker,
      'extra_details': extraDetails,
      'title': title,
      'floor': floor,
      'street': street,
    };
  }

  AddressModel copyWith({
    double? lat,
    double? lng,
    String? city,
    String? apartment,
    String? buildingNo,
    String? marker,
    String? extraDetails,
    String? title,
    String? floor,
    String? street,
  }) {
    return AddressModel(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      apartment: apartment ?? this.apartment,
      buildingNo: buildingNo ?? this.buildingNo,
      marker: marker ?? this.marker,
      extraDetails: extraDetails ?? this.extraDetails,
      title: title ?? this.title,
      floor: floor ?? this.floor,
      street: street ?? this.street,
    );
  }

  factory AddressModel.empty() {
    return const AddressModel(
      lat: 0.0,
      lng: 0.0,
      city: '',
      apartment: '',
      buildingNo: '',
      marker: '',
      extraDetails: '',
      title: '',
      floor: '',
      street: '',
    );
  }
}
