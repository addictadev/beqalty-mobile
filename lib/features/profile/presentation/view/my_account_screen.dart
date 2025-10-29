import 'dart:io';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/features/auth/business/cubit/auth_cubit.dart';
import 'package:baqalty/features/auth/data/services/auth_services_impl.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthServicesImpl()),
      child: const MyAccountScreenBody(),
    );
  }
}

class MyAccountScreenBody extends StatefulWidget {
  const MyAccountScreenBody({super.key});

  @override
  State<MyAccountScreenBody> createState() => _MyAccountScreenBodyState();
}

class _MyAccountScreenBodyState extends State<MyAccountScreenBody> {
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "my_account".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccessState) {
            // Refresh the UI to show updated avatar immediately
            setState(() {
              _selectedImage = null; // Clear selected image to show updated avatar
            });
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is GetUserErrorState) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<AuthCubit>().getUser(),
                  ),
                ),
              );
            }
            if (state is GetUserLoadingState) {
              return Center(child: loadingIndicator);
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.responsivePadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: context.responsiveIconSize * 5,
                              height: context.responsiveIconSize * 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.characterSkinTone,
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowLight,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(child: _buildProfileImage()),
                            ),
                            Positioned(
                              bottom: -1.w,
                              right: -1.w,
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePickerBottomSheet();
                                },
                                child: Container(
                                  width: context.responsiveIconSize * 1.4,
                                  height: context.responsiveIconSize * 1.4,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: CustomImageAsset(
                                    assetName: AppAssets.profileCamera,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: context.responsiveMargin),

                      Text(
                        "profile_image_optional".tr(),
                        style: TextStyles.textViewMedium12.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: context.responsiveMargin * 2),

                      CustomTextFormField(
                        controller: context.read<AuthCubit>().nameController,
                        label: "name".tr(),
                        hint: "enter_your_name".tr(),
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please_enter_name'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: context.responsiveMargin * 2),

                      CustomTextFormField(
                        controller: context.read<AuthCubit>().emailController,
                        label: "email".tr(),
                        hint: "enter_your_email".tr(),
                        prefixIcon: Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please_enter_email'.tr();
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'please_enter_valid_email'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: context.responsiveMargin * 2),

                      IgnorePointer(
                        child: CustomTextFormField(
                          controller: context.read<AuthCubit>().phoneController,
                          label: "phone_number".tr(),
                          hint: "enter_your_phone".tr(),
                          prefixIcon: Icon(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_phone'.tr();
                            }
                            return null;
                          },
                        ),
                      ),

                      const Spacer(),

                      PrimaryButton(
                        loadingWidget: loadingIndicator,
                        isLoading:
                            context.read<AuthCubit>().state
                                is UpdateProfileLoadingState,
                        text: _selectedImage != null
                            ? "save_with_image".tr()
                            : "save_changes".tr(),
                        margin: EdgeInsets.only(bottom: 2.h),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final cubit = context.read<AuthCubit>();
                            cubit.updateProfile(_selectedImage);
                          }
                        },
                        color: AppColors.bgProfile,
                        textStyle: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),

                        width: double.infinity,
                      ),

                      SizedBox(height: context.responsiveMargin * 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is GetUserSuccessState) {
      final userAvatar = authState.user.avatar;

      if (userAvatar != null && userAvatar.isNotEmpty) {
        return CustomCachedImage(
          imageUrl: userAvatar,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }

    return Image.asset(AppAssets.appIcon, fit: BoxFit.cover);
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildImagePickerBottomSheet(context),
    );
  }

  Widget _buildImagePickerBottomSheet(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.responsivePadding * 1.5),
            child: Column(
              children: [
                _buildOptionTile(
                  context,
                  icon: Icons.camera_alt,
                  title: 'take_photo'.tr(),
                  subtitle: 'take_photo_desc'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                SizedBox(height: context.responsiveMargin),
                _buildOptionTile(
                  context,
                  icon: Icons.photo_library,
                  title: 'choose_from_gallery'.tr(),
                  subtitle: 'choose_from_gallery_desc'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                SizedBox(height: context.responsiveMargin * 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.responsivePadding * 1.2),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: context.responsiveIconSize * 1.5,
              height: context.responsiveIconSize * 1.5,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: context.responsiveIconSize,
              ),
            ),
            SizedBox(width: context.responsiveMargin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ResponsiveUtils.getResponsiveTextStyle(
                      context,
                      fontWeight: FontWeight.w600,
                      fontSize: context.isMobile ? 14 : 16,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: ResponsiveUtils.getResponsiveTextStyle(
                      context,
                      fontSize: context.isMobile ? 12 : 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ToastHelper.showErrorToast("failed_to_pick_image".tr());
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ToastHelper.showErrorToast("failed_to_pick_image".tr());
    }
  }
}
