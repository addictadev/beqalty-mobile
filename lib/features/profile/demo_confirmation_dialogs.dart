import 'package:flutter/material.dart';
import 'package:baqalty/core/widgets/confirmation_dialogs.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

class ConfirmationDialogsDemo extends StatelessWidget {
  const ConfirmationDialogsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation Dialogs Demo'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.responsiveMargin * 2),
              
              Text(
                'Confirmation Dialogs Demo',
                style: TextStyles.textViewMedium24.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: context.responsiveMargin),
              
              Text(
                'This demo showcases the confirmation dialogs for delete account and logout actions, matching the design in the attached image.',
                style: TextStyles.textViewMedium16.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              
              SizedBox(height: context.responsiveMargin * 3),
              
              // Delete Account Button
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await ConfirmationDialogs.showDeleteAccountDialog(context);
                    if (confirmed == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Delete Account confirmed!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Delete Account cancelled'),
                          backgroundColor: AppColors.textSecondary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                    ),
                  ),
                  child: Text(
                    'Show Delete Account Dialog',
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: context.responsiveMargin * 2),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await ConfirmationDialogs.showLogoutDialog(context);
                    if (confirmed == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout confirmed!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout cancelled'),
                          backgroundColor: AppColors.textSecondary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                    ),
                  ),
                  child: Text(
                    'Show Logout Dialog',
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: context.responsiveMargin * 2),
              
              // Custom Confirmation Button
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await ConfirmationDialogs.showCustomConfirmationDialog(
                      context: context,
                      title: 'Custom Action',
                      message: 'Are you sure you want to perform this custom action?',
                      primaryButtonText: 'Confirm Action',
                      icon: Icons.warning,
                      iconColor: AppColors.warning,
                      primaryButtonColor: AppColors.warning,
                    );
                    if (confirmed == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Custom action confirmed!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Custom action cancelled'),
                          backgroundColor: AppColors.textSecondary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                    ),
                  ),
                  child: Text(
                    'Show Custom Confirmation Dialog',
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
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
}
