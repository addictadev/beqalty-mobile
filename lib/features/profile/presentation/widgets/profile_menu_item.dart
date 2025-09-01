import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';

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
                  width: context.responsiveIconSize * 1.9,
                  height: context.responsiveIconSize * 1.9,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 0.8,
                    ),
                  ),
                  child: CustomSvgImage(
                    assetName: iconPath,
                    color: iconColor ?? AppColors.primary,
                    width: context.responsiveIconSize * 0.8,
                    height: context.responsiveIconSize * 0.8,
                  ),
                ),

                SizedBox(width: context.responsiveMargin * 1.5),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
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
