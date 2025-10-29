import 'package:baqalty/core/images_preview/app_assets.dart';
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
import '../../features/search/data/models/search_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductCard extends StatelessWidget {
  final SearchProductModel product;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToProductDetails(context),
      child: Container(
        height: height,
        margin: margin ?? EdgeInsets.only(left: 3.w),
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
              flex: 5,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.homeGradientWhite,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.w),
                    child: CachedNetworkImage(
                      imageUrl: product.baseImage,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: AppColors.homeGradientWhite,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(AppAssets.appIcon,width: 15.w,height: 18.w,color: AppColors.textSecondary,),
                    ),
                  ),
                ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 3,
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
                  Text(
                    product.parentCategory.name,
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${product.finalPrice} ${"egp".tr()}',
                    style: TextStyles.textViewBold16.copyWith(
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
          child: ProductDetailsScreen(productId: product.id),
        ),
      ),
    );
  }
}
