import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class CartItem extends StatelessWidget {
  final String productName;
  final String category;
  final String productImage;
  final double price;
  final int quantity;
  final bool isAvailable;
  final String? statusMessage;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartItem({
    super.key,
    required this.productName,
    required this.category,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.isAvailable = true,
    this.statusMessage,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: context.responsiveMargin),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isAvailable ? AppColors.white : AppColors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 1.5,
          ),
          border: isAvailable ? null : Border.all(
            color: AppColors.error.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isAvailable ? AppColors.shadowLight : AppColors.error.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: context.responsiveWidth * 0.22,
              height: context.responsiveWidth * 0.22,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: productImage,
                      fit: BoxFit.cover,
                      color: isAvailable ? null : Colors.grey,
                      colorBlendMode: isAvailable ? null : BlendMode.saturation,
                      placeholder: (context, url) => Container(
                        color: AppColors.scaffoldBackground,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
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
                    if (!isAvailable)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Icon(
                            Iconsax.close_circle,
                            color: AppColors.error,
                            size: context.responsiveIconSize * 1.2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyles.textViewBold16.copyWith(
                      color: isAvailable ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isAvailable) ...[
                    SizedBox(height: context.responsiveMargin * 0.3),
                    Text(
                      statusMessage ?? "product_no_longer_available".tr(),
                      style: TextStyles.textViewRegular12.copyWith(
                        color: AppColors.error,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [SizedBox(height: context.responsiveMargin * .9),
                  Text(
                    category,
                    style: TextStyles.textViewRegular12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.responsiveMargin * 0.8),
                  Text(
                    "${price.toStringAsFixed(2)} ${"egp".tr()}",
                    style: TextStyles.textViewBold14.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp

                    ),
                  ),],),
                          SizedBox(width: context.responsiveMargin),

            // Quantity Controls or Remove Button
            if (!isAvailable)
              // Remove Button for unavailable items
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsivePadding,
                    vertical: context.responsiveMargin * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 0.8,
                    ),
                  ),
                  child: Text(
                    "remove_from_cart".tr(),
                    style: TextStyles.textViewRegular12.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
            else
              // Normal Quantity Controls
              Row(
                children: [
                  // Decrease Button
                  GestureDetector(
                    onTap: quantity == 1 ? onRemove : onDecrease,
                    child: Container(
                      width: context.responsiveIconSize * 1.2,
                      height: context.responsiveIconSize * 1.2,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius * 0.8,
                        ),
                        border: Border.all(
                          color: quantity == 1
                              ? AppColors.error
                              : AppColors.textPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        quantity == 1 ? Iconsax.trash : Icons.remove,
                        color: quantity == 1
                            ? AppColors.error
                            : AppColors.textPrimary,
                        size: context.responsiveIconSize * 0.7,
                      ),
                    ),
                  ),

                  // Quantity Display
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsivePadding * .6,
                      vertical: context.responsiveMargin * 0.5,
                    ),
                    child: Text(
                      quantity.toString(),
                      style: TextStyles.textViewBold16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Increase Button
                  GestureDetector(
                    onTap: onIncrease,
                    child: Container(
                      width: context.responsiveIconSize * 1.2,
                      height: context.responsiveIconSize * 1.2,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius * 0.8,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: context.responsiveIconSize * 0.7,
                      ),
                    ),
                  ),
                ],
              ),
        
                  ],
                ),
                  
                ],
              ),
            ),

      
          ],
        ),
    );
  }
}
