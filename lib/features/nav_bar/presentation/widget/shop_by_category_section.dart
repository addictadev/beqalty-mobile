import 'dart:math' as math;
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/item_not_found_banner.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'category_card.dart';

class ShopByCategorySection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final Function(CategoryModel)? onCategoryTap;
  final List<CategoryModel> categories;

  const ShopByCategorySection({
    super.key,
    this.onViewAllTap,
    this.onCategoryTap,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      margin: EdgeInsets.symmetric(
        vertical: context.responsivePadding * 0.5,
      ),
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
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    if (categories.isEmpty) {
      return ItemNotFoundBanner(
        title: "your_categories_not_found".tr(),
        subtitle: "please_refresh_to_load_categories".tr(),
        buttonText: "refresh_categories".tr(),
        onReplacePressed: () {
          // You can add refresh logic here
          // For example, trigger a refresh of home data
        },
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final backgroundColor = _getRandomBackgroundColor(category.catId);
        final iconColor = _getRandomIconColor(category.catId);

        return CategoryCard(
          title: category.catName,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          imageUrl: category.catImage,
          onTap: () {
            onCategoryTap?.call(category);
          },
        );
      },
    );
  }

  Color _getRandomBackgroundColor(int categoryId) {
    final pastelColors = [
      const Color(0xFFFFE5E5),
      const Color(0xFFFFF8E1),
      const Color(0xFFE8F5E8),
      const Color(0xFFE3F2FD),
      const Color(0xFFFFF3E0),
      const Color(0xFFF3E5F5),
      const Color(0xFFE0F7FA),
      const Color(0xFFFCE4EC),
      const Color(0xFFF1F8E9),
      const Color(0xFFFFF9C4),
      const Color(0xFFE1BEE7),
      const Color(0xFFFFCCBC),
    ];

    final random = math.Random(categoryId);
    return pastelColors[random.nextInt(pastelColors.length)];
  }

  Color _getRandomIconColor(int categoryId) {
    final vibrantColors = [
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
      const Color(0xFF2196F3),
      const Color(0xFF03A9F4),
      const Color(0xFF00BCD4),
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
      const Color(0xFF8BC34A),
      const Color(0xFFCDDC39),
      const Color(0xFFFFEB3B),
      const Color(0xFFFFC107),
      const Color(0xFFFF9800),
      const Color(0xFFFF5722),
      const Color(0xFFF44336),
    ];

    final random = math.Random(categoryId + 1000);
    return vibrantColors[random.nextInt(vibrantColors.length)];
  }
}
