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
        width: 9.w,
        height: 9.w,
        margin: EdgeInsets.only(left: 3.w),
        padding: EdgeInsets.only(left: 2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(ic, color: Colors.black, size: 5.w),
        ),
      ),
    );
  }
}
