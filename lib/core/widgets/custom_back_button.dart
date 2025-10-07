import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import '../navigation_services/navigation_manager.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool smartBack; // New parameter to enable smart back functionality

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.smartBack = false, // Default to false for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    final ic = icon ?? Icons.arrow_back_ios;
    final buttonSize = size ?? 9.w;
    final iconSize = (buttonSize * 0.5).clamp(16.0, 24.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => _handleBackPress(context),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          margin: EdgeInsets.only(left: 3.w,),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              ic,
              color: iconColor ?? AppColors.textPrimary,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }

  void _handleBackPress(BuildContext context) {
    if (smartBack) {
      // Check if we can pop the current route
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        // If we're at the root, show exit dialog
        NavigationManager.showExitDialog(context);
      }
    } else {
      // Default behavior - just pop
      Navigator.of(context).pop();
    }
  }
}
