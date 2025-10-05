import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
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
import 'address_registration_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
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
    // Initialize the registration flow
    context.read<AuthCubit>().startRegistration();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegistrationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
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
                  return null;
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

        // Navigate to address registration screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddressRegistrationScreen(),
          ),
        );
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
