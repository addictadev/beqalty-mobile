import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? size;
  final IconData? icon;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.size,

    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ic = icon ?? Icons.arrow_back_ios;

    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 5.w,
        height: 5.w,
        margin: EdgeInsets.only(left: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,

          boxShadow: [
       
          ],
        ),
        child: Center(
          child: Icon(ic, color: Colors.black, size: 7.w),
        ),
      ),
    );
  }
}
