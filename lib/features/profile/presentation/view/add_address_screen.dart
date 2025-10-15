import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/features/profile/business/cubit/profile_cubit.dart';
import 'package:baqalty/features/profile/data/models/addresses_response_model.dart';
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
  final bool isEdit;
  final AddressModel? addressToEdit;

  const AddAddressScreen({super.key, this.isEdit = false, this.addressToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfileCubit();
        if (isEdit && addressToEdit != null) {
          cubit.initializeEditAddressForm(addressToEdit!);
        } else {
          cubit.initializeAddressForm();
        }
        return cubit;
      },
      child: AddAddressScreenBody(isEdit: isEdit, addressToEdit: addressToEdit),
    );
  }
}

class AddAddressScreenBody extends StatelessWidget {
  final bool isEdit;
  final AddressModel? addressToEdit;

  const AddAddressScreenBody({
    super.key,
    this.isEdit = false,
    this.addressToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      child: AbsorbPointer(
        absorbing: context.read<ProfileCubit>().state is AddAddressLoading,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: CustomAppBar(
            title: isEdit ? "edit_address".tr() : "add_address".tr(),
            titleColor: AppColors.textPrimary,
            iconColor: AppColors.textPrimary,
            leading: const CustomBackButton(),
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is AddressFormLoaded) {
                return _buildForm(context, state);
              } else {
                return _buildForm(context, null);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AddressFormLoaded? state) {
    final cubit = context.read<ProfileCubit>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            SizedBox(height: context.responsiveMargin * 2),
            _buildAddressForm(context, cubit),
            SizedBox(height: context.responsiveMargin * 2),
            _buildLocationSection(context, state),
            SizedBox(height: context.responsiveMargin * 2),
            // if (isEdit) ...[
            //   _buildDefaultToggle(context, state),
            //   SizedBox(height: context.responsiveMargin * 2),
            // ],
            SizedBox(height: context.responsiveMargin * 3),
            _buildSaveButton(context),
            SizedBox(height: context.responsiveMargin * 2),
          ],
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
                  isEdit ? "edit_address_details".tr() : "add_new_address".tr(),
                  style: TextStyles.textViewSemiBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  isEdit
                      ? "update_address_details".tr()
                      : "fill_address_details".tr(),
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

  Widget _buildAddressForm(BuildContext context, ProfileCubit cubit) {
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

          CustomTextFormField(
            controller: cubit.titleController,
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

          CustomTextFormField(
            controller: cubit.streetController,
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

          CustomTextFormField(
            controller: cubit.cityController,
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

          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: cubit.buildingNoController,
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

              Expanded(
                child: CustomTextFormField(
                  controller: cubit.floorController,
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

          CustomTextFormField(
            controller: cubit.apartmentController,
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

          CustomTextFormField(
            controller: cubit.markerController,
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

          CustomTextFormField(
            controller: cubit.extraDetailsController,
            label: "extra_details".tr(),
            hint: "enter_extra_details".tr(),
            prefixIcon: Icon(Iconsax.document_text),
            maxLines: 3,
            validator: (value) {
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, AddressFormLoaded? state) {
    final cubit = context.read<ProfileCubit>();
    final hasLocation = state?.lat != 0.0 && state?.lng != 0.0;
    final selectedAddress = state?.selectedAddress ?? '';

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

          Container(
            padding: EdgeInsets.all(context.responsivePadding),
            decoration: BoxDecoration(
              color: hasLocation
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasLocation ? AppColors.success : AppColors.warning,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      hasLocation ? Iconsax.tick_circle : Iconsax.warning_2,
                      color: hasLocation
                          ? AppColors.success
                          : AppColors.warning,
                      size: context.responsiveIconSize * 0.8,
                    ),
                    SizedBox(width: context.responsiveMargin * 0.5),
                    Expanded(
                      child: Text(
                        hasLocation
                            ? "location_selected".tr()
                            : "location_required".tr(),
                        style: TextStyles.textViewRegular14.copyWith(
                          color: hasLocation
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),

                if (hasLocation && selectedAddress.isNotEmpty) ...[
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
                            selectedAddress,
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

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _selectLocation(context, cubit),
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
        text: isEdit ? "update_address".tr() : "save_address".tr(),
        isLoading: context.read<ProfileCubit>().state is AddAddressLoading,
        onPressed: () => _saveAddress(context),
      ),
    );
  }

  void _selectLocation(BuildContext context, ProfileCubit cubit) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: cubit,
          child: LocationPickerAddAdressScreen(
            initialLat: cubit.lat != 0.0 ? cubit.lat : null,
            initialLng: cubit.lng != 0.0 ? cubit.lng : null,
            initialAddress: cubit.selectedAddress.isNotEmpty
                ? cubit.selectedAddress
                : null,
          ),
        ),
      ),
    );

    if (result != null) {
      cubit.updateLocation(
        result['lat'] as double,
        result['lng'] as double,
        result['address'] as String,
      );
    }
  }

  void _saveAddress(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    if (!cubit.hasLocation) {
      ToastHelper.showErrorToast("please_select_location".tr());
      return;
    }

    // Pass addressId for edit mode
    final addressId = isEdit ? addressToEdit?.id : null;
    cubit.submitAddress(addressId: addressId);
  }
}
