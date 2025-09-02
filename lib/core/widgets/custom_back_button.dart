import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final IconData? icon;

  const CustomBackButton({super.key, this.onPressed, this.size, this.icon});

  @override
  Widget build(BuildContext context) {
    final ic = icon ?? Icons.arrow_back_ios;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        // width: 5.w,
        // height: 5.w,
        margin: EdgeInsets.only(left: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,

          boxShadow: [],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsivePadding * .6,
            vertical: context.responsivePadding * .4,
          ),
          child: Center(
            child: Icon(ic, color: Colors.black, size: 5.w),
          ),
        ),
      ),
    );
  }
}
