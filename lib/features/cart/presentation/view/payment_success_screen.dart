import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:baqalty/features/orders/business/models/order_model.dart';
import 'package:baqalty/features/orders/presentation/view/track_order_screen.dart' show TrackOrderScreen;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;
  final String? orderId;

  const PaymentSuccessScreen({super.key, required this.amount, this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarCubit(),
      child: const PaymentSuccessScreenBody(),
    );
  }
}

class PaymentSuccessScreenBody extends StatefulWidget {
  const PaymentSuccessScreenBody({super.key});

  @override
  State<PaymentSuccessScreenBody> createState() =>
      _PaymentSuccessScreenBodyState();
}

class _PaymentSuccessScreenBodyState extends State<PaymentSuccessScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.celebrateImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildSuccessCard(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(AppAssets.ticketImg, fit: BoxFit.contain),
            ),
          ),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.responsiveMargin * 2),
                  CustomSvgImage(assetName: AppAssets.sucessIcon),

                  SizedBox(height: context.responsiveMargin * 2),

                  Text(
                    "payment_success".tr(),
                    style: TextStyles.textViewBold24.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: context.responsiveMargin),

                  Text(
                    "payment_success_description".tr(),
                    style: TextStyles.textViewRegular16.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  SizedBox(height: context.responsiveMargin * 3),

                  Column(
                    children: [
                      Text(
                        "total_payment".tr(),
                        style: TextStyles.textViewRegular14.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: context.responsiveMargin * 0.8),
                      Text(
                        "215 EGP",
                        style: TextStyles.textViewBold24.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: context.responsiveMargin * 8),

                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              NavigationManager.navigateTo(
                                TrackOrderScreen(order: OrderModel(
                                  id: "1",
                                  orderNumber: "1234567890",
                                  orderDate: DateTime.now(),
                                  itemCount: 1,
                                  status: OrderStatus.pending,
                                  totalAmount: 100,
                                  items: [],
                                )),
                              );
                            },
                            child: Center(
                              child: Text(
                                "track_your_order".tr(),
                                style: TextStyles.textViewBold16.copyWith(
                                  color: AppColors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: context.responsiveMargin * 2),

                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              NavigationManager.navigateToAndFinish(
                                MainNavigationScreen(),
                              );
                            },
                            child: Center(
                              child: Text(
                                "keep_shopping".tr(),
                                style: TextStyles.textViewBold16.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
