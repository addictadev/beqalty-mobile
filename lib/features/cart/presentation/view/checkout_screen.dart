import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/cart/presentation/widget/cart_summary.dart';
import 'package:baqalty/features/cart/presentation/widget/card_selector.dart';
import 'package:baqalty/features/cart/presentation/widget/payment_method_selector.dart';
import 'package:baqalty/features/cart/presentation/view/payment_success_screen.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBarCubit(),
      child: const CheckoutScreenBody(),
    );
  }
}

class CheckoutScreenBody extends StatefulWidget {
  const CheckoutScreenBody({super.key});

  @override
  State<CheckoutScreenBody> createState() => _CheckoutScreenBodyState();
}

class _CheckoutScreenBodyState extends State<CheckoutScreenBody> {
  String _selectedPaymentMethod = 'card';
  String _selectedCard = 'paypal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsivePadding,
                    vertical: context.responsiveMargin,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.responsiveMargin * 2),

                      CartSummary(
                        title: "Breakfast Cart",
                        itemCount: "12 Items",
                        items: const [
                          CartItem(name: "2 Al Marai Milk", price: "140 EGP"),
                          CartItem(name: "5 Egg", price: "25 EGP"),
                          CartItem(name: "5 Ice Cream", price: "50 EGP"),
                        ],
                        initiallyExpanded: true,
                        onToggle: () {
                          // Optional: Add any additional logic when cart is toggled
                          debugPrint('Cart toggled');
                        },
                      ),

                      SizedBox(height: context.responsiveMargin * 3),

                      PaymentMethodSelector(
                        selectedMethod: _selectedPaymentMethod,
                        onMethodChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        options: const [
                          PaymentMethodOption(
                            icon: AppAssets.cardIcon,
                            title: "card",
                            value: "card",
                          ),
                          PaymentMethodOption(
                            icon: AppAssets.cashIcon,
                            title: "cash_on_delivery",
                            value: "cod",
                          ),
                          PaymentMethodOption(
                            icon: AppAssets.walletIcon,
                            title: "baqalty_wallet",
                            value: "wallet",
                          ),
                        ],
                      ),

                      SizedBox(height: context.responsiveMargin * 3),

                      CardSelector(
                        selectedCard: _selectedCard,
                        onCardChanged: (value) {
                          setState(() {
                            _selectedCard = value;
                          });
                        },
                        cards: const [
                          CardOption(
                            id: 'paypal',
                            icon: AppAssets.paypalIcon,
                            title: "paypal_card",
                            maskedNumber: "XXX XXX XXX 8553",
                            brandColor: Color(0xFF0070BA),
                          ),
                          CardOption(
                            id: 'mastercard',
                            icon: AppAssets.mastercardIcon,
                            title: "mastercard",
                            maskedNumber: "XXX XXX XXX 8553",
                            brandColor: Color(0xFFEB001B),
                          ),
                        ],
                        onAddNewCard: () {},
                      ),

                      SizedBox(height: context.responsiveMargin * 3),

                      _buildOrderSummarySection(context),

                      SizedBox(height: context.responsiveMargin * 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: "checkout".tr(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      showBackButton: true,
      onBackPressed: () {
        context.read<NavBarCubit>().changeTab(0);
      },
    );
  }

  Widget _buildOrderSummarySection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        image: const DecorationImage(
          image: AssetImage(AppAssets.promotionalCard),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            label: "sub_total",
            value: 215,
            isTotal: false,
          ),
          SizedBox(height: context.responsiveMargin),
          _buildSummaryRow(
            context,
            label: "delivery_fee",
            value: 20,
            isTotal: false,
          ),
          SizedBox(height: context.responsiveMargin),
          _buildSummaryRow(
            context,
            label: "discount",
            value: -20,
            isTotal: false,
            isDiscount: true,
          ),
          SizedBox(height: context.responsiveMargin * 1.5),
          _buildSummaryRow(context, label: "total", value: 215, isTotal: true),
          SizedBox(height: context.responsiveMargin * 1.5),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: context.responsivePadding * 2,
            ),
            child: PrimaryButton(
              text: "place_order".tr(),
              onPressed: () {
                NavigationManager.navigateTo(
                  PaymentSuccessScreen(amount: 215.0),
                );
              },
              color: AppColors.white,
              textStyle: TextStyles.textViewBold16.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required double value,
    required bool isTotal,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr(),
          style:
              (isTotal
                      ? TextStyles.textViewBold18
                      : TextStyles.textViewRegular14)
                  .copyWith(color: AppColors.white),
        ),
        Text(
          "${value.toStringAsFixed(0)} EGP",
          style:
              (isTotal
                      ? TextStyles.textViewBold18
                      : TextStyles.textViewRegular14)
                  .copyWith(
                    color: isDiscount ? AppColors.success : AppColors.white,
                  ),
        ),
      ],
    );
  }
}
