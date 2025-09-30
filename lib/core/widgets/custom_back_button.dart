import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size,
    this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final ic = icon ?? Icons.arrow_back_ios;
    final buttonSize = size ?? 9.w;
    final iconSize = (buttonSize * 0.5).clamp(16.0, 24.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          margin: EdgeInsets.only(left: 3.w),
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
}
