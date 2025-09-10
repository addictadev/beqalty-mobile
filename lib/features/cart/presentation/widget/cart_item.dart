import 'package:baqalty/core/navigation_services/navigation_manager.dart' show NavigationManager;
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CartItem extends StatelessWidget {
  final String productName;
  final String category;
  final String productImage;
  final double price;
  final int quantity;
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
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: ()=>NavigationManager.navigateTo(ProductDetailsScreen(productName: productName, productImage: productImage, productPrice: price, productCategory: category)),
      child: 
    Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
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

          SizedBox(width: context.responsiveMargin),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName.tr(),
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.responsiveMargin * 0.3),
                Text(
                  category.tr(),
                  style: TextStyles.textViewRegular12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  "${price.toStringAsFixed(2)} ${"egp".tr()}",
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.responsiveMargin),

          // Quantity Controls
          Row(
            children: [
              // Decrease Button
              GestureDetector(
                onTap: quantity == 1 ? onRemove : onDecrease,
                child: Container(
                  width: context.responsiveIconSize * 1.5,
                  height: context.responsiveIconSize * 1.5,
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
                  horizontal: context.responsivePadding * 1.2,
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
                  width: context.responsiveIconSize * 1.5,
                  height: context.responsiveIconSize * 1.5,
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
    ));
  }
}
