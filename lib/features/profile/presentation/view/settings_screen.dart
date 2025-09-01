import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Settings",
        backgroundColor: AppColors.white,
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            children: [
              // General Section
              _buildSectionHeader(context, "General"),
              SizedBox(height: context.responsiveMargin),

              _buildSettingsItem(
                context,
                title: "Reset Password",
                onTap: () {
                  debugPrint('Reset Password tapped');
                },
              ),

              _buildSettingsItem(
                context,
                title: "Notifications",
                onTap: () {
                  debugPrint('Notifications tapped');
                },
              ),

              _buildSettingsItem(
                context,
                title: "Language",
                onTap: () {
                  debugPrint('Language tapped');
                },
              ),

              _buildSettingsItem(
                context,
                title: "Delete Account",
                onTap: () {
                  debugPrint('Delete Account tapped');
                },
                textColor: AppColors.error,
                showArrow: false,
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Security Section
              _buildSectionHeader(context, "Security"),
              SizedBox(height: context.responsiveMargin),

              _buildSettingsItem(
                context,
                title: "Privacy Policy",
                subtitle: "what data you share with us?",
                onTap: () {
                  debugPrint('Privacy Policy tapped');
                },
              ),

              const Spacer(),

              // Logout Button
              PrimaryButton(
                text: "Logout",
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              // Handle logout logic
                              debugPrint('Logout confirmed');
                              Navigator.of(context).pop(); // Go back to profile
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                color: AppColors.white,
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
                  style: TextStyles.textViewRegular12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
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
        style: TextStyles.textViewBold16.copyWith(color: AppColors.primary),
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius,
              ),
              border: Border.all(color: AppColors.borderLight, width: 1),
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
                    size: context.responsiveIconSize * 0.8,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
