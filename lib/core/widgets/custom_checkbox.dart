import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final double size;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;
  final double borderRadius;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24,
    this.activeColor,
    this.checkColor,
    this.borderColor,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        activeColor: activeColor ?? AppColors.primary,
        checkColor: checkColor ?? AppColors.white,
        side: BorderSide(
          color: borderColor ?? AppColors.borderLight,
          width: 1.5,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
