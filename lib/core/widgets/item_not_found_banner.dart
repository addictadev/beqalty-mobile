import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class ItemNotFoundBanner extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onReplacePressed;
  final bool showBanner;

  const ItemNotFoundBanner({
    super.key,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onReplacePressed,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBanner) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(
      
        vertical: context.responsiveMargin,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.primary, // Dark gray background
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Row(
        children: [
          // Icon with refresh symbol
     CustomSvgImage(assetName: AppAssets.replaceSvg, color: AppColors.white, width: 9.w, height: 9.w),
          SizedBox(width: 2.w),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "your_item_not_found".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: .5.h),
                Text(
                  subtitle ?? "please_replace_your_item".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          // Replace button
          if (onReplacePressed != null)
            
            
            ElevatedButton(
              onPressed: onReplacePressed,
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Light beige
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal:4.w,
                  vertical: 0,
                ),
              ),
              child: Text(
                buttonText ?? "replace_item".tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
