import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:baqalty/features/cart/data/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'product_card.dart';

class SpecialOffersSection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final List<DiscountedProductModel> discountProducts;

  const SpecialOffersSection({
    super.key,
    this.onViewAllTap,
    required this.discountProducts,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProductsList(context);
  }

  Widget _buildProductsList(BuildContext context) {
    return SizedBox(
      height: context.responsiveContainerHeight * 0.55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: discountProducts.length,
        itemBuilder: (context, index) {
          final product = discountProducts[index];
          return ProductCard(
            productName: product.name,
            productImage: product.baseImage,
            currentPrice: double.parse(product.finalPrice),
            originalPrice: double.parse(product.basePrice),
            onTap: () {
              NavigationManager.navigateTo(
                MultiBlocProvider(
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
              );
            },
          );
        },
      ),
    );
  }
}

class ProductData {
  final String name;
  final String image;
  final double currentPrice;
  final double? originalPrice;

  const ProductData({
    required this.name,
    required this.image,
    required this.currentPrice,
    this.originalPrice,
  });
}
