import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.responsiveMargin * 6),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: CustomTextFormField(
                hint: "search_transactions".tr(),
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: AppColors.textSecondary,
                ),
                onChanged: (value) {
                  debugPrint(value);
                },
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),

            Expanded(child: _buildCategoriesGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      CategoryData(
        name: "hot_deals",
        icon: AppAssets.hotmealIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFFF4444),
      ),
      CategoryData(
        name: "snacks",
        icon: AppAssets.snacksIcon,
        iconBackgroundColor: const Color(0xFFFFF8E1),
        iconColor: const Color(0xFFFFB300),
      ),
      CategoryData(
        name: "bread",
        icon: AppAssets.breadIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        name: "fruits",
        icon: AppAssets.fruitsIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        name: "vegetables",
        icon: AppAssets.vegetableIcon,
        iconBackgroundColor: const Color(0xFFE8F5E8),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryData(
        name: "meat",
        icon: AppAssets.meatIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFE91E63),
      ),
      CategoryData(
        name: "dairy",
        icon: AppAssets.fruitsIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        name: "grains",
        icon: AppAssets.vegetableIcon,
        iconBackgroundColor: const Color(0xFFE8F5E8),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryData(
        name: "seafood",
        icon: AppAssets.meatIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFE91E63),
      ),
      CategoryData(
        name: "nuts",
        icon: AppAssets.fruitsIcon,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
      CategoryData(
        name: "legumes",
        icon: AppAssets.vegetableIcon,
        iconBackgroundColor: const Color(0xFFE8F5E8),
        iconColor: const Color(0xFF4CAF50),
      ),
      CategoryData(
        name: "poultry",
        icon: AppAssets.meatIcon,
        iconBackgroundColor: const Color(0xFFFFE5E5),
        iconColor: const Color(0xFFE91E63),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.responsiveMargin,
          mainAxisSpacing: context.responsiveMargin,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            context,
            name: category.name,
            icon: category.icon,
            iconBackgroundColor: category.iconBackgroundColor,
            iconColor: category.iconColor,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required String icon,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: () {
            debugPrint('Category tapped: $name');
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsiveIconSize * 2,
                  height: context.responsiveIconSize * 2,
                  padding: EdgeInsets.all(context.responsivePadding * 0.8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                  ),
                  child: CustomSvgImage(
                    assetName: icon,
                    color: iconColor,
                    width: context.responsiveIconSize,
                    height: context.responsiveIconSize,
                  ),
                ),
                SizedBox(height: context.responsiveMargin),
                Text(
                  name.tr(),
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryData {
  final String name;
  final String icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const CategoryData({
    required this.name,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}
