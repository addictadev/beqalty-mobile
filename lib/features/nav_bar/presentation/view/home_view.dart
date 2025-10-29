import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/core/widgets/item_not_found_banner.dart';
import 'package:baqalty/features/nav_bar/business/cubit/home_cubit/home_cubit.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/orders/presentation/view/replacement_orders_screen.dart';
import 'package:baqalty/features/profile/presentation/view/notifications_screen.dart';
import 'package:baqalty/features/categories/presentation/view/subcategory_screen.dart';
import 'package:baqalty/features/rewards/presentation/view/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../../../saved_carts/presentation/view/saved_cart_details_screen.dart';
import '../../../saved_carts/presentation/view/saved_carts_screen.dart';
import '../widget/home_header.dart';
import '../widget/promotional_slider.dart';
import '../widget/saved_carts_section.dart';
import '../widget/shop_by_category_section.dart';
import '../widget/points_card.dart';
import '../widget/special_offers_section.dart';
import 'home_shimmer_view.dart';
import 'package:baqalty/core/widgets/warehouse_unavailable_banner.dart';

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

class _HomeViewBodyState extends State<HomeViewBody> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
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
                  onNotificationTap: () {
                    NavigationManager.navigateTo(NotificationsScreen());
                  },
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
                  onNotificationTap: (){
                    context.read<NavBarCubit>().changeTab(1);
                  },
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
                            
                            // Item Not Found Banner - Top of screen
                            _buildItemNotFoundBanner(context, homeData),
                            
                            // Warehouse Unavailable Banner
                            _buildWarehouseUnavailableBanner(context, homeData),
                            
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

  Widget _buildItemNotFoundBanner(BuildContext context, homeData) {
    // Show banner if merchantReplacementOrdersCount > 0
    final replacementOrdersCount = homeData.data.merchantReplacementOrdersCount;
    
    if (replacementOrdersCount > 0) {
      return ItemNotFoundBanner(
        title: "your_item_not_found".tr(),
        subtitle: "please_replace_your_item".tr(),
        buttonText: "replace_item".tr(),
        onReplacePressed: () {
          NavigationManager.navigateTo(ReplacementOrdersScreen());
        },
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildWarehouseUnavailableBanner(BuildContext context, homeData) {
    // Show banner if warehouse is not available
    final warehouseInfo = homeData.data.warehouse;
    
    if (!warehouseInfo.available) {
      return WarehouseUnavailableBanner(
        message: warehouseInfo.message,
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildContent(BuildContext context, homeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          onRedeemTap: () async {
            await NavigationManager.navigateTo(RewardsScreen());
            // Refresh home data after returning from rewards screen
            if (mounted) {
              context.read<HomeCubit>().getHomeData();
            }
          },
        ),
        SizedBox(height: 2.h),

    if (homeData.data.discountedProducts.isNotEmpty)   Text(
            "special_offer".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        
      

        SizedBox(height: 2.h),

    if (homeData.data.discountedProducts.isNotEmpty)   SpecialOffersSection(
          discountProducts: homeData.data.discountedProducts,
          onViewAllTap: () {},
         
        ),
        SizedBox(height: 2.h),
        SavedCartsSection(
          savedCarts: homeData.data.savedCarts,
          onViewAllTap: () async {
            await NavigationManager.navigateTo(SavedCartsScreen());
            // Refresh after returning from saved carts screen
            if (mounted) {
              context.read<HomeCubit>().getHomeData();
            }
          },
          onCartTap: (cartData) async {
            final parts = cartData.split('|');
            final cartName = parts[0];
            final cartId = int.parse(parts[1]);
            await NavigationManager.navigateTo(SavedCartDetailsScreen(cartId: cartId, cartName: cartName));
            // Refresh after returning from saved carts screen
            if (mounted) {
              context.read<HomeCubit>().getHomeData();
            }
          },
          onCreateNewCart: () async {
            await NavigationManager.navigateTo(SavedCartsScreen());
            // Refresh after returning from saved carts screen
            if (mounted) {
              context.read<HomeCubit>().getHomeData();
            }
          },
          onRefreshNeeded: () {
            // Only refresh when explicitly needed
            if (mounted) {
              context.read<HomeCubit>().getHomeData();
            }
          },
        ),

        SizedBox(height: 2.h),
      ],
    );
  }
}
