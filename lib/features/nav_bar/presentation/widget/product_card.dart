import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productImage;
  final double currentPrice;
  final double? originalPrice;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.productName,
    required this.productImage,
    required this.currentPrice,
    this.originalPrice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.responsiveWidth * 0.75,
        padding: EdgeInsets.all(context.responsivePadding * 0.5),
        margin: EdgeInsets.only(right: context.responsiveMargin * 0.5),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 1.5,
          ),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image - Left side
            Container(
              width: context.responsiveWidth * 0.2,
              height: context.responsiveWidth * 0.19,
              padding: EdgeInsets.all(context.responsivePadding * 0.2),
              decoration: BoxDecoration(
                color: AppColors.borderLight.withValues(alpha: .4),
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
                child: Image.asset(
                  width: context.responsiveWidth * 0.3,
                  height: context.responsiveWidth * 0.3,
                  productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.scaffoldBackground,
                      child: Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: context.responsiveIconSize,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: context.responsiveMargin * 1.5),

            // Product Information - Right side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: TextStyles.textViewMedium14.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: context.responsiveMargin * 0.8),

                  // Price Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${currentPrice.toStringAsFixed(2)} ${"egp".tr()}",
                        style: TextStyles.textViewBold16.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (originalPrice != null) ...[
                        SizedBox(width: context.responsiveMargin * 0.8),
                        Text(
                          "${originalPrice!.toStringAsFixed(2)} ${"egp".tr()}",
                          style: TextStyles.textViewRegular14.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
