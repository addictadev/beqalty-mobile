import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart' show FontSizes;
import 'package:baqalty/features/auth/presentation/view/login_screen.dart';
import 'package:baqalty/features/profile/presentation/view/change_password_screen.dart';
import 'package:baqalty/features/profile/presentation/view/notifications_screen.dart';
import 'package:baqalty/features/profile/presentation/view/privacy_policy_screen.dart';
import 'package:baqalty/core/widgets/confirmation_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "settings".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General Section
              _buildSectionHeader(context, "general".tr()),
              SizedBox(height: context.responsiveMargin),

              _buildSettingsItem(
                context,
                title: "reset_password".tr(),
                onTap: () {
                  NavigationManager.navigateTo(ChangePasswordScreen());
                },
              ),

              _buildSettingsItem(
                context,
                title: "notifications".tr(),
                onTap: () {
                  NavigationManager.navigateTo(NotificationsScreen());
                },
              ),

              _buildSettingsItem(
                context,
                title: "language".tr(),
                onTap: () {
                  debugPrint('Language tapped');
                },
              ),
              SizedBox(height: context.responsiveMargin * 2),
              _buildSettingsItem(
                context,
                title: "delete_account".tr(),
                onTap: () async {
                  final confirmed =
                      await ConfirmationDialogs.showDeleteAccountDialog(
                        context,
                      );
                  if (confirmed == true) {
                    // Handle delete account logic here
                    debugPrint('Delete Account confirmed');
                    // Navigate to login screen after account deletion
                    if (context.mounted) {
                      NavigationManager.navigateToAndFinish(LoginScreen());
                    }
                  }
                },
                textColor: AppColors.error,
                showArrow: false,
              ),
              SizedBox(height: context.responsiveMargin * 2),
              // Security Section
              _buildSectionHeader(context, "security".tr()),
              SizedBox(height: context.responsiveMargin),
              _buildSettingsItem(
                context,
                title: "privacy_policy".tr(),
                subtitle: "privacy_policy_sub".tr(),
                onTap: () {
                  NavigationManager.navigateTo(PrivacyPolicyScreen());
                },
              ),
              const Spacer(),
              // Logout Button
              PrimaryButton(
                text: "logout".tr(),
                onPressed: () async {
                  // Show custom confirmation dialog
                  final confirmed = await ConfirmationDialogs.showLogoutDialog(
                    context,
                  );
                  if (confirmed == true) {
                    // Handle logout logic here
                    debugPrint('Logout confirmed');
                    // Navigate to login screen
                    if (context.mounted) {
                      NavigationManager.navigateToAndFinish(LoginScreen());
                    }
                  }
                },
                color: Colors.transparent,
                textStyle: TextStyles.textViewMedium16.copyWith(
                  color: AppColors.error,
                ),
                width: double.infinity,
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Copyright
              Center(
                child: Text(
                  "Baqalty © 2025 v1.0",
                  style: TextStyles.textViewRegular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: context.responsiveMargin * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsiveMargin),
      child: Text(
        title,
        style: TextStyles.textViewSemiBold16.copyWith(
          color: AppColors.textLight,
          fontSize: FontSizes.s16,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
    bool showArrow = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(context.responsivePadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius,
              ),
              // border: Border.all(
              //   color: AppColors.borderLight,
              //   width: 1,
              // ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.textViewMedium16.copyWith(
                          color: textColor ?? AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: context.responsiveMargin * 0.5),
                        Text(
                          subtitle,
                          style: TextStyles.textViewRegular12.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: context.responsiveIconSize * 1.0,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
