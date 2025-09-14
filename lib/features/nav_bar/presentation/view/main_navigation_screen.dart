import 'package:baqalty/core/utils/styles/font_utils.dart' show FontSizes;
import 'package:baqalty/core/widgets/exit_popup.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/nav_bar/business/models/nav_item_model.dart';
import 'package:baqalty/features/nav_bar/presentation/view/home_view.dart'
    show HomeView;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/images_preview/custom_svg_img.dart';
import 'profile_screen.dart';
import '../../../cart/presentation/view/cart_screen.dart';
import '../../../search/presentation/view/search_results_screen.dart';
import '../../../categories/presentation/view/categories_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarCubit(),
      child: const MainNavigationScreenBody(),
    );
  }
}

class MainNavigationScreenBody extends StatelessWidget {
  const MainNavigationScreenBody({super.key});

  static const List<Widget> _screens = [
    HomeView(),
    CartScreen(),
    SearchResultsScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        if (state is NavBarLoaded) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) return;
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (_) => const ExitPopUp(),
              );
              if (shouldPop == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: _screens[state.currentIndex],
              bottomNavigationBar: _buildBottomNavigationBar(context, state),
            ),
          );
        }

        // Loading state
        return const Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, NavBarLoaded state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveBorderRadius * 2),
          topRight: Radius.circular(context.responsiveBorderRadius * 2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsivePadding * 2,
            vertical: context.responsiveMargin * 1.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: state.navItems.map((navItem) {
              return _buildNavItem(context, navItem);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItemModel navItem) {
    return GestureDetector(
      onTap: () {
        context.read<NavBarCubit>().changeTab(navItem.index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsiveMargin * 1.5,
          vertical: context.responsiveMargin * 0.1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgImage(
              assetName: navItem.isActive ? navItem.activeIcon : navItem.icon,
              color: navItem.isActive
                  ? AppColors.black
                  : AppColors.textSecondary,
              width: context.responsiveIconSize * 1.1,
              height: context.responsiveIconSize * 1.1,
            ),

            SizedBox(height: context.responsiveMargin * 0.4),
            Text(
              navItem.label.tr(),
              style: TextStyles.textViewMedium12.copyWith(
                color: navItem.isActive
                    ? AppColors.black
                    : AppColors.textSecondary,
                fontSize: FontSizes.s12,
                fontWeight: navItem.isActive
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
