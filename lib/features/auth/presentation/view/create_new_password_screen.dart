import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/auth_background_widget.dart';
import 'password_changed_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      backgroundHeight: 200,
      overlayOpacity: 0.15,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              _buildBackButton(),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32),

                        _buildTitleSection(),

                        SizedBox(height: 48),

                        _buildPasswordField(),

                        SizedBox(height: 20),

                        _buildConfirmPasswordField(),

                        SizedBox(height: 32),

                        _buildResetPasswordButton(),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return CustomBackButton(icon: Icons.chevron_left, size: 40);
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "create_new_password".tr(),
          style: GoogleFonts.robotoFlex(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "password_requirement".tr(),
          style: GoogleFonts.robotoFlex(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFormField(
      label: "password".tr(),
      controller: _passwordController,
      obscureText: true,
      showVisibilityToggle: true,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "password_required".tr();
        }
        if (value.length < 8) {
          return "password_min_length".tr();
        }
        return null;
      },
      onChanged: (value) {
        // Password validation is handled by the validator
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormField(
      label: "confirm_password".tr(),
      controller: _confirmPasswordController,
      obscureText: true,
      showVisibilityToggle: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "confirm_password_required".tr();
        }
        if (value != _passwordController.text) {
          return "passwords_not_match".tr();
        }
        return null;
      },
      onChanged: (value) {
        // Confirm password validation is handled by the validator
      },
    );
  }

  Widget _buildResetPasswordButton() {
    return PrimaryButton(
      text: "reset_password".tr(),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _handlePasswordReset();
        }
      },
    );
  }

  void _handlePasswordReset() {
    // Simulate password reset
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "password_reset_success".tr(),
          style: GoogleFonts.robotoFlex(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    // Navigate to password changed success screen
    Future.delayed(const Duration(seconds: 1), () {
      NavigationManager.navigateToAndFinish(PasswordChangedScreen());
    });
  }
}
