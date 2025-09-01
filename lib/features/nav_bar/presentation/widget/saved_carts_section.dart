import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'saved_cart_item.dart';

class SavedCartsSection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final VoidCallback? onCartTap;

  const SavedCartsSection({super.key, this.onViewAllTap, this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "saved_carts".tr(),
                style: TextStyles.textViewBold16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAllTap,
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: context.responsiveIconSize * 1.2,
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveMargin * 1.5),

          // Saved Cart Items
          SizedBox(
            height: context.responsiveContainerHeight * 0.8,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                SavedCartItem(
                  title: "breakfast_list",
                  onTap: () {
                    onCartTap?.call();
                  },
                ),
                SavedCartItem(
                  title: "weekend",
                  onTap: () {
                    onCartTap?.call();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: context.responsiveMargin * 1.5),
        ],
      ),
    );
  }
}
