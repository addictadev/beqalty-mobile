import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:sizer/sizer.dart';

class ProfileMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProfileMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(bottom: context.responsivePadding),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.white,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: context.responsiveIconSize * 1.8,
                  height: context.responsiveIconSize * 1.8,
                  decoration: BoxDecoration(
                    color: AppColors.bgProfile,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 0.8,
                    ),
                  ),
                  padding: EdgeInsets.all(2.5.w),

                  child: CustomSvgImage(
                    assetName: iconPath,
                    width: context.responsiveIconSize * 0.1,
                    height: context.responsiveIconSize * 0.1,
                  ),
                ),

                SizedBox(width: context.responsiveMargin * 1.8),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: FontSizes.s16,
                    ),
                  ),
                ),

                // Navigation arrow
                Icon(
                  Icons.chevron_right,
                  color: AppColors.borderDark,
                  size: context.responsiveIconSize * 1.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
