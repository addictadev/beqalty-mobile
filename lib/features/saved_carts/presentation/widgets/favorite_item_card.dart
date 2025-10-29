import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:baqalty/features/saved_carts/data/models/favorite_item_model.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:baqalty/features/cart/data/services/cart_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

/// Widget for displaying a favorite item card
class FavoriteItemCard extends StatelessWidget {
  final FavoriteItemModel favoriteItem;
  final VoidCallback? onRemove;

  const FavoriteItemCard({
    super.key,
    required this.favoriteItem,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProductDetails(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                color: AppColors.grey.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                child: CachedNetworkImage(
                  imageUrl: favoriteItem.baseImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.grey.withOpacity(0.1),
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.grey,
                      size: 6.w,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.grey.withOpacity(0.1),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey,
                      size: 6.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    favoriteItem.name,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  
                  // Subcategory Name
                  if (favoriteItem.subcategoryName.isNotEmpty)
                    Text(
                      favoriteItem.subcategoryName,
                      style: TextStyles.textViewRegular12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 0.5.h),
                  
                  // Price Row
                  Row(
                    children: [
                      // Final Price
                      Text(
                        '${favoriteItem.finalPrice} ${'egp'.tr()}',
                        style: TextStyles.textViewMedium14.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      
                      // Original Price (if different from final price)
                      if (favoriteItem.basePrice != favoriteItem.finalPrice)
                        Text(
                          '${favoriteItem.basePrice} ${'egp'.tr()}',
                          style: TextStyles.textViewRegular12.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  
                  // Quantity
                  if (favoriteItem.quantity > 0)
                    Text(
                      '${'quantity'.tr()}: ${favoriteItem.quantity}',
                      style: TextStyles.textViewRegular12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            
            // Remove Button
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                  ),
                  child: Icon(
                    Iconsax.heart5,
                    color: AppColors.error,
                    size: 5.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Navigates to product details screen
  void _navigateToProductDetails(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailsCubit>(
              create: (context) => ProductDetailsCubit(
                ServiceLocator.get<ProductDetailsService>(),
              ),
            ),
            BlocProvider<CartCubit>(
              create: (context) => CartCubit(ServiceLocator.get<CartService>()),
            ),
          ],
          child: ProductDetailsScreen(productId: favoriteItem.id),
        ),
      ),
    );
    // Note: The parent widget (SavedItemsScreen) will handle refreshing the list
  }
}
