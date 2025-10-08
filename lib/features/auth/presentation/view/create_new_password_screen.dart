import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/auth_background_widget.dart';
import '../../business/cubit/auth_cubit.dart';
import '../../data/services/auth_services_impl.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key, this.phone});
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthServicesImpl()),
      child: CreateNewPasswordScreenBody(phone: phone),
    );
  }
}

class CreateNewPasswordScreenBody extends StatefulWidget {
  final String? phone;
  const CreateNewPasswordScreenBody({super.key, this.phone});

  @override
  State<CreateNewPasswordScreenBody> createState() =>
      _CreateNewPasswordScreenBodyState();
}

class _CreateNewPasswordScreenBodyState
    extends State<CreateNewPasswordScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupControllers();
    });
  }

  void _setupControllers() {
    if (!mounted) return;

    final cubit = context.read<AuthCubit>();

    // Set the phone in the cubit's phone controller
    if (widget.phone != null && widget.phone!.isNotEmpty) {
      cubit.phoneController.text = widget.phone!;
    }

    cubit.resetPasswordController.addListener(() {
      cubit.calculateResetPasswordStrength(cubit.resetPasswordController.text);
      cubit.validateResetPasswordMatching();
    });

    cubit.resetConfirmPasswordController.addListener(() {
      cubit.validateResetPasswordMatching();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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
                      child: Form(
                        key: cubit.resetPasswordFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 32),

                            _buildTitleSection(),

                            SizedBox(height: 48),

                            _buildPasswordField(cubit),

                            SizedBox(height: 8),

                            _buildPasswordStrengthIndicator(cubit),

                            SizedBox(height: 20),

                            _buildConfirmPasswordField(cubit),

                            SizedBox(height: 32),

                            _buildResetPasswordButton(cubit, state),

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
      },
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
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "password_requirement".tr(),
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

  Widget _buildPasswordField(AuthCubit cubit) {
    return CustomTextFormField(
      label: "new_password".tr(),
      controller: cubit.resetPasswordController,
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
    );
  }

  Widget _buildPasswordStrengthIndicator(AuthCubit cubit) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: cubit.resetPasswordController,
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
                strengthText,
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

  Widget _buildConfirmPasswordField(AuthCubit cubit) {
    return CustomTextFormField(
      label: "confirm_password".tr(),
      controller: cubit.resetConfirmPasswordController,
      obscureText: true,
      showVisibilityToggle: true,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "confirm_password_required".tr();
        }
        if (value != cubit.resetPasswordController.text) {
          return "passwords_not_match".tr();
        }
        return null;
      },
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  Color _getPasswordStrengthColor(int strength) {
    if (strength == 0) return Colors.grey;
    if (strength <= 2) return Colors.red;
    if (strength <= 3) return Colors.orange;
    return Colors.green;
  }

  String _getPasswordStrengthText(int strength) {
    if (strength == 0) return '';
    if (strength <= 2) return 'weak'.tr();
    if (strength <= 3) return 'medium'.tr();
    return 'strong'.tr();
  }

  Widget _buildResetPasswordButton(AuthCubit cubit, AuthState state) {
    return PrimaryButton(
      isLoading: state is ResetPasswordLoadingState,
      text: "reset_password".tr(),
      onPressed: () {
        if (cubit.resetPasswordFormKey.currentState!.validate()) {
          cubit.resetPassword(phone: widget.phone);
        }
      },
    );
  }
}
