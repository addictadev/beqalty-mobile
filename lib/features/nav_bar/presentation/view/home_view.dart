import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
          HomeHeader(onSearchTap: () {}, onNotificationTap: () {}),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: context.responsiveMargin * 2),

                    PromotionalSlider(
                      cards: promotionalCards,
                      height: context.responsiveContainerHeight * 0.6,
                      onCardTap: () {},
                    ),

                    SizedBox(height: context.responsiveMargin * 2),

                    ShopByCategorySection(
                      onViewAllTap: () {},
                      onCategoryTap: () {},
                    ),

                    SizedBox(height: context.responsiveMargin * 2),

                    PointsCard(points: 1250, onRedeemTap: () {}),
                    SizedBox(height: context.responsiveMargin * 2),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsivePadding,
                        ),
                        child: Text(
                          "special_offer".tr(),
                          style: TextStyles.textViewBold16.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.responsiveMargin * 2),

                    SpecialOffersSection(
                      onViewAllTap: () {},
                      onProductTap: () {},
                    ),
                    SizedBox(height: context.responsiveMargin * 2),
                    SavedCartsSection(onViewAllTap: () {}, onCartTap: () {}),

                    SizedBox(height: context.responsiveMargin * 2),
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
