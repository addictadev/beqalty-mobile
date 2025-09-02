import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CardSelector extends StatelessWidget {
  final String selectedCard;
  final ValueChanged<String> onCardChanged;
  final List<CardOption> cards;
  final VoidCallback onAddNewCard;

  const CardSelector({
    super.key,
    required this.selectedCard,
    required this.onCardChanged,
    required this.cards,
    required this.onAddNewCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "cards".tr(),
          style: TextStyles.textViewBold16.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.responsiveMargin * 2),

        ...cards.map(
          (card) => _buildCardOption(
            context,
            card: card,
            isSelected: selectedCard == card.id,
            onTap: () => onCardChanged(card.id),
          ),
        ),

        SizedBox(height: context.responsiveMargin),
        GestureDetector(
          onTap: onAddNewCard,
          child: Text(
            "add_new_card".tr(),
            style: TextStyles.textViewBold16.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildCardOption(
    BuildContext context, {
    required CardOption card,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.responsiveMargin),
        padding: EdgeInsets.all(context.responsivePadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.responsivePadding * 0.5),
              decoration: BoxDecoration(
                color: AppColors.overlayGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomSvgImage(
                assetName: card.icon,
                width: context.responsiveIconSize * 0.8,
                height: context.responsiveIconSize * 0.8,
              ),
            ),

            SizedBox(width: context.responsiveMargin),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.title,
                    style: TextStyles.textViewBold14.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "${"card_number".tr()} ${card.maskedNumber}",
                    style: TextStyles.textViewRegular12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: card.id,
              groupValue: selectedCard,
              onChanged: (value) => onCardChanged(value!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class CardOption {
  final String id;
  final String icon;
  final String title;
  final String maskedNumber;
  final Color brandColor;

  const CardOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.maskedNumber,
    required this.brandColor,
  });
}
