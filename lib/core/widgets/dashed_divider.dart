import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpace;
  final Color? color;
  final EdgeInsets? margin;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(
          50, // Generate enough dashes to fill the width
          (index) => Expanded(
            child: Container(
              height: height,
              margin: EdgeInsets.only(right: index.isEven ? dashSpace : 0),
              color: index.isEven
                  ? (color ?? AppColors.borderLight)
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
