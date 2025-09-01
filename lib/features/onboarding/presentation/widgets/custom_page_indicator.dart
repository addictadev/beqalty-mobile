import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class CustomPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final Color activeColor;
  final Color? inactiveColor;
  final Duration animationDuration;

  const CustomPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeWidth = 24,
    this.inactiveWidth = 8,
    this.height = 8,
    this.activeColor = AppColors.white,
    this.inactiveColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: index == currentPage ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: index == currentPage
                ? activeColor
                : inactiveColor ?? activeColor.withValues(alpha: 0.3),
            boxShadow: index == currentPage
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
