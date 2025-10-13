import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final String imageUrl;

  const CategoryCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          bottom: context.responsiveMargin,
          top: context.responsiveMargin,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CustomCachedImage(
                  imageUrl: imageUrl,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(height: 8),

            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
