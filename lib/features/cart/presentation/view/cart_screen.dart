import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Shopping Cart",
                style: TextStyles.textViewBold24.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Empty cart state
              Expanded(
                child: Center(
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
                      SizedBox(height: context.responsiveMargin * 2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsivePadding * 2,
                          vertical: context.responsiveMargin,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            context.responsiveBorderRadius,
                          ),
                        ),
                        child: Text(
                          "Start Shopping",
                          style: TextStyles.textViewMedium14.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
