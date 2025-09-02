import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/orders/presentation/view/orders_screen.dart';
import 'package:baqalty/features/profile/presentation/view/my_account_screen.dart';
import 'package:baqalty/features/profile/presentation/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../profile_widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Dark header with profile info
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.primary),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.responsivePadding),
                child: Column(
                  children: [
                    // Top row with title and edit button
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
                            "Edit Profile".tr(),
                            style: TextStyles.textViewMedium16.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.responsiveMargin * 4.5),

                    // User profile information
                    Row(
                      children: [
                        // Profile image
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
                            child: Image.asset(
                              AppAssets.appIcon,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(width: context.responsiveMargin * 2),

                        // User details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Donye Collins",
                                style: TextStyles.textViewBold20.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: context.responsiveMargin * 0.5),
                              Text(
                                "iamcollinsdonye@gmail.com",
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

          // Main content area with curved top
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
                    // Profile menu items
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
                              debugPrint('My Wallet tapped');
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileOrders,
                            title: "orders".tr(),
                            onTap: () {
                              NavigationManager.navigateTo(OrdersScreen());
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileSavedCarts,
                            title: "saved_carts".tr(),
                            onTap: () {
                              debugPrint('Saved Carts tapped');
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profileHeart,
                            title: "saved_items".tr(),
                            onTap: () {
                              debugPrint('Saved Items tapped');
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
                              debugPrint('Help Center tapped');
                            },
                          ),
                          ProfileMenuItem(
                            iconPath: AppAssets.profilePhone,
                            title: "contact".tr(),
                            onTap: () {
                              debugPrint('Contact tapped');
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
