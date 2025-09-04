import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final IconData icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? primaryButtonColor;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool isDestructive;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.secondaryButtonText = "cancel",
    required this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.primaryButtonColor,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.isDestructive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: context.responsivePadding * 0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: TextStyles.textViewMedium18.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: context.responsiveMargin * 2),
            
            // Main Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.responsivePadding * 2),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icon Container
                  Container(
                    width: context.responsiveIconSize * 3,
                    height: context.responsiveIconSize * 3,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? AppColors.borderLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: context.responsiveIconSize * 1.5,
                      color: iconColor ?? AppColors.error,
                    ),
                  ),
                  
                  SizedBox(height: context.responsiveMargin * 2),
                  
                  // Confirmation Message
                  Text(
                    message,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: context.responsiveMargin * 3),
                  
                  // Primary Button
                  SizedBox(
                    width: double.infinity,
                    height: context.responsiveButtonHeight*.5,
                    child: ElevatedButton(
                      onPressed: onPrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor ?? AppColors.error,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        primaryButtonText,
                        style: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: context.responsiveMargin * 1.5),
                  
                  // Secondary Button
                  TextButton(
                    onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
                    child: Text(
                      secondaryButtonText.tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
