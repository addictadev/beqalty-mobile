import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final Duration animationDuration;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 51,
    this.height = 31,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: animationDuration,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value
              ? (activeColor ?? AppColors.primary)
              : (inactiveColor ?? AppColors.borderLight),
        ),
        child: Stack(
          children: [
            // Thumb (circle)
            AnimatedPositioned(
              duration: animationDuration,
              curve: Curves.easeInOut,
              left: value ? width - height + 2 : 2,
              top: 2,
              child: Container(
                width: height - 4,
                height: height - 4,
                decoration: BoxDecoration(
                  color: thumbColor ?? AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
