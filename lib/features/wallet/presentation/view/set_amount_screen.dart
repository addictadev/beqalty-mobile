import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class SetAmountScreen extends StatefulWidget {
  const SetAmountScreen({super.key});

  @override
  State<SetAmountScreen> createState() => _SetAmountScreenState();
}

class _SetAmountScreenState extends State<SetAmountScreen> {
  double _amount = 0.0;
  String _selectedCard = 'paypal';

  final List<CardOption> _cards = [
    CardOption(
      id: 'paypal',
      icon: AppAssets.paypalIcon,
      title: "paypal_card",
      maskedNumber: "XXX XXX XXX 8553",
      brandColor: const Color(0xFF0070BA),
    ),
    CardOption(
      id: 'mastercard1',
      icon: AppAssets.mastercardIcon,
      title: "mastercard",
      maskedNumber: "XXX XXX XXX 8553",
      brandColor: const Color(0xFFEB001B),
    ),
    CardOption(
      id: 'mastercard2',
      icon: AppAssets.mastercardIcon,
      title: "mastercard",
      maskedNumber: "XXX XXX XXX 8553",
      brandColor: const Color(0xFFEB001B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "",
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'set_amount'.tr(),
                      style: TextStyles.textViewBold18.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // Amount Input Section
                    _buildAmountSection(context),
                    SizedBox(height: 4.h),

                    // Payment Method Selection
                    _buildPaymentMethodSection(context),
                  ],
                ),
              ),

              // Confirm Deposit Button
              _buildConfirmButton(context),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding * 2),

      child: Column(
        children: [
          // Amount Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minus Button
              _buildAmountButton(
                context,
                icon: Icons.remove,
                onPressed: _decreaseAmount,
              ),
              SizedBox(width: 4.w),

              // Amount Display
              Container(
                width: 45.w,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderLight, width: 1),
                  ),
                ),
                child: Text(
                  _amount.toStringAsFixed(0),
                  style: TextStyles.textViewBold24.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: FontSizes.s24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 4.w),

              // Plus Button
              _buildAmountButton(
                context,
                icon: Icons.add,
                onPressed: _increaseAmount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: context.responsiveIconSize * 1.4,
        height: context.responsiveIconSize * 1.4,
        decoration: BoxDecoration(
          color: icon == Icons.remove ? Colors.transparent : AppColors.primary,
          border: Border.all(
            color: icon == Icons.remove ? Colors.grey : AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * .9,
          ),
        ),
        child: Icon(
          icon,
          color: icon == Icons.remove ? Colors.grey : AppColors.white,
          size: context.responsiveIconSize * 0.8,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          "select_payment_method".tr(),
          style: TextStyles.textViewBold16.copyWith(
            color: AppColors.textPrimary,
            fontSize: FontSizes.s16,
          ),
        ),
        SizedBox(height: 1.h),

        // Bank Cards Subtitle
        Text(
          "bank_cards".tr(),
          style: TextStyles.textViewMedium14.copyWith(
            color: AppColors.textSecondary,
            fontSize: FontSizes.s14,
          ),
        ),
        SizedBox(height: 2.h),

        // Card Options
        ..._cards.map(
          (card) => _buildCardOption(
            context,
            card: card,
            isSelected: _selectedCard == card.id,
            onTap: () => _selectCard(card.id),
          ),
        ),

        SizedBox(height: 1.h),

        // Add New Card Option
        GestureDetector(
          onTap: _addNewCard,
          child: Text(
            "add_new_card".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textPrimary,
              fontSize: FontSizes.s16,
            ),
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
            // Card Icon
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

            // Card Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "card_number".tr(),
                    style: TextStyles.textViewRegular12.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: FontSizes.s12,
                    ),
                  ),
                  Text(
                    card.maskedNumber,
                    style: TextStyles.textViewMedium14.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: FontSizes.s14,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Radio<String>(
              value: card.id,
              groupValue: _selectedCard,
              onChanged: (value) => _selectCard(value!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return PrimaryButton(
      text: "confirm_deposit".tr(),
      onPressed: _amount > 0 ? _confirmDeposit : null,
      color: AppColors.primary,
      textStyle: TextStyles.textViewMedium16.copyWith(
        color: AppColors.white,
        fontSize: FontSizes.s16,
        fontWeight: FontWeight.w600,
      ),
      borderRadius: 25,
      height: 56,
      width: double.infinity,
    );
  }

  void _increaseAmount() {
    setState(() {
      _amount += 10;
    });
  }

  void _decreaseAmount() {
    if (_amount > 0) {
      setState(() {
        _amount -= 10;
      });
    }
  }

  void _selectCard(String cardId) {
    setState(() {
      _selectedCard = cardId;
    });
  }

  void _addNewCard() {
    // TODO: Implement add new card functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add new card functionality coming soon'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _confirmDeposit() {
    // TODO: Implement deposit confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deposit of ${_amount.toStringAsFixed(0)} EGP confirmed'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back to wallet screen
    Navigator.of(context).pop();
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
