import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'category_card.dart';

class ShopByCategorySection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final Function(String)? onCategoryTap;

  const ShopByCategorySection({
    super.key,
    this.onViewAllTap,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 2.h),

          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "shop_by_category".tr(),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        GestureDetector(
          onTap: onViewAllTap,
          child: Icon(
            Iconsax.arrow_right_3,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      CategoryData(
        title: "hot_deals".tr(),
        icon: AppAssets.hotmealIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFFF4444),
      ),
      CategoryData(
        title: "snacks".tr(),
        icon: AppAssets.snacksIcon,
        iconBackgroundColor: const Color(0xFFFFF8E1),
        iconColor: const Color(0xFFFFB300),
      ),
      CategoryData(
        title: "bread".tr(),
        icon: AppAssets.breadIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        title: "fruits".tr(),
        icon: AppAssets.fruitsIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        title: "vegetables".tr(),
        icon: AppAssets.vegetableIcon,
        iconBackgroundColor: const Color(0xFFE8F5E8),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryData(
        title: "meat".tr(),
        icon: AppAssets.meatIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFE91E63),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          title: category.title,
          icon: category.icon,
          iconBackgroundColor: category.iconBackgroundColor,
          iconColor: category.iconColor,
          onTap: () {
            onCategoryTap?.call(category.title);
          },
        );
      },
    );
  }
}

class CategoryData {
  final String title;
  final String icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const CategoryData({
    required this.title,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}
