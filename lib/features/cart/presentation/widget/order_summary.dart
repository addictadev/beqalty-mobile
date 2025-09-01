import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderSummary extends StatelessWidget {
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double total;

  const OrderSummary({
    super.key,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            label: "sub_total",
            value: subTotal,
            isTotal: false,
          ),
          SizedBox(height: context.responsiveMargin),
          _buildSummaryRow(
            context,
            label: "delivery_fee",
            value: deliveryFee,
            isTotal: false,
          ),
          SizedBox(height: context.responsiveMargin),
          _buildSummaryRow(
            context,
            label: "discount",
            value: -discount,
            isTotal: false,
            isDiscount: true,
          ),
          SizedBox(height: context.responsiveMargin * 1.5),
          Container(height: 1, color: AppColors.white.withValues(alpha: 0.2)),
          SizedBox(height: context.responsiveMargin * 1.5),
          _buildSummaryRow(
            context,
            label: "total",
            value: total,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required double value,
    required bool isTotal,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr(),
          style:
              (isTotal
                      ? TextStyles.textViewBold18
                      : TextStyles.textViewRegular14)
                  .copyWith(color: AppColors.white),
        ),
        Text(
          "${value.toStringAsFixed(2)} ${"egp".tr()}",
          style:
              (isTotal
                      ? TextStyles.textViewBold18
                      : TextStyles.textViewRegular14)
                  .copyWith(
                    color: isDiscount ? AppColors.success : AppColors.white,
                  ),
        ),
      ],
    );
  }
}
