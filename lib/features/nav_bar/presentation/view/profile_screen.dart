import 'dart:async';
import 'package:baqalty/core/constants/app_constants.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/orders/presentation/view/orders_screen.dart';
import 'package:baqalty/features/saved_carts/presentation/view/saved_carts_screen.dart';
import 'package:baqalty/features/profile/presentation/view/my_account_screen.dart';
import 'package:baqalty/features/profile/presentation/view/settings_screen.dart';
import 'package:baqalty/features/profile/presentation/view/help_center_screen.dart';
import 'package:baqalty/features/rewards/presentation/view/rewards_screen.dart';
import 'package:baqalty/features/saved_carts/presentation/view/saved_items_screen.dart';
import 'package:baqalty/features/saved_carts/business/cubit/favorite_items_cubit.dart';
import 'package:baqalty/features/saved_carts/data/services/favorite_items_service.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/wallet/presentation/view/my_wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile_widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      setState(() {});
    }
  }

  @override
  void didPopNext() {
    // Called when returning to this screen from another screen
    super.didPopNext();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.primary),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.responsivePadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "profile".tr(),
                          style: TextStyles.textViewBold16.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            NavigationManager.navigateTo(MyAccountScreen());
                          },
                          child: Text(
                            "edit_profile".tr(),
                            style: TextStyles.textViewMedium16.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.responsiveMargin * 4.5),

                    Row(
                      children: [
                        Container(
                          width: context.responsiveIconSize * 3,
                          height: context.responsiveIconSize * 3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.characterSkinTone,
                            border: Border.all(
                              color: AppColors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowMedium,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: SharedPrefsHelper.getString(AppConstants.userImageKey)
                                    ?.isNotEmpty ??
                                false
                                ? CustomCachedImage(
                                    imageUrl:
                                        SharedPrefsHelper.getString(
                                            AppConstants.userImageKey) ??
                                        AppAssets.appIcon,
                                  )
                                : Image.asset(
                                    AppAssets.appIcon,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        SizedBox(width: context.responsiveMargin * 2),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                SharedPrefsHelper.getString(AppConstants.userNameKey)??"",
                                style: TextStyles.textViewBold20.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: context.responsiveMargin * 0.5),
                              Text(
                                SharedPrefsHelper.getString(AppConstants.userEmailKey)??"",
                                style: TextStyles.textViewRegular14.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.responsiveMargin * 2),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: context.responsiveMargin * 2,
                left: context.responsiveMargin,
                right: context.responsiveMargin,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.responsiveBorderRadius * 3),
                  topRight: Radius.circular(context.responsiveBorderRadius * 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ProfileMenuItem(
                            iconPath: AppAssets.profilePerson,
                            title: "my_account".tr(),
                            onTap: () {
                              NavigationManager.navigateTo(MyAccountScreen());
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileWallet,
                            title: "my_wallet".tr(),
                            onTap: () {
                             NavigationManager.navigateTo(MyWalletScreen());
                            },
                          ),
                      
                          ProfileMenuItem(
                            iconPath: AppAssets.ordesrIcon,
                            title: "orders".tr(),
                            onTap: () {
                             final navBarCubit = context.read<NavBarCubit>();
                              NavigationManager.navigateTo(
                                OrdersScreen(onNavigateToCategories: () {
                                navBarCubit.changeTab(3);
                              },
                               onNavigateToCart: () {
                                navBarCubit.changeTab(1);
                              }));
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileSavedCarts,
                            title: "saved_carts".tr(),
                            onTap: () {
                             NavigationManager.navigateTo(SavedCartsScreen());
                            },
                          ),
                              ProfileMenuItem(
                            iconPath: AppAssets.profileHeart,
                            title: "my_rewards_points".tr(),
                            onTap: () {
                             NavigationManager.navigateTo(RewardsScreen());
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileHeart,
                            title: "saved_items".tr(),
                            onTap: () {
                              NavigationManager.navigateTo(
                                BlocProvider<FavoriteItemsCubit>(
                                  create: (context) => FavoriteItemsCubit(
                                    ServiceLocator.get<FavoriteItemsService>(),
                                  ),
                                  child: SavedItemsScreen(
                                    onNavigateToCategories: () {
                                      final navBarCubit = context.read<NavBarCubit>();
                                      navBarCubit.changeTab(3);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileSettings,
                            title: "settings".tr(),
                            onTap: () {
                              NavigationManager.navigateTo(SettingsScreen());
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileHelp,
                            title: "help_center".tr(),
                            onTap: () {
                              NavigationManager.navigateTo(HelpCenterScreen());
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profilePhone,
                            title: "contact".tr(),
                            onTap: () {
                              launchUrl(Uri.parse('tel:01010300353'));
                            },
                          ),
                        ],
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
