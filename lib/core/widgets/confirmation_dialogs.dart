import 'package:flutter/material.dart';
import 'package:baqalty/core/widgets/custom_confirmation_dialog.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ConfirmationDialogs {
  /// Shows a delete account confirmation dialog
  static Future<bool?> showDeleteAccountDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: "delete_account".tr(),
          message: "delete_account_confirmation".tr(),
          primaryButtonText: "delete_account".tr(),
          icon: Icons.person_remove,
          iconColor: AppColors.error,
          primaryButtonColor: AppColors.error,
          onPrimaryPressed: () {
            Navigator.of(context).pop(true); // Return true for confirmation
          },
          onSecondaryPressed: () {
            Navigator.of(context).pop(false); // Return false for cancellation
          },
        );
      },
    );
  }

  /// Shows a logout confirmation dialog
  static Future<bool?> showLogoutDialog(BuildContext context) {
    debugPrint('showLogoutDialog called');
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        debugPrint('Building logout dialog');
        return CustomConfirmationDialog(
          title: "log_out".tr(),
          message: "logout_confirmation".tr(),
          primaryButtonText: "log_out".tr(),
          icon: Icons.logout,
          iconColor: AppColors.error,
          primaryButtonColor: AppColors.error,
          onPrimaryPressed: () {
            debugPrint('Logout confirmed in dialog');
            Navigator.of(context).pop(true); // Return true for confirmation
          },
          onSecondaryPressed: () {
            debugPrint('Logout cancelled in dialog');
            Navigator.of(context).pop(false); // Return false for cancellation
          },
        );
      },
    );
  }

  /// Shows a custom confirmation dialog
  static Future<bool?> showCustomConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonText,
    String secondaryButtonText = "cancel",
    required IconData icon,
    Color? iconColor,
    Color? primaryButtonColor,
    bool isDestructive = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: title,
          message: message,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          icon: icon,
          iconColor: iconColor,
          primaryButtonColor: primaryButtonColor,
          isDestructive: isDestructive,
          onPrimaryPressed: () {
            Navigator.of(context).pop(true); // Return true for confirmation
          },
          onSecondaryPressed: () {
            Navigator.of(context).pop(false); // Return false for cancellation
          },
        );
      },
    );
  }
}
