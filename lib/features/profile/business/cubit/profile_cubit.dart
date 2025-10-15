import 'dart:developer';

import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:baqalty/features/profile/data/models/add_address_request_model.dart';
import 'package:baqalty/features/profile/data/models/update_address_request_model.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
import 'package:baqalty/features/profile/data/services/profile_services.dart';
import 'package:baqalty/features/profile/data/services/profile_services_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final ProfileServices _profileServices = ProfileServicesImpl();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _markerController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();

  double _lat = 0.0;
  double _lng = 0.0;
  String _selectedAddress = '';
  bool _isDefault = false;

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddressFromPicker;
  final bool _isLoading = false;
  bool _isGettingAddress = false;
  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);
  LatLng _currentLocation = _defaultLocation;

  TextEditingController get titleController => _titleController;
  TextEditingController get streetController => _streetController;
  TextEditingController get cityController => _cityController;
  TextEditingController get floorController => _floorController;
  TextEditingController get apartmentController => _apartmentController;
  TextEditingController get buildingNoController => _buildingNoController;
  TextEditingController get markerController => _markerController;
  TextEditingController get extraDetailsController => _extraDetailsController;

  double get lat => _lat;
  double get lng => _lng;
  String get selectedAddress => _selectedAddress;
  bool get isDefault => _isDefault;
  bool get hasLocation => _lat != 0.0 && _lng != 0.0;

  GoogleMapController? get mapController => _mapController;
  LatLng? get selectedLocation => _selectedLocation;
  String? get selectedAddressFromPicker => _selectedAddressFromPicker;
  bool get isLoading => _isLoading;
  bool get isGettingAddress => _isGettingAddress;
  LatLng get currentLocation => _currentLocation;

  @override
  Future<void> close() {
    _titleController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _buildingNoController.dispose();
    _markerController.dispose();
    _extraDetailsController.dispose();
    return super.close();
  }

  Future<void> getAddresses() async {
    try {
      emit(GetAddressesLoading());

      final response = await _profileServices.getAddresses();

      if (response.status && response.data != null) {
        emit(GetAddressesLoaded(addresses: response.data!.data));
      } else {
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          GetAddressesError(
            message: response.message ?? 'Failed to load addresses',
          ),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(GetAddressesError(message: e.toString()));
    }
  }

  Future<void> addAddress(AddAddressRequestModel request) async {
    try {
      emit(AddAddressLoading());
      final response = await _profileServices.addAddress(request);
      if (response.status) {
        ToastHelper.showSuccessToast(response.message!);
        NavigationManager.pop();

        await getAddresses();
      } else {
        ToastHelper.showErrorToast(response.message!);
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          AddAddressError(message: response.message ?? 'Failed to add address'),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(AddAddressError(message: e.toString()));
    }
  }

  Future<void> updateAddress(
    int addressId,
    UpdateAddressRequestModel request,
  ) async {
    try {
      emit(AddAddressLoading());
      final response = await _profileServices.updateAddress(addressId, request);
      if (response.status) {
        ToastHelper.showSuccessToast(response.message!);
        NavigationManager.pop();

        await getAddresses();
      } else {
        ToastHelper.showErrorToast(response.message!);
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          AddAddressError(
            message: response.message ?? 'Failed to update address',
          ),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(AddAddressError(message: e.toString()));
    }
  }

  Future<void> setAddressAsDefault(AddressModel address) async {
    try {
      emit(AddAddressLoading());

      final request = UpdateAddressRequestModel(
        title: address.title,
        street: address.addressLine1,
        city: address.city,
        floor: address.floor,
        apartment: address.apartment,
        buildingNo: address.buildingNo,
        marker: address.marker,
        extraDetails: address.extraDetails,
        lat: address.lat,
        lng: address.lng,
        isDefault: true,
      );

      final response = await _profileServices.updateAddress(
        address.id,
        request,
      );
      if (response.status) {
        ToastHelper.showSuccessToast("set_as_default_success".tr());
        await getAddresses();
      } else {
        ToastHelper.showErrorToast(response.message!);
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          AddAddressError(
            message: response.message ?? 'Failed to set address as default',
          ),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(AddAddressError(message: e.toString()));
    }
  }

  Future<void> deleteAddress(int addressId) async {
    try {
      emit(AddAddressLoading());

      final response = await _profileServices.deleteAddress(addressId);
      if (response.status) {
        ToastHelper.showSuccessToast("address_deleted_success".tr());
        await getAddresses();
      } else {
        ToastHelper.showErrorToast(response.message!);
        log('❌ ProfileCubit: API returned error: ${response.message}');
        emit(
          AddAddressError(
            message: response.message ?? 'Failed to delete address',
          ),
        );
      }
    } catch (e, stackTrace) {
      log('❌ ProfileCubit: Exception occurred: $e');
      log('❌ ProfileCubit: Stack trace: $stackTrace');
      emit(AddAddressError(message: e.toString()));
    }
  }

  void initializeAddressForm({
    double? initialLat,
    double? initialLng,
    String? initialAddress,
  }) {
    if (initialLat != null && initialLng != null) {
      _lat = initialLat;
      _lng = initialLng;
      _selectedAddress = initialAddress ?? '';
    }
    _emitFormState();
  }

  void initializeEditAddressForm(AddressModel address) {
    _titleController.text = address.title;
    _streetController.text = address.addressLine1;
    _cityController.text = address.city;
    _floorController.text = address.floor;
    _apartmentController.text = address.apartment;
    _buildingNoController.text = address.buildingNo;
    _markerController.text = address.marker;
    _extraDetailsController.text = address.extraDetails;
    _lat = address.lat;
    _lng = address.lng;
    _isDefault = address.isDefault;

    _getAddressFromCoordinatesForEdit(LatLng(address.lat, address.lng));
  }

  void updateFormField(String field, String value) {
    switch (field) {
      case 'title':
        _titleController.text = value;
        break;
      case 'street':
        _streetController.text = value;
        break;
      case 'city':
        _cityController.text = value;
        break;
      case 'floor':
        _floorController.text = value;
        break;
      case 'apartment':
        _apartmentController.text = value;
        break;
      case 'buildingNo':
        _buildingNoController.text = value;
        break;
      case 'marker':
        _markerController.text = value;
        break;
      case 'extraDetails':
        _extraDetailsController.text = value;
        break;
    }
    _emitFormState();
  }

  void updateLocation(double lat, double lng, String address) {
    _lat = lat;
    _lng = lng;
    _selectedAddress = address;
    _emitFormState();
  }

  void toggleDefaultAddress() {
    _isDefault = !_isDefault;
    _emitFormState();
  }

  void _emitFormState() {
    final isFormValid =
        _titleController.text.trim().isNotEmpty &&
        _streetController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _floorController.text.trim().isNotEmpty &&
        _apartmentController.text.trim().isNotEmpty &&
        _buildingNoController.text.trim().isNotEmpty &&
        _markerController.text.trim().isNotEmpty &&
        hasLocation;

    emit(
      AddressFormLoaded(
        title: _titleController.text,
        street: _streetController.text,
        city: _cityController.text,
        floor: _floorController.text,
        apartment: _apartmentController.text,
        buildingNo: _buildingNoController.text,
        marker: _markerController.text,
        extraDetails: _extraDetailsController.text,
        lat: _lat,
        lng: _lng,
        selectedAddress: _selectedAddress,
        isDefault: _isDefault,
        isFormValid: isFormValid,
      ),
    );
  }

  void submitAddress({int? addressId}) {
    if (!_isFormValid()) return;

    if (addressId != null) {
      final request = UpdateAddressRequestModel(
        title: _titleController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        floor: _floorController.text.trim(),
        apartment: _apartmentController.text.trim(),
        buildingNo: _buildingNoController.text.trim(),
        marker: _markerController.text.trim(),
        extraDetails: _extraDetailsController.text.trim(),
        lat: _lat,
        lng: _lng,
        isDefault: _isDefault,
      );
      updateAddress(addressId, request);
    } else {
      final request = AddAddressRequestModel(
        title: _titleController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        floor: _floorController.text.trim(),
        apartment: _apartmentController.text.trim(),
        buildingNo: _buildingNoController.text.trim(),
        marker: _markerController.text.trim(),
        extraDetails: _extraDetailsController.text.trim(),
        lat: _lat,
        lng: _lng,
        isDefault: _isDefault,
      );
      addAddress(request);
    }
  }

  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
        _streetController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _floorController.text.trim().isNotEmpty &&
        _apartmentController.text.trim().isNotEmpty &&
        _buildingNoController.text.trim().isNotEmpty &&
        _markerController.text.trim().isNotEmpty &&
        hasLocation;
  }

  void initializeLocationPicker({
    double? initialLat,
    double? initialLng,
    String? initialAddress,
  }) {
    if (initialLat != null && initialLng != null) {
      _currentLocation = LatLng(initialLat, initialLng);
      _selectedLocation = _currentLocation;
      _selectedAddressFromPicker = initialAddress;

      _emitLocationPickerState();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    emit(LocationPickerLoading());

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationPickerError(message: 'location_services_disabled'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPickerError(message: 'location_permission_denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          LocationPickerError(
            message: 'location_permission_permanently_denied',
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      _selectedLocation ??= _currentLocation;

      await _getAddressFromCoordinates(_currentLocation);
    } catch (e) {
      log('Error getting current location: $e');
      emit(LocationPickerError(message: 'error_getting_location'));
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    _isGettingAddress = true;
    _emitLocationPickerState();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = _formatAddress(placemark);
        _selectedAddressFromPicker = address;
      }
    } catch (e) {
      log('Error getting address: $e');
      _selectedAddressFromPicker =
          '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
    } finally {
      _isGettingAddress = false;
      _emitLocationPickerState();
    }
  }

  Future<void> _getAddressFromCoordinatesForEdit(LatLng location) async {
    _selectedAddress = 'loading_address'.tr();
    _emitFormState();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = _formatAddress(placemark);
        _selectedAddress = address;
      } else {
        _selectedAddress =
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
      }
    } catch (e) {
      log('Error getting address for edit: $e');
      _selectedAddress =
          '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
    } finally {
      _emitFormState();
    }
  }

  String _formatAddress(Placemark placemark) {
    List<String> addressComponents = [];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressComponents.add(placemark.street!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressComponents.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      addressComponents.add(placemark.administrativeArea!);
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      addressComponents.add(placemark.country!);
    }

    return addressComponents.join(', ');
  }

  void onMapTap(LatLng location) {
    _selectedLocation = location;
    _getAddressFromCoordinates(location);
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void moveToCurrentLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    }
  }

  void confirmLocation() {
    if (_selectedLocation != null) {
      _lat = _selectedLocation!.latitude;
      _lng = _selectedLocation!.longitude;
      _selectedAddress =
          _selectedAddressFromPicker ??
          '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}';
      _emitFormState();
    }
  }

  void _emitLocationPickerState() {
    emit(
      LocationPickerLoaded(
        lat: _selectedLocation?.latitude ?? 0.0,
        lng: _selectedLocation?.longitude ?? 0.0,
        address: _selectedAddressFromPicker ?? '',
        hasLocation: _selectedLocation != null,
        isGettingAddress: _isGettingAddress,
      ),
    );
  }

  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    emit(ReverseGeocodingLoading(lat: lat, lng: lng));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = _formatAddress(placemark);
        emit(ReverseGeocodingLoaded(lat: lat, lng: lng, address: address));
      } else {
        emit(
          ReverseGeocodingLoaded(
            lat: lat,
            lng: lng,
            address: '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
          ),
        );
      }
    } catch (e) {
      log('Error getting address from coordinates: $e');
      emit(
        ReverseGeocodingError(
          lat: lat,
          lng: lng,
          message: 'Failed to get address',
        ),
      );
    }
  }
}
