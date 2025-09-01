import 'package:baqalty/features/nav_bar/presentation/view/home_view.dart'
    show HomeView;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
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
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
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
                        AppColors.scaffoldBackground.withOpacity(0.8),
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
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: "Home",
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.shopping_cart_outlined,
                      activeIcon: Icons.shopping_cart,
                      label: "Cart",
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.category_outlined,
                      activeIcon: Icons.category,
                      label: "Categories",
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: "Profile",
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
    required IconData icon,
    required IconData activeIcon,
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
          horizontal: context.responsiveMargin,
          vertical: context.responsiveMargin * 0.5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
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

            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: context.responsiveIconSize,
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
