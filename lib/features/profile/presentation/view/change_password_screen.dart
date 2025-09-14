import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOldPasswordValid = false;
  bool _isNewPasswordValid = false;
  bool _isRetypePasswordValid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "change_password".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.responsiveMargin * 2),

                        // Old Password Field
                        _buildPasswordField(
                          controller: _oldPasswordController,
                          label: "old_password".tr(),
                          onChanged: (value) {
                            setState(() {
                              _isOldPasswordValid = value.isNotEmpty;
                            });
                          },
                        ),

                        SizedBox(height: context.responsiveMargin * 2),

                        // New Password Field
                        _buildPasswordField(
                          controller: _newPasswordController,
                          label: "new_password".tr(),
                          onChanged: (value) {
                            setState(() {
                              _isNewPasswordValid =
                                  value.isNotEmpty && value.length >= 8;
                              _validateRetypePassword();
                            });
                          },
                        ),

                        SizedBox(height: context.responsiveMargin * 2),

                        // Retype New Password Field
                        _buildPasswordField(
                          controller: _retypePasswordController,
                          label: "retype_new_password".tr(),
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            setState(() {
                              _validateRetypePassword();
                            });
                          },
                        ),

                        SizedBox(height: context.responsiveMargin * 4),
                      ],
                    ),
                  ),
                ),

                // Save Button
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return CustomTextFormField(
      label: label,
      controller: controller,
      obscureText: true,
      showVisibilityToggle: true,
      onChanged: onChanged,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "password_required".tr();
        }
        if (label == "new_password".tr() && value.length < 8) {
          return "password_min_length".tr();
        }
        if (label == "retype_new_password".tr() &&
            value != _newPasswordController.text) {
          return "passwords_not_match".tr();
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    final isFormValid =
        _isOldPasswordValid && _isNewPasswordValid && _isRetypePasswordValid;

    return PrimaryButton(
      text: "save".tr(),
      onPressed: isFormValid ? _handleSavePassword : null,
      isLoading: _isLoading,
      color: isFormValid ? AppColors.primary : AppColors.borderLight,
      textStyle: TextStyles.textViewMedium16.copyWith(
        color: isFormValid ? AppColors.white : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      borderRadius: 12,
      height: 56,
    );
  }

  void _validateRetypePassword() {
    _isRetypePasswordValid =
        _retypePasswordController.text.isNotEmpty &&
        _retypePasswordController.text == _newPasswordController.text;
  }

  void _handleSavePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password changed successfully!',
            style: TextStyles.textViewMedium14.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }
}
