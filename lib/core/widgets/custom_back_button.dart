import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size,
    this.backgroundColor,
    this.iconColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? context.responsiveIconSize * 1.2;
    final bgColor = backgroundColor ?? AppColors.white;
    final icColor = iconColor ?? AppColors.black;
    final ic = icon ?? Icons.arrow_back_ios;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(ic, color: icColor, size: buttonSize * 0.4),
        ),
      ),
    );
  }
}
