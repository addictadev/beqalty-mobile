import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/styles/styles.dart';
import '../../data/models/subcategory_products_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HorizontalCategorySection extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;
  final VoidCallback? onViewAll;
  final VoidCallback? onProductTap;

  const HorizontalCategorySection({
    super.key,
    required this.categoryName,
    required this.products,
    this.onViewAll,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header with view all button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Text(
                categoryName,
                style: TextStyles.textViewMedium18.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    "view_all".tr(),
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Horizontal products list
        SizedBox(
          height: 25.h,
          child: products.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      width: 45.w,
                      margin: EdgeInsets.only(right: 2.w),
                      child: _buildProductCard(context, product),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: onProductTap ?? () {
        // Navigate to product details
        // You can implement navigation here
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.homeGradientWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3.w),
                    topRight: Radius.circular(3.w),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3.w),
                    topRight: Radius.circular(3.w),
                  ),
                  child: 
                  CustomCachedImage(
                    imageUrl: product.baseImage,
                    fit: BoxFit.contain,
               
                  ),
             
                ),
              ),
            ),
            
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyles.textViewMedium12.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    
                    // Price
                    if (product.hasDiscount) ...[
                      Text(
                        '${product.finalPrice} ${"egp".tr()}',
                        style: TextStyles.textViewBold12.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${product.basePrice} ${"egp".tr()}',
                        style: TextStyles.textViewRegular8.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ] else
                      Text(
                        '${product.finalPrice} ${"egp".tr()}',
                        style: TextStyles.textViewBold12.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 10.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 2.h),
          Text(
            "no_products_available".tr(),
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
