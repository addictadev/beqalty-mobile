import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'category_card.dart';

class ShopByCategorySection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final VoidCallback? onCategoryTap;

  const ShopByCategorySection({
    super.key,
    this.onViewAllTap,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),

            SizedBox(height: 24),

            // Category grid
            _buildCategoryGrid(),
          ],
        ),
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
            fontSize: 18.sp,
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
        icon: Iconsax.flash,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFFF4444),
      ),
      CategoryData(
        title: "snacks".tr(),
        icon: Iconsax.cake,
        iconBackgroundColor: const Color(0xFFFFF8E1),
        iconColor: const Color(0xFFFFB300),
      ),
      CategoryData(
        title: "bread".tr(),
        icon: Iconsax.box,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        title: "fruits".tr(),
        icon: Iconsax.heart,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        title: "vegetables".tr(),
        icon: Iconsax.tree,
        iconBackgroundColor: const Color(0xFFE8F5E8),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryData(
        title: "meat".tr(),
        icon: Iconsax.bag,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFE91E63),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
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
            onCategoryTap?.call();
          },
        );
      },
    );
  }
}

class CategoryData {
  final String title;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const CategoryData({
    required this.title,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}
