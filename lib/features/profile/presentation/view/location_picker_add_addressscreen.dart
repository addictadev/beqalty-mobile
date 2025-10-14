import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class LocationPickerAddAdressScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationPickerAddAdressScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<LocationPickerAddAdressScreen> createState() =>
      _LocationPickerAddAdressScreenState();
}

class _LocationPickerAddAdressScreenState
    extends State<LocationPickerAddAdressScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = false;
  bool _isGettingAddress = false;

  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);
  LatLng _currentLocation = _defaultLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _getCurrentLocation();
  }

  void _initializeLocation() {
    if (widget.initialLat != null && widget.initialLng != null) {
      _currentLocation = LatLng(widget.initialLat!, widget.initialLng!);
      _selectedLocation = _currentLocation;
      _selectedAddress = widget.initialAddress;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationErrorDialog('location_services_disabled'.tr());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationErrorDialog('location_permission_denied'.tr());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationErrorDialog('location_permission_permanently_denied'.tr());
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation ??= _currentLocation;
      });

      await _getAddressFromCoordinates(_currentLocation);
    } catch (e) {
      log('Error getting current location: $e');
      _showLocationErrorDialog('error_getting_location'.tr());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    setState(() {
      _isGettingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = _formatAddress(placemark);
        setState(() {
          _selectedAddress = address;
        });
      }
    } catch (e) {
      log('Error getting address: $e');
      setState(() {
        _selectedAddress =
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
      });
    } finally {
      setState(() {
        _isGettingAddress = false;
      });
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

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _getAddressFromCoordinates(location);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveToCurrentLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, {
        'lat': _selectedLocation!.latitude,
        'lng': _selectedLocation!.longitude,
        'address':
            _selectedAddress ??
            '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
      });
    }
  }

  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'location_error'.tr(),
          style: TextStyle(
            fontFamily: FontFamilyUtils.getCurrentFontFamily(),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: FontFamilyUtils.getCurrentFontFamily()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ok'.tr(),
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 15.0,
                    ),
                    onTap: _onMapTap,
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: _selectedLocation!,
                              draggable: true,
                              onDragEnd: (newPosition) {
                                setState(() {
                                  _selectedLocation = newPosition;
                                });
                                _getAddressFromCoordinates(newPosition);
                              },
                            ),
                          }
                        : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),

                  if (_selectedLocation == null)
                    const Center(
                      child: Icon(
                        Iconsax.location,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),

                  if (_isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 16,
      ),

      child: Row(
        children: [
          CustomBackButton(
            icon: Icons.chevron_left,
            size: 40,
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'select_location'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
          ),

          IconButton(
            onPressed: _isLoading
                ? null
                : () {
                    _getCurrentLocation();
                    _moveToCurrentLocation();
                  },
            icon: Icon(
              Icons.my_location,
              color: _isLoading ? AppColors.textSecondary : AppColors.primary,
            ),
            tooltip: 'current_location'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedAddress != null) ...[
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedAddress!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                    ),
                  ),
                ),
                if (_isGettingAddress)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
          ],

          Text(
            'tap_on_map_to_select_location'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              fontFamily: FontFamilyUtils.getCurrentFontFamily(),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          PrimaryButton(
            text: 'confirm_location'.tr(),
            onPressed: _selectedLocation != null ? _confirmLocation : null,
            isLoading: _isGettingAddress,
          ),
        ],
      ),
    );
  }
}
