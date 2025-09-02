import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/features/rewards/business/models/reward_history.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HistoryListItem extends StatelessWidget {
  final RewardHistory history;
  final VoidCallback? onTap;

  const HistoryListItem({super.key, required this.history, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEarned = history.type == TransactionType.earned;
    final pointsColor = isEarned ? AppColors.success : AppColors.error;
    final pointsPrefix = isEarned ? '+' : '-';

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                _getIconForHistory(history.iconPath),
                color: _getIconBackgroundColor(history.iconPath),
                size: context.responsiveIconSize * 1.5,
              ),
            ),

            SizedBox(width: context.responsiveMargin * 1.5),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.description,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.responsiveMargin * 0.5),
                  Text(
                    _formatDate(history.date),
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            Text(
              '$pointsPrefix${history.points} ${'points'.tr()}',
              style: TextStyles.textViewMedium16.copyWith(
                color: pointsColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForHistory(String iconPath) {
    switch (iconPath.toLowerCase()) {
      case 'gift':
      case 'earned':
        return Icons.card_giftcard;
      case 'apple':
      case 'fruits':
        return Icons.apple;
      case 'chicken':
      case 'meat':
        return Icons.restaurant;
      case 'vegetables':
        return Icons.eco;
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

  Color _getIconBackgroundColor(String iconPath) {
    switch (iconPath.toLowerCase()) {
      case 'gift':
      case 'earned':
        return AppColors.success;
      case 'apple':
      case 'fruits':
        return AppColors.warning;
      case 'chicken':
      case 'meat':
        return AppColors.error;
      case 'vegetables':
        return AppColors.success;
      case 'bread':
        return AppColors.warning;
      case 'snacks':
        return AppColors.info;
      case 'milk':
        return AppColors.primaryLight;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
