import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../widgets/auth_background_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

              CustomBackButton(icon: Icons.chevron_left, size: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      _buildWelcomeSection(),

                      SizedBox(height: 40),

                      CustomTextFormField(
                        label: "phone_number".tr(),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: 20),

                      CustomTextFormField(
                        label: "password".tr(),
                        obscureText: true,
                        showVisibilityToggle: true,
                        textInputAction: TextInputAction.done,
                      ),

                      SizedBox(height: 16),

                      _buildForgotPasswordLink(),

                      SizedBox(height: 32),

                      PrimaryButton(
                        text: "login".tr(),
                        onPressed: () {
                          NavigationManager.navigateTo(
                            MainNavigationScreen(),
                          );
                        },
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              _buildRegisterLink(),

              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomSvgImage(
          assetName: AppAssets.authLoginBackground,
          width: 30.w,
          height: 30.w,
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: LocalizeAndTranslate.getLanguageCode() == 'ar'
                    ? GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.2,
                        fontStyle: FontStyle.italic,
                      )
                    : GoogleFonts.robotoFlex(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.2,
                        fontStyle: FontStyle.italic,
                      ),
                children: [
                  TextSpan(text: "welcome_back".tr()),
                  const TextSpan(text: "\n"),
                  TextSpan(text: "glad_to_see_you".tr()),
                  const TextSpan(text: "\n"),
                  TextSpan(text: "again".tr()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          NavigationManager.navigateTo(ForgotPasswordScreen());
        },
        child: Text(
          "forgot_password".tr(),
          style: GoogleFonts.robotoFlex(
            fontSize: FontSizes.s14,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.robotoFlex(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: "dont_have_account".tr()),
            TextSpan(
              text: "register_now".tr(),
              style: GoogleFonts.robotoFlex(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  NavigationManager.navigateTo(RegisterScreen());
                },
            ),
          ],
        ),
      ),
    );
  }
}
