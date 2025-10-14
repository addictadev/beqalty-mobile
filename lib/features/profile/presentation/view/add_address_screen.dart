import 'package:baqalty/features/profile/business/cubit/profile_cubit.dart';
import 'package:baqalty/features/profile/data/models/add_address_request_model.dart';
import 'package:baqalty/features/profile/presentation/view/location_picker_add_addressscreen.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: const AddAddressScreenBody(),
    );
  }
}

class AddAddressScreenBody extends StatefulWidget {
  const AddAddressScreenBody({super.key});

  @override
  State<AddAddressScreenBody> createState() => _AddAddressScreenBodyState();
}

class _AddAddressScreenBodyState extends State<AddAddressScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _buildingNoController = TextEditingController();
  final _markerController = TextEditingController();
  final _extraDetailsController = TextEditingController();

  double _lat = 0.0;
  double _lng = 0.0;
  String _selectedAddress = '';
  final bool _isDefault = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _buildingNoController.dispose();
    _markerController.dispose();
    _extraDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "add_address".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        leading: const CustomBackButton(),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is ProfileLoaded) {
            setState(() {
              _isLoading = false;
            });
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("address_added_successfully".tr()),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is ProfileError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(context),

                  SizedBox(height: context.responsiveMargin * 2),

                  // Address Form
                  _buildAddressForm(context),

                  SizedBox(height: context.responsiveMargin * 2),

                  // Location Section
                  _buildLocationSection(context),

                  SizedBox(height: context.responsiveMargin * 3),

                  // Save Button
                  _buildSaveButton(context),

                  SizedBox(height: context.responsiveMargin * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.responsivePadding * 0.8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Iconsax.location_add,
              color: AppColors.white,
              size: context.responsiveIconSize,
            ),
          ),
          SizedBox(width: context.responsiveMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "add_new_address".tr(),
                  style: TextStyles.textViewSemiBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  "fill_address_details".tr(),
                  style: TextStyles.textViewRegular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "address_details".tr(),
            style: TextStyles.textViewSemiBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),

          // Title Field
          CustomTextFormField(
            controller: _titleController,
            label: "address_title".tr(),
            hint: "enter_address_title".tr(),
            prefixIcon: Icon(Iconsax.tag),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "title_required".tr();
              }
              return null;
            },
          ),

          SizedBox(height: context.responsiveMargin),

          // Street Field
          CustomTextFormField(
            controller: _streetController,
            label: "street".tr(),
            hint: "enter_street_name".tr(),
            prefixIcon: Icon(Iconsax.map),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "street_required".tr();
              }
              return null;
            },
          ),

          SizedBox(height: context.responsiveMargin),

          // City Field
          CustomTextFormField(
            controller: _cityController,
            label: "city".tr(),
            hint: "enter_city_name".tr(),
            prefixIcon: Icon(Iconsax.building),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "city_required".tr();
              }
              return null;
            },
          ),

          SizedBox(height: context.responsiveMargin),

          // Building Details Row
          Row(
            children: [
              // Building Number
              Expanded(
                child: CustomTextFormField(
                  controller: _buildingNoController,
                  label: "building_no".tr(),
                  hint: "enter_building_no".tr(),
                  prefixIcon: Icon(Iconsax.home),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "building_no_required".tr();
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: context.responsiveMargin),
              // Floor
              Expanded(
                child: CustomTextFormField(
                  controller: _floorController,
                  label: "floor".tr(),
                  hint: "enter_floor".tr(),
                  prefixIcon: Icon(Iconsax.arrow_up),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "floor_required".tr();
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveMargin),

          // Apartment Field
          CustomTextFormField(
            controller: _apartmentController,
            label: "apartment".tr(),
            hint: "enter_apartment".tr(),
            prefixIcon: Icon(Iconsax.home_2),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "apartment_required".tr();
              }
              return null;
            },
          ),

          SizedBox(height: context.responsiveMargin),

          // Marker Field
          CustomTextFormField(
            controller: _markerController,
            label: "marker".tr(),
            hint: "enter_landmark".tr(),
            prefixIcon: Icon(Iconsax.location),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "marker_required".tr();
              }
              return null;
            },
          ),

          SizedBox(height: context.responsiveMargin),

          // Extra Details Field
          CustomTextFormField(
            controller: _extraDetailsController,
            label: "extra_details".tr(),
            hint: "enter_extra_details".tr(),
            prefixIcon: Icon(Iconsax.document_text),
            maxLines: 3,
            validator: (value) {
              // Extra details are optional
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.location,
                color: AppColors.primary,
                size: context.responsiveIconSize,
              ),
              SizedBox(width: context.responsiveMargin * 0.5),
              Text(
                "location".tr(),
                style: TextStyles.textViewSemiBold16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveMargin),

          // Location Status
          Container(
            padding: EdgeInsets.all(context.responsivePadding),
            decoration: BoxDecoration(
              color: _lat != 0.0 && _lng != 0.0
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _lat != 0.0 && _lng != 0.0
                    ? AppColors.success
                    : AppColors.warning,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _lat != 0.0 && _lng != 0.0
                          ? Iconsax.tick_circle
                          : Iconsax.warning_2,
                      color: _lat != 0.0 && _lng != 0.0
                          ? AppColors.success
                          : AppColors.warning,
                      size: context.responsiveIconSize * 0.8,
                    ),
                    SizedBox(width: context.responsiveMargin * 0.5),
                    Expanded(
                      child: Text(
                        _lat != 0.0 && _lng != 0.0
                            ? "location_selected".tr()
                            : "location_required".tr(),
                        style: TextStyles.textViewRegular14.copyWith(
                          color: _lat != 0.0 && _lng != 0.0
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),

                // Show selected address if available
                if (_lat != 0.0 &&
                    _lng != 0.0 &&
                    _selectedAddress.isNotEmpty) ...[
                  SizedBox(height: context.responsiveMargin * 0.5),
                  Container(
                    padding: EdgeInsets.all(context.responsivePadding * 0.8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          color: AppColors.primary,
                          size: context.responsiveIconSize * 0.7,
                        ),
                        SizedBox(width: context.responsiveMargin * 0.5),
                        Expanded(
                          child: Text(
                            _selectedAddress,
                            style: TextStyles.textViewRegular12.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: context.responsiveMargin),

          // Select Location Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _selectLocation(context),
              icon: Icon(
                Iconsax.location,
                color: AppColors.primary,
                size: context.responsiveIconSize * 0.8,
              ),
              label: Text(
                "select_location".tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: context.responsivePadding,
                ),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: "save_address".tr(),
        isLoading: _isLoading,
        onPressed: _isLoading ? null : () => _saveAddress(context),
      ),
    );
  }

  void _selectLocation(BuildContext context) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerAddAdressScreen(
          initialLat: _lat != 0.0 ? _lat : null,
          initialLng: _lng != 0.0 ? _lng : null,
          initialAddress: _selectedAddress.isNotEmpty ? _selectedAddress : null,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _lat = result['lat'] as double;
        _lng = result['lng'] as double;
        _selectedAddress = result['address'] as String;
      });
    }
  }

  void _saveAddress(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_lat == 0.0 && _lng == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("please_select_location".tr()),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

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

    // Validate the request
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      final firstError = validationErrors.values.first;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firstError),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Call the API
    context.read<ProfileCubit>().addAddress(request);
  }
}
