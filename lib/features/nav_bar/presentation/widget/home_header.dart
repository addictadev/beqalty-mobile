import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final TextEditingController? searchController;
  final String? searchHint;

  const HomeHeader({
    super.key,
    this.onSearchTap,
    this.onNotificationTap,
    this.searchController,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.responsiveBorderRadius * 3),
          bottomRight: Radius.circular(context.responsiveBorderRadius * 3),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.9)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsivePadding,
            vertical: context.responsivePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGreetingSection(),

                  _buildNotificationIcon(context),
                ],
              ),

              SizedBox(height: context.responsiveContainerHeight / 5),

              _buildSearchBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "hello".tr(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            height: 1.2,
          ),
        ),
        Text(
          "good_morning".tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap: onNotificationTap,
      child: Container(
        width: context.responsiveButtonHeight / 2.5,
        height: context.responsiveButtonHeight / 2.5,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: CustomSvgImage(
                assetName: AppAssets.shoppingBag,
                width: context.responsiveIconSize,
                height: context.responsiveIconSize,
              ),
            ),

            Positioned(
              top: 8,
              right: 10,
              child: Container(
                width: context.responsiveIconSize / 2,
                height: context.responsiveIconSize / 2,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        width: double.infinity,
        height: context.responsiveButtonHeight / 2,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
          child: Row(
            children: [
              Icon(
                Iconsax.search_normal,
                color: AppColors.textSecondary,
                size: context.responsiveIconSize,
              ),

              SizedBox(width: context.responsiveMargin),

              Expanded(
                child: Text(
                  searchHint ?? "search_products".tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
