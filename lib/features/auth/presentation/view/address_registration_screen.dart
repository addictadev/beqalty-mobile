import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/step_indicator_widget.dart';
import '../../business/cubit/auth_cubit.dart';
import 'location_picker_screen.dart';

class AddressRegistrationScreen extends StatelessWidget {
  final AuthCubit authCubit;

  const AddressRegistrationScreen({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: const AddressRegistrationScreenBody(),
    );
  }
}

class AddressRegistrationScreenBody extends StatefulWidget {
  const AddressRegistrationScreenBody({super.key});

  @override
  State<AddressRegistrationScreenBody> createState() =>
      _AddressRegistrationScreenBodyState();
}

class _AddressRegistrationScreenBodyState
    extends State<AddressRegistrationScreenBody> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: context.watch<AuthCubit>().state is RegistrationLoadingState,

      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: GestureDetector(
              onHorizontalDragEnd: (details) {
                NavigationManager.pop();
              },
              child: AuthBackgroundWidget(
                backgroundHeight: 200,
                overlayOpacity: 0.15,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsivePadding,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),

                                _buildBackButton(),

                                SizedBox(height: 24),

                                _buildStepIndicator(),

                                SizedBox(height: 32),

                                _buildWelcomeSection(),

                                SizedBox(height: 32),

                                _buildFormFields(),

                                SizedBox(height: 32),

                                _buildActionButtons(),

                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        CustomBackButton(
          icon: Icons.chevron_left,
          size: 40,
          onPressed: () {
            NavigationManager.pop();
          },
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "swipe_right_to_go_back".tr(),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              fontFamily: FontFamilyUtils.getCurrentFontFamily(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return StepIndicatorWidget(
      currentStep: 2,
      totalSteps: 2,
      stepTitles: ["personal_info".tr(), "address_info".tr()],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "address_details".tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: FontFamilyUtils.getCurrentFontFamily(),
          ),
        ),
        SizedBox(height: 8),
        Text(
          "please_provide_address".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            fontFamily: FontFamilyUtils.getCurrentFontFamily(),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();

        return Form(
          key: cubit.addressFormKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerScreen(),
                    ),
                  );

                  if (result != null && mounted) {
                    final location = result['location'];
                    final address = result['address'];

                    cubit.locationController.text = address;

                    if (location != null) {
                      cubit.updateLocationCoordinates(
                        location.latitude,
                        location.longitude,
                      );
                    }
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    label: "location".tr(),
                    controller: cubit.locationController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "location_required".tr();
                      }
                      return null;
                    },
                    suffixIcon: Icon(
                      Iconsax.location,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // City
              CustomTextFormField(
                label: "city".tr(),
                controller: cubit.cityController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "city_required".tr();
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Street and Building Number
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextFormField(
                      label: "street".tr(),
                      controller: cubit.streetController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "street_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomTextFormField(
                      label: "building_no".tr(),
                      controller: cubit.buildingNoController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "building_no_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Floor and Apartment
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: "floor".tr(),
                      controller: cubit.floorController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "floor_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomTextFormField(
                      label: "apartment".tr(),
                      controller: cubit.apartmentController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "apartment_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Title and Marker
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: "title".tr(),
                      controller: cubit.titleController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "title_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomTextFormField(
                      label: "marker".tr(),
                      controller: cubit.markerController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "marker_required".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Extra Details
              CustomTextFormField(
                label: "extra_details".tr(),
                controller: cubit.extraDetailsController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  // Extra details is optional
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            PrimaryButton(
              text: "complete_registration".tr(),
              onPressed:
                  context.watch<AuthCubit>().state is RegistrationLoadingState
                  ? null
                  : () {
                      context.read<AuthCubit>().register();
                    },
              isLoading:
                  context.watch<AuthCubit>().state is RegistrationLoadingState,
            ),

            SizedBox(height: 16),

            TextButton(
              onPressed:
                  context.watch<AuthCubit>().state is RegistrationLoadingState
                  ? null
                  : () {
                      NavigationManager.pop();
                    },
              child: Text(
                "back_to_personal_info".tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
