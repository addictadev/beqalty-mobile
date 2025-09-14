import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/features/saved_carts/business/models/saved_item_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class SavedItemCard extends StatelessWidget {
  final SavedItemModel savedItem;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const SavedItemCard({
    super.key,
    required this.savedItem,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
        boxShadow: [
          // BoxShadow(
          //   color: AppColors.shadowLight,
          //   blurRadius: 8,
          //   offset: const Offset(0, 2),
          // ),
        ],
      ),
      child: Material(
        // color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Row(
              children: [
                // Product Image
                _buildProductImage(context),
                
                SizedBox(width: context.responsiveMargin),
                
                // Product Details
                Expanded(
                  child: _buildProductDetails(context),
                ),
                
                // Remove Button
                _buildRemoveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: context.responsiveIconSize * 4,
      height: context.responsiveIconSize * 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.2),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
    
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.2),
        child: Image.asset(
          savedItem.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.borderLight,
              child: Icon(
                Iconsax.image,
                color: AppColors.textSecondary,
                size: context.responsiveIconSize * 1.5,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Product Name
        Text(
          savedItem.name,
          style: TextStyles.textViewBold16.copyWith(
            color: AppColors.textPrimary,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: context.responsiveMargin * 0.8),
        
        // Category
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveMargin * 0.8,
            vertical: context.responsiveMargin * 0.3,
          ),
          decoration: BoxDecoration(
            color: AppColors.borderLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 0.8),
          ),
          child: Text(
            savedItem.category,
            style: TextStyles.textViewRegular12.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        SizedBox(height: context.responsiveMargin * 0.8),
        
        // Price
        Text(
          savedItem.formattedPrice,
          style: TextStyles.textViewSemiBold16.copyWith(
            color: AppColors.primary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        width: context.responsiveIconSize * 2,
        height: context.responsiveIconSize * 2,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Iconsax.heart,
          color: AppColors.error,
          size: context.responsiveIconSize * 1.0,
        ),
      ),
    );
  }
}
