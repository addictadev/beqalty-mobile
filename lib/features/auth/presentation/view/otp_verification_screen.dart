import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/custom_pin_code_text_field.dart';
import 'create_new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _otpCode = ""; // OTP code for validation
  bool _isOtpComplete = false;

  @override
  void dispose() {
    _otpController.dispose();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),

                      _buildTitleSection(),

                      SizedBox(height: 48),

                      _buildOtpField(),

                      SizedBox(height: 24),

                      _buildResendCodeLink(),

                      SizedBox(height: 32),

                      _buildVerifyButton(),

                      SizedBox(height: 40),
                    ],
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
          "otp_verification".tr(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
            fontFamily: FontFamilyUtils.getCurrentFontFamily(),
          ),
        ),
        SizedBox(height: 12),
        Text(
          "otp_description".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField() {
    return CustomPinCodeTextField(
      
      context: context,
      controller: _otpController,
      length: 4,
      onChanged: (value) {
        setState(() {
          _otpCode = value;
          _isOtpComplete = value.length == 4;
        });
      },
      oncomplete: (value) {
        setState(() {
          _otpCode = value;
          _isOtpComplete = true;
        });
      },
    );
  }

  Widget _buildResendCodeLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: "didnt_receive_code".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
            TextSpan(
              text: "resend".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Handle resend code logic
                  _showResendCodeDialog();
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return PrimaryButton(
      text: "verify".tr(),
      onPressed: _isOtpComplete
          ? () {
              // Handle OTP verification logic
              _handleOtpVerification();
            }
          : null,
    );
  }

  void _showResendCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "resend_code".tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          "resend_code_description".tr(),
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "cancel".tr(),
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle resend code logic here
              _showResendSuccessMessage();
            },
            child: Text(
              "resend".tr(),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResendSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "verification_code_sent".tr(),
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleOtpVerification() {
    // Simulate OTP verification
    if (_otpCode == "5131") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "otp_verified_success".tr(),
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // Navigate to create new password screen
      Future.delayed(const Duration(seconds: 1), () {
        NavigationManager.navigateTo(CreateNewPasswordScreen());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "invalid_otp_code".tr(),
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
