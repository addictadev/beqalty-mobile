import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class SuccessIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? checkmarkColor;

  const SuccessIcon({
    super.key,
    this.size = 80,
    this.backgroundColor,
    this.checkmarkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.success,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: checkmarkColor ?? AppColors.white,
          size: size * 0.6,
          weight: 900,
        ),
      ),
    );
  }
}
