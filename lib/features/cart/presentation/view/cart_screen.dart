import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../widget/cart_item.dart';
import '../widget/order_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: const CartScreenBody(),
    );
  }
}

class CartScreenBody extends StatelessWidget {
  const CartScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.responsiveMargin * 6),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsivePadding,
                    vertical: context.responsiveMargin,
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        width: context.responsiveIconSize * 1.5,
                        height: context.responsiveIconSize * 1.5,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.read<NavBarCubit>().changeTab(0);
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            color: AppColors.textPrimary,
                            size: context.responsiveIconSize,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),

                      // Title
                      Expanded(
                        child: Center(
                          child: Text(
                            "my_cart".tr(),
                            style: TextStyles.textViewBold18.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Bookmark with Plus Icon
                      GestureDetector(
                        onTap: () {
                          context.read<CartCubit>().toggleCartSave();
                        },
                        child: Container(
                          width: context.responsiveIconSize * 1.5,
                          height: context.responsiveIconSize * 1.5,
                          padding: EdgeInsets.all(
                            context.responsivePadding * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CustomSvgImage(
                            assetName: (state as CartLoaded).isCartSaved
                                ? AppAssets.savedIcon
                                : AppAssets.addSaveIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 2),

                // Share Cart Section
                _buildShareCartSection(context),

                // Cart Items Section
                _buildCartItemsSection(context, state),

                // Order Summary
                _buildOrderSummary(context, state),

                // Bottom spacing for safe area
                SizedBox(height: context.responsiveMargin * 4),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShareCartSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        children: [
          Container(
            width: context.responsiveIconSize * 1.2,
            height: context.responsiveIconSize * 1.2,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius * 0.5,
              ),
            ),
            child: Icon(
              Iconsax.people,
              color: AppColors.primary,
              size: context.responsiveIconSize * 0.8,
            ),
          ),
          SizedBox(width: context.responsiveMargin),
          Expanded(
            child: Text(
              "${"share_your_cart".tr()} - ${"share_cart_description".tr()}",
              style: TextStyles.textViewMedium14.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.white,
            size: context.responsiveIconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsSection(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return SizedBox(
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is CartLoaded) {
      if (state.cartItems.isEmpty) {
        return SizedBox(height: 300, child: _buildEmptyCartState(context));
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        child: Column(
          children: [
            ...state.cartItems.map(
              (item) => CartItem(
                productName: item.productName,
                category: item.category,
                productImage: item.productImage,
                price: item.price,
                quantity: item.quantity,
                onIncrease: () => context.read<CartCubit>().updateQuantity(
                  item.id,
                  item.quantity + 1,
                ),
                onDecrease: () => context.read<CartCubit>().updateQuantity(
                  item.id,
                  item.quantity - 1,
                ),
                onRemove: () => context.read<CartCubit>().removeItem(item.id),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(height: 300, child: _buildEmptyCartState(context));
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: context.responsiveIconSize * 3,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "Your cart is empty",
            style: TextStyles.textViewMedium18.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "Add some items to get started",
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    if (state is! CartLoaded || state.cartItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return OrderSummary(
      subTotal: state.subTotal,
      deliveryFee: state.deliveryFee,
      discount: state.discount,
      total: state.total,
    );
  }
}
