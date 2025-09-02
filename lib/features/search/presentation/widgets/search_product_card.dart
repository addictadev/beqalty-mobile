import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class SearchProductCard extends StatelessWidget {
  final String productName;
  final String productCategory;
  final double productPrice;
  final String productImage;
  final VoidCallback? onTap;

  const SearchProductCard({
    super.key,
    required this.productName,
    required this.productCategory,
    required this.productPrice,
    required this.productImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppColors.white,
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
            // Product Image
            Container(
              width: context.responsiveWidth * 0.25,
              height: context.responsiveWidth * 0.25,
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

            // Product Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: context.responsiveMargin * 0.5),

                  // Product Category
                  Text(
                    productCategory,
                    style: TextStyles.textViewRegular12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: context.responsiveMargin),

                  // Price
                  Text(
                    "${productPrice.toStringAsFixed(2)} ${"egp".tr()}",
                    style: TextStyles.textViewBold18.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
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
