import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';

import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';

import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'subcategory_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create staggered animations for each category item
    _itemAnimationControllers = List.generate(
      12, // Number of categories
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();

    // Start animations with stagger
    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();

    // Stagger the item animations
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          _itemAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _itemAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.responsiveMargin * 2),
              Text(
                "categories".tr(),
                style: TextStyles.textViewBold18.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.responsiveMargin),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: CustomTextFormField(
                  hint: "search".tr(),
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
          return AnimatedBuilder(
            animation: _itemAnimations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _itemAnimations[index].value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - _itemAnimations[index].value)),
                  child: Opacity(
                    opacity: _itemAnimations[index].value.clamp(0.0, 1.0),
                    child: _buildCategoryCard(
                      context,
                      name: category.name,
                      icon: category.icon,
                      iconBackgroundColor: category.iconBackgroundColor,
                      iconColor: category.iconColor,
                    ),
                  ),
                ),
              );
            },
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
            NavigationManager.navigateTo(SubcategoryScreen(categoryName: name));
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
