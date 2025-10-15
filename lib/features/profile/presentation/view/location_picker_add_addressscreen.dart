import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baqalty/features/profile/business/cubit/profile_cubit.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationPickerAddAdressScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileCubit>(),
      child: LocationPickerAddAdressScreenBody(
        initialLat: initialLat,
        initialLng: initialLng,
        initialAddress: initialAddress,
      ),
    );
  }
}

class LocationPickerAddAdressScreenBody extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationPickerAddAdressScreenBody({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<LocationPickerAddAdressScreenBody> createState() =>
      _LocationPickerAddAdressScreenBodyState();
}

class _LocationPickerAddAdressScreenBodyState
    extends State<LocationPickerAddAdressScreenBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().initializeLocationPicker(
      initialLat: widget.initialLat,
      initialLng: widget.initialLng,
      initialAddress: widget.initialAddress,
    );
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
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is LocationPickerError) {
          _showLocationErrorDialog(state.message);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is LocationPickerLoaded) {
            return _buildMapView(context, state);
          } else if (state is LocationPickerLoading) {
            return _buildLoadingView(context);
          } else {
            return _buildMapView(context, null);
          }
        },
      ),
    );
  }

  Widget _buildMapView(BuildContext context, LocationPickerLoaded? state) {
    final cubit = context.read<ProfileCubit>();
    final currentLocation = cubit.currentLocation;
    final selectedLocation = cubit.selectedLocation;
    final isLoading = cubit.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, cubit),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: cubit.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 15.0,
                    ),
                    onTap: cubit.onMapTap,
                    markers: selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: selectedLocation,
                              draggable: true,
                              onDragEnd: (newPosition) {
                                cubit.onMapTap(newPosition);
                              },
                            ),
                          }
                        : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),

                  if (selectedLocation == null)
                    const Center(
                      child: Icon(
                        Iconsax.location,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),

                  if (isLoading)
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

            _buildBottomPanel(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, context.read<ProfileCubit>()),
            Expanded(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
            onPressed: cubit.isLoading
                ? null
                : () {
                    cubit.moveToCurrentLocation();
                  },
            icon: Icon(
              Icons.my_location,
              color: cubit.isLoading
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            tooltip: 'current_location'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context, LocationPickerLoaded? state) {
    final cubit = context.read<ProfileCubit>();
    final selectedAddress = state?.address ?? '';
    final hasLocation = state?.hasLocation ?? false;
    final isGettingAddress = state?.isGettingAddress ?? false;

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
          if (selectedAddress.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                    ),
                  ),
                ),
                if (isGettingAddress)
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
            onPressed: hasLocation
                ? () => _confirmLocation(context, cubit)
                : null,
            isLoading: isGettingAddress,
          ),
        ],
      ),
    );
  }

  void _confirmLocation(BuildContext context, ProfileCubit cubit) {
    cubit.confirmLocation();
    Navigator.pop(context, {
      'lat': cubit.lat,
      'lng': cubit.lng,
      'address': cubit.selectedAddress,
    });
  }
}
