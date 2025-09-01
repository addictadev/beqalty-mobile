import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PointsCard extends StatelessWidget {
  final int points;
  final VoidCallback? onRedeemTap;

  const PointsCard({super.key, required this.points, this.onRedeemTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "your_points".tr(),
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              // Points Icon and Display
              Expanded(
                child: Row(
                  children: [
                    // Points Icon
                    Container(
                      width: context.responsiveIconSize * 1.2,
                      height: context.responsiveIconSize * 1.2,
                      padding: EdgeInsets.all(context.responsivePadding / 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomSvgImage(
                        assetName: AppAssets.padgeIcon,
                        width: context.responsiveIconSize * 0.8,
                        height: context.responsiveIconSize * 0.8,
                      ),
                    ),

                    SizedBox(width: context.responsiveMargin),

                    // Points Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "1,250",
                                style: TextStyles.textViewBold20.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(width: context.responsiveMargin * 0.5),
                              Text(
                                "points".tr(),
                                style: TextStyles.textViewRegular16.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: context.responsiveMargin),

              // Redeem Button
              _buildRedeemButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemButton(BuildContext context) {
    return GestureDetector(
      onTap: onRedeemTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsivePadding * 1.2,
          vertical: context.responsiveMargin * 1.5,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 1.5,
          ),
        ),
        child: Text(
          "redeem".tr(),
          style: TextStyles.textViewMedium14.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
