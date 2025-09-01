import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/features/nav_bar/presentation/view/home_view.dart'
    show HomeView;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/images_preview/custom_svg_img.dart';
import 'profile_screen.dart';
import '../../../cart/presentation/view/cart_screen.dart';
import '../../../categories/presentation/view/categories_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const CartScreen(),
    const CategoriesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Curved background with gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: context.responsiveMargin * 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.scaffoldBackground,
                        AppColors.scaffoldBackground.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        context.responsiveBorderRadius * 2,
                      ),
                      topRight: Radius.circular(
                        context.responsiveBorderRadius * 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation items
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                  vertical: context.responsiveMargin,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: AppAssets.homeIcon,
                      activeIcon: AppAssets.homeIcon,
                      label: "home".tr(),
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: AppAssets.orderIcon,
                      activeIcon: AppAssets.orderIcon,
                      label: "orders".tr(),
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: AppAssets.categoryIcon,
                      activeIcon: AppAssets.categoryIcon,
                      label: "categories".tr(),
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: AppAssets.profileIcon,
                      activeIcon: AppAssets.profileIcon,
                      label: "profile".tr(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String activeIcon,
    required String label,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsiveMargin * 1.5,
          vertical: context.responsiveMargin * 0.5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator dot
            if (isActive)
              Container(
                width: 4,
                height: 4,
                margin: EdgeInsets.only(bottom: context.responsiveMargin * 0.3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            CustomSvgImage(
              assetName: isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              width: context.responsiveIconSize,
            ),

            SizedBox(height: context.responsiveMargin * 0.3),
            Text(
              label,
              style:
                  (isActive
                          ? TextStyles.textViewMedium12
                          : TextStyles.textViewRegular12)
                      .copyWith(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
