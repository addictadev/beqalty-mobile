import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Donye Collins",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+23408146185683",
  );
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "my_account".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      // Main profile picture
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
                        child: ClipOval(
                          child: Image.asset(
                            AppAssets.appIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Camera edit icon
                      Positioned(
                        bottom: -1.w,
                        right: -1.w,
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
                    ],
                  ),
                ),

                SizedBox(height: context.responsiveMargin * 3),

                // Input Fields
                CustomTextFormField(
                  controller: _nameController,
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
                  controller: _phoneController,
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

                const Spacer(),

                // Save Button
                PrimaryButton(
                  text: "save".tr(),
                  margin: EdgeInsets.only(bottom: 2.h),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle save logic
                      debugPrint('Name: ${_nameController.text}');
                      debugPrint('Phone: ${_phoneController.text}');

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );

                      Navigator.of(context).pop();
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
      ),
    );
  }
}
