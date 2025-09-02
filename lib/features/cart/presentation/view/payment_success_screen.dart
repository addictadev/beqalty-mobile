import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/dashed_divider.dart';

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
        horizontal: context.responsivePadding * 1.5,
        vertical: context.responsiveMargin * 1.5,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<NavBarCubit>().changeTab(0);
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.white, size: 24),
            ),
          ),
          SizedBox(width: context.responsiveMargin * 1.5),
          Text(
            "payment_success".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding * 2.5,
        vertical: context.responsivePadding * 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success icon with proper sizing and glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 60,
                weight: 900,
              ),
            ),
          ),

          SizedBox(height: context.responsiveMargin * 4),

          // Success title
          Text(
            "payment_success".tr(),
            style: TextStyles.textViewBold24.copyWith(
              color: AppColors.textPrimary,
              fontSize: 28,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin * 3),

          // Success description
          Text(
            "payment_success_description".tr(),
            style: TextStyles.textViewRegular16.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),

          SizedBox(height: context.responsiveMargin * 4),

          // Payment amount section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsivePadding * 2,
              vertical: context.responsiveMargin * 1.5,
            ),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "total_payment".tr(),
                  style: TextStyles.textViewRegular14.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.8),
                Text(
                  "215 EGP",
                  style: TextStyles.textViewBold24.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.responsiveMargin * 4),

          // Dashed divider
          DashedDivider(
            color: AppColors.borderLight,
            height: 1.5,
            dashWidth: 6,
            dashSpace: 4,
            margin: EdgeInsets.symmetric(
              vertical: context.responsiveMargin * 2,
            ),
          ),

          SizedBox(height: context.responsiveMargin * 3),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Track Order Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                HapticFeedback.mediumImpact();
                // TODO: Navigate to order tracking
              },
              child: Center(
                child: Text(
                  "track_your_order".tr(),
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: context.responsiveMargin * 2.5),

        // Keep Shopping Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                HapticFeedback.lightImpact();
                context.read<NavBarCubit>().changeTab(0);
              },
              child: Center(
                child: Text(
                  "keep_shopping".tr(),
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.primary,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
