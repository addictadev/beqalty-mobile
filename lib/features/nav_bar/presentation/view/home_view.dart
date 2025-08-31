import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widget/home_header.dart';
import '../widget/promotional_slider.dart';
import '../widget/shop_by_category_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample promotional cards data
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
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          HomeHeader(onSearchTap: () {}, onNotificationTap: () {}),

          Expanded(
            child: Container(
              color: AppColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 24),

                    // Promotional Slider
                    PromotionalSlider(
                      cards: promotionalCards,
                      height: 120,
                      onCardTap: () {
                        // Handle promotional card tap
                      },
                    ),

                    SizedBox(height: 32),

                    // Shop by Category Section
                    ShopByCategorySection(
                      onViewAllTap: () {
                        // Handle view all categories tap
                      },
                      onCategoryTap: () {
                        // Handle category tap
                      },
                    ),

                    SizedBox(height: 32),

                    // Placeholder for other content
                    Expanded(
                      child: Center(
                        child: Text(
                          'Other Home Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
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
