import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/checkout/presentation/view/checkout_screen.dart';
import 'package:baqalty/features/checkout/business/cubit/checkout_cubit.dart';
import 'package:baqalty/features/checkout/data/services/checkout_service.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class OrderSummary extends StatelessWidget {
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final int cartId;
  final bool isSharedCart;
  

  const OrderSummary({
    super.key,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.cartId, this.isSharedCart = false,
  });

  void _handleCheckout(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
              SizedBox(height: 16),
              Text(
                "processing_checkout".tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Create checkout cubit and call API
      final checkoutCubit = CheckoutCubit(ServiceLocator.get<CheckoutService>());
      await checkoutCubit.checkout(cartId: cartId);
      
      // Check if context is still mounted
      if (!context.mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Navigate to checkout screen with loaded data
      NavigationManager.navigateTo(
        BlocProvider.value(
          value: checkoutCubit,
          child: CheckoutScreen(cartId: cartId),
        ),
      );
    } catch (e) {
      // Check if context is still mounted
      if (!context.mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("checkout_error_message".tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        image: DecorationImage(
          image: AssetImage(AppAssets.promotionalCard),
          colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.color),
          fit: BoxFit.cover,
        ),
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
          // SizedBox(height: context.responsiveMargin),
          // _buildSummaryRow(
          //   context,
          //   label: "discount",
          //   value: -discount,
          //   isTotal: false,
          //   isDiscount: true,
          // ),
          SizedBox(height: context.responsiveMargin * 1.5),
          _buildSummaryRow(
            context,
            label: "total",
            value: total,
            isTotal: true,
          ),
          SizedBox(height: context.responsiveMargin * 1.5),
        if (!isSharedCart)
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: context.responsivePadding * 2,
            ),
            child: PrimaryButton(
              height: 6.h,
              text: "checkout".tr(),
              onPressed: () {
                _handleCheckout(context);
              },
              color: AppColors.white,
              textStyle: TextStyles.textViewBold16.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
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
