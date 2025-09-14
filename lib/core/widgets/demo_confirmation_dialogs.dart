import 'package:flutter/material.dart';
import 'package:baqalty/core/widgets/confirmation_dialogs.dart';
import 'package:baqalty/core/widgets/custom_confirmation_dialog.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

class ConfirmationDialogsTestDemo extends StatelessWidget {
  const ConfirmationDialogsTestDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation Dialogs Test'),
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
                'Test Confirmation Dialogs',
                style: TextStyles.textViewMedium24.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: context.responsiveMargin),

              Text(
                'This demo tests the confirmation dialogs to ensure they work properly.',
                style: TextStyles.textViewMedium16.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: context.responsiveMargin * 3),

              // Test basic dialog
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Testing basic dialog...');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Basic Dialog'),
                        content: const Text('This is a basic AlertDialog test'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              debugPrint('Basic dialog OK pressed');
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Test Basic Dialog'),
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Test custom confirmation dialog directly
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint(
                      'Testing custom confirmation dialog directly...',
                    );
                    showDialog(
                      context: context,
                      builder: (context) => CustomConfirmationDialog(
                        title: "Test Custom Dialog",
                        message:
                            "This is a direct test of CustomConfirmationDialog",
                        primaryButtonText: "Confirm",
                        icon: Icons.info,
                        onPrimaryPressed: () {
                          debugPrint('Custom dialog confirmed');
                          Navigator.of(context).pop();
                        },
                        onSecondaryPressed: () {
                          debugPrint('Custom dialog cancelled');
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Test Custom Dialog Directly'),
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Test logout dialog through helper
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    debugPrint('Testing logout dialog through helper...');
                    try {
                      final confirmed =
                          await ConfirmationDialogs.showLogoutDialog(context);
                      debugPrint('Logout dialog result: $confirmed');
                      if (confirmed == true) {
                        debugPrint('Logout confirmed!');
                      } else {
                        debugPrint('Logout cancelled!');
                      }
                    } catch (e) {
                      debugPrint('Error showing logout dialog: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Test Logout Dialog (Helper)'),
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Test delete account dialog through helper
              SizedBox(
                width: double.infinity,
                height: context.responsiveButtonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    debugPrint(
                      'Testing delete account dialog through helper...',
                    );
                    try {
                      final confirmed =
                          await ConfirmationDialogs.showDeleteAccountDialog(
                            context,
                          );
                      debugPrint('Delete account dialog result: $confirmed');
                      if (confirmed == true) {
                        debugPrint('Delete account confirmed!');
                      } else {
                        debugPrint('Delete account cancelled!');
                      }
                    } catch (e) {
                      debugPrint('Error showing delete account dialog: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Test Delete Account Dialog (Helper)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
