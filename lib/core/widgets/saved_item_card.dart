import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax/iconsax.dart';

class SavedItemCard extends StatelessWidget {
  final String productName;
  final String productCategory;
  final double productPrice;
  final String productImage;
  final String? currency;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final bool showFavoriteButton;
  final bool showAddToCartButton;
  final bool showCategory;
  final bool showPrice;
  final double? imageWidth;
  final double? imageHeight;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const SavedItemCard({
    super.key,
    required this.productName,
    required this.productCategory,
    required this.productPrice,
    required this.productImage,
    this.currency,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
    this.isFavorite = false,
    this.showFavoriteButton = true,
    this.showAddToCartButton = false,
    this.showCategory = true,
    this.showPrice = true,
    this.imageWidth,
    this.imageHeight,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 0.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(context),

              SizedBox(width: context.responsiveMargin * 1.5),

              // Product Information
              Expanded(child: _buildProductInfo(context)),

              // // Action Buttons
              if (showFavoriteButton )
                _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final width = imageWidth ?? context.responsiveWidth * 0.25;
    final height = imageHeight ?? context.responsiveWidth * 0.25;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        child: Image.network(
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
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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

        if (showCategory) ...[
          SizedBox(height: context.responsiveMargin * 0.5),

          // Product Category
          Text(
            productCategory,
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        if (showPrice) ...[
          SizedBox(height: context.responsiveMargin),

          // Price
          Text(
            "${productPrice.toStringAsFixed(2)} ${currency ?? "egp".tr()}",
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Favorite Button
        GestureDetector(
          onTap: onFavorite,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isFavorite ? AppColors.error.withOpacity(0.1) : AppColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            ),
            child: Icon(
              isFavorite ? Iconsax.heart5 : Iconsax.heart,
              color: isFavorite ? AppColors.error : AppColors.textSecondary,
              size: context.responsiveIconSize,
            ),
          ),
        ),
        
        if (showAddToCartButton) ...[
          SizedBox(height: 1.h),
          
          // Add to Cart Button
          GestureDetector(
            onTap: onAddToCart,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
              ),
              child: Icon(
                Iconsax.shopping_cart,
                color: AppColors.primary,
                size: context.responsiveIconSize,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
