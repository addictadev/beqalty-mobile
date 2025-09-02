import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/features/rewards/business/models/reward_offer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OfferListItem extends StatelessWidget {
  final RewardOffer offer;
  final VoidCallback? onGetPressed;

  const OfferListItem({super.key, required this.offer, this.onGetPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin * 0.5,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: context.responsiveIconSize * 2.5,
            height: context.responsiveIconSize * 2.5,
            decoration: BoxDecoration(
              color: AppColors.overlayGray,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius,
              ),
            ),
            child: Icon(
              _getIconForOffer(offer.iconPath),
              color: AppColors.warning,
              size: context.responsiveIconSize * 1.5,
            ),
          ),

          SizedBox(width: context.responsiveMargin * 1.5),

          // Offer details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${offer.pointsRequired} ${'points'.tr()}',
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  offer.description,
                  style: TextStyles.textViewMedium16.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.responsiveMargin),

          // Get button
          GestureDetector(
            onTap: onGetPressed,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding * 1.5,
                vertical: context.responsiveMargin,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius * 2,
                ),
              ),
              child: Text(
                'get'.tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForOffer(String iconPath) {
    // Map icon paths to actual icons
    switch (iconPath.toLowerCase()) {
      case 'apple':
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'meat':
        return Icons.restaurant;
      case 'bread':
        return Icons.bakery_dining;
      case 'snacks':
        return Icons.cake;
      case 'milk':
        return Icons.local_drink;
      default:
        return Icons.card_giftcard;
    }
  }
}
