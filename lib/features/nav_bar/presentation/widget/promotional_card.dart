import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class PromotionalCard extends StatelessWidget {
  final VoidCallback? onPlaceOrderTap;
  final String? title;
  final String? buttonText;

  const PromotionalCard({
    super.key,
    this.onPlaceOrderTap,
    this.title,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: context.responsiveContainerHeight * 1.8,
      ),
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding / 2),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.authBackground),
          alignment: Alignment.bottomCenter,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withValues(alpha: 0.8),
            BlendMode.srcIn,
          ),
        ),
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCharacterIllustration(),

            SizedBox(width: context.responsivePadding),

            Expanded(child: _buildContentSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterIllustration() {
    return CustomSvgImage(
      assetName: AppAssets.authLoginBackground,
      width: 80,
      height: 80,
    );
  }

  Widget _buildContentSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            title ?? "free_delivery_title".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: 12),

        Flexible(child: _buildPlaceOrderButton()),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return GestureDetector(
      onTap: onPlaceOrderTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          buttonText ?? "place_order".tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
