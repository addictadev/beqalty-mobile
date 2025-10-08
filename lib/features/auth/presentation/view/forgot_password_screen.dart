import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/auth/business/cubit/auth_cubit.dart';
import 'package:baqalty/features/auth/data/services/auth_services_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../widgets/auth_background_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthServicesImpl()),
      child: const ForgotPasswordScreenBody(),
    );
  }
}

class ForgotPasswordScreenBody extends StatefulWidget {
  const ForgotPasswordScreenBody({super.key});

  @override
  State<ForgotPasswordScreenBody> createState() =>
      _ForgotPasswordScreenBodyState();
}

class _ForgotPasswordScreenBodyState extends State<ForgotPasswordScreenBody> {
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

                      _buildEmailField(),

                      SizedBox(height: 32),

                      _buildSendCodeButton(),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              _buildRememberPasswordLink(),

              SizedBox(height: 5.h),
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
          "forgot_password_title".tr(),
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
          "forgot_password_description".tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
            fontFamily: FontFamilyUtils.getCurrentFontFamily(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return CustomTextFormField(
          label: "phone_number".tr(),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          controller: cubit.phoneController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "phone_required".tr();
            }
            String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

            if (cleanPhone.length != 11 || !cleanPhone.startsWith('0')) {
              return "invalid_phone_format".tr();
            }

            String prefix = cleanPhone.substring(0, 3);
            if (prefix.startsWith('01') ||
                (prefix.startsWith('0') && !prefix.startsWith('01'))) {
              return null;
            }

            return "invalid_phone_format".tr();
          },
        );
      },
    );
  }

  Widget _buildSendCodeButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return PrimaryButton(
          text: "send_code".tr(),
          onPressed: () {
            cubit.forgotPassword();
          },
          isLoading: cubit.state is ForgotPasswordLoadingState,
        );
      },
    );
  }

  Widget _buildRememberPasswordLink() {
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
              text: "remember_password".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
            TextSpan(
              text: "login".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}
