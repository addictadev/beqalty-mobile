import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

import 'package:baqalty/core/widgets/primary_button.dart';
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
          return Column(
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
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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

              // Cart Items
              Expanded(child: _buildCartItemsList(context, state)),

              // Order Summary
              _buildOrderSummary(context, state),

              // Checkout Button
              _buildCheckoutButton(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShareCartSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people,
            color: AppColors.white,
            size: context.responsiveIconSize,
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

  Widget _buildCartItemsList(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CartLoaded) {
      if (state.cartItems.isEmpty) {
        return _buildEmptyCartState(context);
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        itemCount: state.cartItems.length,
        itemBuilder: (context, index) {
          final item = state.cartItems[index];
          return CartItem(
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
          );
        },
      );
    }

    return _buildEmptyCartState(context);
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

  Widget _buildCheckoutButton(BuildContext context, CartState state) {
    if (state is! CartLoaded || state.cartItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(context.responsivePadding),
      child: PrimaryButton(
        text: "checkout".tr(),
        onPressed: () {
          // TODO: Navigate to checkout
          debugPrint('Checkout pressed');
        },
        color: AppColors.white,
        textStyle: TextStyles.textViewBold16.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
