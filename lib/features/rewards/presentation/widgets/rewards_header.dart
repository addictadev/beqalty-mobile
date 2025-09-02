import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class RewardsHeader extends StatelessWidget {
  final int earnedPoints;
  final VoidCallback? onBackPressed;

  const RewardsHeader({
    super.key,
    required this.earnedPoints,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        child: Column(
          children: [
            // Status bar and back button row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
                vertical: context.responsiveMargin,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(context.responsivePadding * 0.6),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primary,
                        size: context.responsiveIconSize * 1.5,
                      ),
                    ),
                  ),
                  // Status bar icons (time, signal, battery)
                  Row(
                    children: [
                      Text(
                        '9:41',
                        style: TextStyles.textViewMedium14.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: context.responsiveMargin),
                      Icon(
                        Icons.signal_cellular_4_bar,
                        color: AppColors.white,
                        size: context.responsiveIconSize,
                      ),
                      SizedBox(width: context.responsiveMargin),
                      Icon(
                        Icons.battery_full,
                        color: AppColors.white,
                        size: context.responsiveIconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Abstract colorful shapes background
            Stack(
              children: [
                // Abstract shapes
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: -30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.warning.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 40,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(context.responsivePadding * 1.5),
                  child: Column(
                    children: [
                      // Title with gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.success, AppColors.warning],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsivePadding,
                          vertical: context.responsiveMargin,
                        ),
                        child: Text(
                          'my_rewards_points'.tr(),
                          style: TextStyles.textViewBold20.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: context.responsiveMargin * 2),

                      // Earned points label
                      Text(
                        'earned_points'.tr(),
                        style: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.white,
                        ),
                      ),

                      SizedBox(height: context.responsiveMargin),

                      // Points balance
                      Text(
                        earnedPoints.toString(),
                        style: TextStyles.textViewBold27.copyWith(
                          color: AppColors.white,
                          fontSize: 32.sp,
                        ),
                      ),

                      SizedBox(height: context.responsiveMargin * 3),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
