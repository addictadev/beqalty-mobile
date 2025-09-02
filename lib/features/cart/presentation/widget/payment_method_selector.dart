import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final List<PaymentMethodOption> options;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "payment_method".tr(),
          style: TextStyles.textViewBold16.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.responsiveMargin * 2),

        ...options.map(
          (option) => _buildPaymentOption(
            context,
            option: option,
            isSelected: selectedMethod == option.value,
            onChanged: onMethodChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethodOption option,
    required bool isSelected,
    required ValueChanged<String> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(option.value),
      child: Container(
        margin: EdgeInsets.only(bottom: context.responsiveMargin),
        padding: EdgeInsets.symmetric(
          horizontal: context.responsivePadding,
          vertical: context.responsiveMargin,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
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
                assetName: option.icon,
                color: AppColors.primary,
                width: context.responsiveIconSize * 0.8,
                height: context.responsiveIconSize * 0.8,
              ),
            ),
            SizedBox(width: context.responsiveMargin),
            Expanded(
              child: Text(
                option.title.tr(),
                style: TextStyles.textViewRegular14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Radio<String>(
              value: option.value,
              groupValue: selectedMethod,
              onChanged: (value) => onChanged(value!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodOption {
  final String icon;
  final String title;
  final String value;

  const PaymentMethodOption({
    required this.icon,
    required this.title,
    required this.value,
  });
}
