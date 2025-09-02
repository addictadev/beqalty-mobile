import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/success_icon.dart';
import 'package:baqalty/core/widgets/dashed_divider.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;
  final String? orderId;

  const PaymentSuccessScreen({super.key, required this.amount, this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarCubit(),
      child: const PaymentSuccessScreenBody(),
    );
  }
}

class PaymentSuccessScreenBody extends StatefulWidget {
  const PaymentSuccessScreenBody({super.key});

  @override
  State<PaymentSuccessScreenBody> createState() =>
      _PaymentSuccessScreenBodyState();
}

class _PaymentSuccessScreenBodyState extends State<PaymentSuccessScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  const Spacer(),

                  // Success card
                  _buildSuccessCard(context),

                  const Spacer(),

                  // Action buttons
                  _buildActionButtons(context),

                  SizedBox(height: context.responsiveMargin * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<NavBarCubit>().changeTab(0);
            },
            child: Container(
              padding: EdgeInsets.all(context.responsivePadding * 0.5),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: context.responsiveIconSize,
              ),
            ),
          ),
          SizedBox(width: context.responsiveMargin),
          Text(
            "payment_success".tr(),
            style: TextStyles.textViewBold18.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsivePadding * 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success icon
          SuccessIcon(size: context.responsiveIconSize * 2.5),

          SizedBox(height: context.responsiveMargin * 3),

          // Success title
          Text(
            "payment_success".tr(),
            style: TextStyles.textViewBold24.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin * 2),

          // Success description
          Text(
            "payment_success_description".tr(),
            style: TextStyles.textViewRegular16.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin * 3),

          // Payment amount
          Column(
            children: [
              Text(
                "total_payment".tr(),
                style: TextStyles.textViewRegular14.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: context.responsiveMargin),
              Text(
                "215 EGP",
                style: TextStyles.textViewBold24.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveMargin * 3),

          // Dashed divider
          DashedDivider(
            color: AppColors.borderLight,
            margin: EdgeInsets.symmetric(
              vertical: context.responsiveMargin * 2,
            ),
          ),

          SizedBox(height: context.responsiveMargin * 2),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Track Order Button
        PrimaryButton(
          text: "track_your_order".tr(),
          onPressed: () {
            HapticFeedback.mediumImpact();
            // TODO: Navigate to order tracking
          },
          color: AppColors.primary,
          height: context.responsiveButtonHeight,
          borderRadius: context.responsiveBorderRadius,
          textStyle: TextStyles.textViewBold16.copyWith(color: AppColors.white),
        ),

        SizedBox(height: context.responsiveMargin * 2),

        // Keep Shopping Button
        PrimaryButton(
          text: "keep_shopping".tr(),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<NavBarCubit>().changeTab(0);
          },
          color: AppColors.white,
          height: context.responsiveButtonHeight,
          borderRadius: context.responsiveBorderRadius,
          textStyle: TextStyles.textViewBold16.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
