import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/features/saved_carts/business/models/saved_cart_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SavedCartCard extends StatelessWidget {
  final SavedCartModel savedCart;
  final VoidCallback? onCartDetails;
  final VoidCallback? onOrderAgain;

  const SavedCartCard({
    super.key,
    required this.savedCart,
    this.onCartDetails,
    this.onOrderAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left Section - Cart Icon and Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart Icon
                    Container(
                      width: context.responsiveIconSize * 2,
                      height: context.responsiveIconSize * 2,
                      padding: EdgeInsets.all(context.responsivePadding * 0.8),
                      decoration: BoxDecoration(
                        color: AppColors.borderLight.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius,
                        ),
                      ),
                      child: CustomSvgImage(
                        assetName: AppAssets.shoppingBag,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: context.responsiveMargin),

                    // Cart Name
                    Text(
                      savedCart.name,
                      style: TextStyles.textViewBold16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: context.responsiveMargin * 0.5),

                    // Item Count
                    Text(
                      "${savedCart.itemCount} ${savedCart.itemCount == 1 ? 'item' : 'items'}",
                      style: TextStyles.textViewRegular14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Section - Action Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Cart Details Button
                  GestureDetector(
                    onTap: onCartDetails,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsivePadding * 1.2,
                        vertical: context.responsiveMargin * 1.2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
                      ),
                      child: Text(
                        "cart_details".tr(),
                        style: TextStyles.textViewMedium14.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: context.responsiveMargin),

                  // Order Again Button
                  GestureDetector(
                    onTap: onOrderAgain,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsivePadding * 1.2,
                        vertical: context.responsiveMargin * 1.2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
                      ),
                      child: Text(
                        "order_again".tr(),
                        style: TextStyles.textViewMedium14.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
