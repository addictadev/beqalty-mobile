import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SavedCartItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SavedCartItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.responsiveContainerHeight * 0.7,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shopping Bag Icon
            Container(
              width: context.responsiveIconSize * 1.8,
              height: context.responsiveIconSize * 1.8,
              padding: EdgeInsets.all(context.responsivePadding * 0.8),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
              ),
              child: CustomSvgImage(
                assetName: AppAssets.shoppingBag,

                color: AppColors.black,
              ),
            ),

            SizedBox(height: context.responsiveMargin),

            // Title
            Text(
              title.tr(),
              style: TextStyles.textViewMedium14.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
