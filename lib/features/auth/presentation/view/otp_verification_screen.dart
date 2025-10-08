import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/auth/business/cubit/auth_cubit.dart';
import 'package:baqalty/features/auth/data/services/auth_services_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/custom_pin_code_text_field.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String? fromRegister, phone;
  const OtpVerificationScreen({super.key, this.fromRegister, this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthServicesImpl()),
      child: OtpVerificationScreenBody(
        fromRegister: fromRegister,
        phone: phone,
      ),
    );
  }
}

class OtpVerificationScreenBody extends StatefulWidget {
  final String? fromRegister, phone;
  const OtpVerificationScreenBody({super.key, this.fromRegister, this.phone});

  @override
  State<OtpVerificationScreenBody> createState() =>
      _OtpVerificationScreenBodyState();
}

class _OtpVerificationScreenBodyState extends State<OtpVerificationScreenBody> {
  final TextEditingController _otpController = TextEditingController();
  String _otpCode = "";
  bool _isOtpComplete = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing:
          context.watch<AuthCubit>().state is VerifyRegisterOtpLoadingState,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          return AuthBackgroundWidget(
            backgroundHeight: 200,
            overlayOpacity: 0.15,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
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

                            widget.fromRegister == 'register'
                                ? SizedBox.shrink()
                                : _buildResendCodeLink(),

                            SizedBox(height: 32),

                            _buildVerifyButton(
                              cubit,
                              widget.fromRegister,
                              widget.phone,
                            ),

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
        },
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return CustomPinCodeTextField(
          context: context,

          controller: _otpController,
          length: 6,
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
            if (widget.fromRegister == 'register') {
              cubit.verifyRegisterOtp(_otpCode, widget.phone ?? '');
            } else {
              cubit.verifyForgotPasswordOtp(_otpCode, widget.phone ?? '');
            }
          },
        );
      },
    );
  }

  Widget _buildResendCodeLink() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return state is ForgotPasswordLoadingState
            ? Center(
                child: SizedBox(height: 20, width: 20, child: loadingIndicator),
              )
            : Center(
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
                            if (widget.phone != null &&
                                widget.phone!.isNotEmpty) {
                              cubit.forgotPassword(phone: widget.phone);
                            } else {
                              ToastHelper.showErrorToast(
                                "Phone number not available",
                              );
                            }
                          },
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildVerifyButton(
    AuthCubit cubit,
    String? fromRegister,
    String? phone,
  ) {
    return PrimaryButton(
      isLoading: cubit.state is VerifyRegisterOtpLoadingState,
      text: "verify".tr(),
      onPressed: _isOtpComplete
          ? () {
              if (fromRegister == 'register') {
                cubit.verifyRegisterOtp(_otpCode, phone);
              } else {
                cubit.verifyForgotPasswordOtp(_otpCode, phone ?? '');
              }
            }
          : null,
    );
  }
}
