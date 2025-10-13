import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/features/nav_bar/business/cubit/home_cubit/home_cubit.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
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
import 'home_shimmer_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomeViewBody(),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const HomeShimmerView();
          }

          if (state is HomeError) {
            return Column(
              children: [
                HomeHeader(
                  onSearchTap: () {
                    context.read<NavBarCubit>().changeTab(2);
                  },
                  onNotificationTap: () {},
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16.w,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomErrorWidget(
                          message: state.message,
                          onRetry: () =>
                              context.read<HomeCubit>().getHomeData(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is HomeLoaded) {
            final homeData = state.homeData;

            return Column(
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
                        context.read<HomeCubit>().getHomeData();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 2.h),

                            PromotionalSlider(
                              cards: homeData.data.advertisements,
                              height: context.responsiveContainerHeight * 0.6,
                              onCardTap: () {},
                            ),
                            SizedBox(height: 1.h),
                            _buildContent(context, homeData),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, homeData) {
    return Column(
      children: [
        ShopByCategorySection(
          categories: homeData.data.categories,
          onViewAllTap: () {
            context.read<NavBarCubit>().changeTab(3);
          },
          onCategoryTap: (category) {
            NavigationManager.navigateTo(
              SubcategoryScreen(
                categoryName: category.catName,
                categoryId: category.catId.toString(),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        PointsCard(
          points: homeData.data.points ?? 0,
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
          discountProducts: homeData.data.discountedProducts,
          onViewAllTap: () {},
        
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
}
