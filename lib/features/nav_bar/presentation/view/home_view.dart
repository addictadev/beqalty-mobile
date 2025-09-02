import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/rewards/presentation/view/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/features/search/index.dart';
import '../widget/home_header.dart';
import '../widget/promotional_slider.dart';
import '../widget/shop_by_category_section.dart';
import '../widget/points_card.dart';
import '../widget/special_offers_section.dart';
import '../widget/saved_carts_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final promotionalCards = [
      PromotionalCardData(
        title: "free_delivery_title".tr(),
        buttonText: "place_order".tr(),
      ),
      PromotionalCardData(
        title: "50% Off on First Order!",
        buttonText: "Shop Now",
      ),
      PromotionalCardData(
        title: "Special Weekend Deals!",
        buttonText: "Explore",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          HomeHeader(
            onSearchTap: () {
              NavigationManager.navigateTo(SearchResultsScreen());
            },
            onNotificationTap: () {},
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    PromotionalSlider(
                      cards: promotionalCards,
                      height: context.responsiveContainerHeight * 0.6,
                      onCardTap: () {},
                    ),

                    SizedBox(height: 1.h),

                    ShopByCategorySection(
                      onViewAllTap: () {
                        context.read<NavBarCubit>().changeTab(2);
                      },
                      onCategoryTap: () {},
                    ),

                    SizedBox(height: 2.h),

                    PointsCard(
                      points: 1250,
                      onRedeemTap: () {
                        NavigationManager.navigateTo(RewardsScreen());
                      },
                    ),
                    SizedBox(height: 2.h),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "special_offer".tr(),
                        style: TextStyles.textViewBold16.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    SpecialOffersSection(
                      onViewAllTap: () {},
                      onProductTap: () {},
                    ),
                    SizedBox(height: 2.h),
                    SavedCartsSection(onViewAllTap: () {}, onCartTap: () {}),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
