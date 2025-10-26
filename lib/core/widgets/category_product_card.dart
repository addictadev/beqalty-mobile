import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_colors.dart';
import '../utils/styles/styles.dart';
import '../di/service_locator.dart';
import '../../features/product_details/presentation/view/product_details_screen.dart';
import '../../features/product_details/data/services/product_details_service.dart';
import '../../features/product_details/business/cubit/product_details_cubit.dart';
import '../../features/cart/data/services/cart_service.dart';
import '../../features/cart/business/cubit/cart_cubit.dart';
import '../../features/categories/data/models/subcategory_products_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoryProductCard extends StatelessWidget {
  final dynamic product;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final String categoryName;
  final String? sharedCartId;
  const CategoryProductCard({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.onTap,
    required this.categoryName,
    this.sharedCartId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToProductDetails(context),
      child: Container(
        width: width ?? 45.w,
        height: height ?? 30.h,
        margin: margin,
        padding: padding ?? EdgeInsets.all(3.w),
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
            // Product Image Container
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.homeGradientWhite,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.w),
                    child: CustomCachedImage(
                      imageUrl: product.baseImage,
                      fit: BoxFit.contain,
                    ),  
                  ),
                ),
              ),
            ),
            // Product Info
           SizedBox(height: 0.5.h),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if(categoryName!="")  SizedBox(height: 0.5.h),
                 if(categoryName!="") Text(categoryName  , style: TextStyles.textViewRegular12.copyWith(color: AppColors.textSecondary),),
                  SizedBox(height: 0.5.h),
                  // Price with discount handling
                  if (product.hasDiscount) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(
                      '${product.finalPrice} ${"egp".tr()}',
                      style: TextStyles.textViewBold16.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${product.basePrice} ${"egp".tr()}',
                      style: TextStyles.textViewRegular12.copyWith(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),],)
                  ] else
                    Text(
                      '${product.finalPrice} ${"egp".tr()}',
                      style: TextStyles.textViewBold14.copyWith(
                        color: AppColors.textPrimary,
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

  void _navigateToProductDetails(BuildContext context) {
    Navigator.of(context).push(
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
          child: ProductDetailsScreen(
            productId: product.id,
            sharedCartId: sharedCartId,
          ),
        ),
      ),
    );
  }
}
