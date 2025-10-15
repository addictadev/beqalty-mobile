part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final AddressesResponseModel addresses;

  const ProfileLoaded({required this.addresses});
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});
}

final class AddAddressLoading extends ProfileState {}

final class AddAddressSuccess extends ProfileState {
  final String message;

  const AddAddressSuccess({required this.message});
}

final class AddAddressError extends ProfileState {
  final String message;

  const AddAddressError({required this.message});
  @override
  List<Object> get props => [message];
}

// Form Management States
final class AddressFormInitial extends ProfileState {}

final class AddressFormLoaded extends ProfileState {
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
  final String selectedAddress;
  final bool isDefault;
  final bool isFormValid;

  const AddressFormLoaded({
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
    required this.selectedAddress,
    required this.isDefault,
    required this.isFormValid,
  });

  @override
  List<Object> get props => [
    title,
    street,
    city,
    floor,
    apartment,
    buildingNo,
    marker,
    extraDetails,
    lat,
    lng,
    selectedAddress,
    isDefault,
    isFormValid,
  ];
}

// Location Picker States
final class LocationPickerInitial extends ProfileState {}

final class LocationPickerLoading extends ProfileState {}

final class LocationPickerLoaded extends ProfileState {
  final double lat;
  final double lng;
  final String address;
  final bool hasLocation;
  final bool isGettingAddress;

  const LocationPickerLoaded({
    required this.lat,
    required this.lng,
    required this.address,
    required this.hasLocation,
    required this.isGettingAddress,
  });

  @override
  List<Object> get props => [lat, lng, address, hasLocation, isGettingAddress];
}

final class LocationPickerError extends ProfileState {
  final String message;

  const LocationPickerError({required this.message});
  @override
  List<Object> get props => [message];
}

final class GetAddressesLoading extends ProfileState {}

final class GetAddressesLoaded extends ProfileState {
  final List<AddressModel> addresses;

  const GetAddressesLoaded({required this.addresses});
}

final class GetAddressesError extends ProfileState {
  final String message;

  const GetAddressesError({required this.message});
  @override
  List<Object> get props => [message];
}

// Reverse Geocoding States
final class ReverseGeocodingLoading extends ProfileState {
  final double lat;
  final double lng;

  const ReverseGeocodingLoading({required this.lat, required this.lng});

  @override
  List<Object> get props => [lat, lng];
}

final class ReverseGeocodingLoaded extends ProfileState {
  final double lat;
  final double lng;
  final String address;

  const ReverseGeocodingLoaded({
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  List<Object> get props => [lat, lng, address];
}

final class ReverseGeocodingError extends ProfileState {
  final double lat;
  final double lng;
  final String message;

  const ReverseGeocodingError({
    required this.lat,
    required this.lng,
    required this.message,
  });

  @override
  List<Object> get props => [lat, lng, message];
}
