import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/rewards/presentation/view/rewards_screen.dart';
import 'package:baqalty/features/saved_carts/presentation/view/saved_carts_screen.dart';
import 'package:baqalty/features/categories/presentation/view/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../widget/home_header.dart';
import '../widget/promotional_slider.dart';
import '../widget/shop_by_category_section.dart';
import '../widget/points_card.dart';
import '../widget/special_offers_section.dart';
import '../widget/saved_carts_section.dart';
import 'package:baqalty/core/widgets/shimmer_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    // Simulate API call or data loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _refreshData() {
    setState(() {
      _isLoading = true;
    });
    _simulateLoading();
  }

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
              context.read<NavBarCubit>().changeTab(2);
            },
            onNotificationTap: () {},
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: RefreshIndicator(
                onRefresh: () async {
                  _refreshData();
                  // Wait for loading to complete
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Show shimmer for slider and content
                      if (_isLoading)
                        _buildSliderAndContentShimmer(context)
                      else
                        Column(
                          children: [
                            PromotionalSlider(
                              cards: promotionalCards,
                              height: context.responsiveContainerHeight * 0.6,
                              onCardTap: () {},
                            ),
                            SizedBox(height: 1.h),
                            _buildContent(context),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        ShopByCategorySection(
          onViewAllTap: () {
            context.read<NavBarCubit>().changeTab(3);
          },
          onCategoryTap: (categoryName) {
            NavigationManager.navigateTo(
              SubcategoryScreen(categoryName: 'default_category'),
            );
          },
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
          onProductTap: () {
            NavigationManager.navigateTo(
              ProductDetailsScreen(
                productName: 'product_name',
                productImage: 'product_image',
                productPrice: 100,
                productCategory: 'product_category',
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        SavedCartsSection(
          onViewAllTap: () {
            NavigationManager.navigateTo(SavedCartsScreen());
          },
          onCartTap: (cartTitle) {
            NavigationManager.navigateTo(SavedCartsScreen());
          },
        ),

        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildSliderAndContentShimmer(BuildContext context) {
    return Column(
      children: [
        // Promotional Slider Shimmer
        _buildPromotionalSliderShimmer(context),

        SizedBox(height: 3.h),

        // Categories Section Shimmer
        _buildCategoriesShimmer(context),

        SizedBox(height: 3.h),

        // Points Card Shimmer
        _buildPointsCardShimmer(context),

        SizedBox(height: 2.h),

        // Special Offers Title Shimmer
        _buildSpecialOffersTitleShimmer(context),

        SizedBox(height: 2.h),

        // Special Offers Section Shimmer
        _buildSpecialOffersShimmer(context),

        SizedBox(height: 2.h),

        // Saved Carts Section Shimmer
        _buildSavedCartsShimmer(context),

        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildPromotionalSliderShimmer(BuildContext context) {
    return ShimmerWidget(
      isLoading: true,
      child: ShimmerBox(
        width: double.infinity,
        height: context.responsiveContainerHeight * 0.6,
        borderRadius: context.responsiveBorderRadius * 2,
      ),
    );
  }

  Widget _buildCategoriesShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.h),
            ),
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 15.w, height: 1.5.h),
            ),
          ],
        ),

        // Categories Grid
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 3.h),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return ShimmerWidget(
              isLoading: true,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shadowLight,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerCircle(size: 8.w),
                    SizedBox(height: 1.h),
                    ShimmerText(width: 20.w, height: 1.h),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPointsCardShimmer(BuildContext context) {
    return ShimmerWidget(
      isLoading: true,
      child: Container(
        width: double.infinity,
        height: 12.h,
        decoration: BoxDecoration(
          color: AppColors.shadowLight,
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Row(
            children: [
              ShimmerCircle(size: 8.w),
              SizedBox(width: context.responsiveMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerText(
                      width: 25.w,
                      height: 1.5.h,
                      margin: EdgeInsets.only(bottom: 0.5.h),
                    ),
                    ShimmerText(width: 15.w, height: 1.h),
                  ],
                ),
              ),
              ShimmerBox(width: 20.w, height: 4.h, borderRadius: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffersTitleShimmer(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ShimmerWidget(
        isLoading: true,
        child: ShimmerText(width: 25.w, height: 2.h),
      ),
    );
  }

  Widget _buildSpecialOffersShimmer(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 40.w,
            margin: EdgeInsets.only(right: context.responsiveMargin),
            child: ShimmerWidget(
              isLoading: true,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shadowLight,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ShimmerBox(
                      width: double.infinity,
                      height: 15.h,
                      borderRadius: context.responsiveBorderRadius,
                    ),
                    Padding(
                      padding: EdgeInsets.all(context.responsivePadding * 0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerText(
                            width: double.infinity,
                            height: 1.5.h,
                            margin: EdgeInsets.only(bottom: 0.5.h),
                          ),
                          ShimmerText(
                            width: 60.w,
                            height: 1.h,
                            margin: EdgeInsets.only(bottom: 0.5.h),
                          ),
                          ShimmerText(width: 20.w, height: 1.5.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSavedCartsShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.h),
            ),
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 15.w, height: 1.5.h),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Saved Carts List
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 60.w,
                margin: EdgeInsets.only(right: context.responsiveMargin),
                child: ShimmerWidget(
                  isLoading: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shadowLight,
                      borderRadius: BorderRadius.circular(
                        context.responsiveBorderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(context.responsivePadding),
                      child: Row(
                        children: [
                          ShimmerBox(
                            width: 8.w,
                            height: 8.w,
                            borderRadius: 4.w,
                          ),
                          SizedBox(width: context.responsiveMargin),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerText(
                                  width: double.infinity,
                                  height: 1.5.h,
                                  margin: EdgeInsets.only(bottom: 0.5.h),
                                ),
                                ShimmerText(width: 40.w, height: 1.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
