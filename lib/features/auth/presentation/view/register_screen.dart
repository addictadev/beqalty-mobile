import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/core/utils/font_family_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/step_indicator_widget.dart';
import '../../business/cubit/auth_cubit.dart';
import '../../data/services/auth_services_impl.dart';
import 'address_registration_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthServicesImpl()),
      child: const RegisterScreenBody(),
    );
  }
}

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().startRegistration();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupControllers();
    });
  }

  void _setupControllers() {
    if (!mounted) return;

    final cubit = context.read<AuthCubit>();

    cubit.registerPasswordController.addListener(() {
      cubit.calculateRegisterPasswordStrength(
        cubit.registerPasswordController.text,
      );
      cubit.validateRegisterPasswordMatching();
    });

    cubit.registerConfirmPasswordController.addListener(() {
      cubit.validateRegisterPasswordMatching();
    });
  }

  Widget _buildPasswordStrengthIndicator(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: cubit.registerPasswordController,
      builder: (context, value, child) {
        final password = value.text;

        if (password.isEmpty) {
          return SizedBox.shrink();
        }

        final strength = _calculatePasswordStrength(password);
        final color = _getPasswordStrengthColor(strength);
        final strengthText = _getPasswordStrengthText(strength);

        return Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                color == Colors.green
                    ? Icons.check_circle
                    : color == Colors.orange
                    ? Icons.warning
                    : Icons.error,
                color: color,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                '${'password_strength'.tr()}: $strengthText',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  Color _getPasswordStrengthColor(int strength) {
    if (strength <= 2) return Colors.red;
    if (strength <= 3) return Colors.orange;
    return Colors.green;
  }

  String _getPasswordStrengthText(int strength) {
    if (strength <= 2) return 'weak'.tr();
    if (strength <= 3) return 'medium'.tr();
    return 'strong'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegistrationErrorState) {
          ToastHelper.showErrorToast(state.message);
        }
      },
      builder: (context, state) {
        return AuthBackgroundWidget(
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

                          SizedBox(height: 48),

                          _buildFormFields(),

                          SizedBox(height: 32),

                          _buildNextButton(),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  _buildLoginLink(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return CustomBackButton(
      icon: Icons.chevron_left,
      size: 40,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildStepIndicator() {
    return StepIndicatorWidget(
      currentStep: 1,
      totalSteps: 2,
      stepTitles: ["personal_info".tr(), "address_info".tr()],
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        _buildCharacterIllustration(),

        SizedBox(width: 16),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
                fontStyle: FontStyle.italic,
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
              children: [
                TextSpan(
                  text: "hello_register".tr(),
                  style: TextStyle(
                    fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                  ),
                ),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "to_get_started".tr(),
                  style: TextStyle(
                    fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterIllustration() {
    return CustomSvgImage(
      assetName: AppAssets.authLoginBackground,
      width: 30.w,
      height: 30.w,
    );
  }

  Widget _buildFormFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();

        return Form(
          key: cubit.userFormKey,
          child: Column(
            children: [
              CustomTextFormField(
                label: "name".tr(),
                controller: cubit.nameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "name_required".tr();
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              CustomTextFormField(
                label: "phone_number".tr(),
                controller: cubit.phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
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
              ),

              SizedBox(height: 20),

              CustomTextFormField(
                label: "email".tr(),
                controller: cubit.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "email_required".tr();
                  }
                  if (!value.contains('@')) {
                    return "invalid_email".tr();
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              CustomTextFormField(
                label: "password".tr(),
                controller: cubit.passwordController,
                obscureText: true,
                showVisibilityToggle: true,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password_required".tr();
                  }
                  if (value.length < 6) {
                    return "password_too_short".tr();
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),

              _buildPasswordStrengthIndicator(context),

              SizedBox(height: 20),

              CustomTextFormField(
                label: "confirm_password".tr(),
                controller: cubit.confirmPasswordController,
                obscureText: true,
                showVisibilityToggle: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "confirm_password_required".tr();
                  }
                  if (value != cubit.passwordController.text) {
                    return "passwords_dont_match".tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return PrimaryButton(
      text: "next_step".tr(),
      onPressed: () {
        context.read<AuthCubit>().handleNextStep();

        NavigationManager.navigateTo(AddressRegistrationScreen());
      },
    );
  }

  Widget _buildLoginLink() {
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
              text: "already_have_account".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
            TextSpan(
              text: "login_now".tr(),
              style: TextStyle(
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
