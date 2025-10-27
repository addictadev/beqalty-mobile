import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/features/wallet/business/cubit/wallet_cubit.dart';
import 'package:baqalty/features/wallet/business/cubit/wallet_state.dart';
import 'package:baqalty/features/wallet/data/services/wallet_service.dart';
import 'package:baqalty/features/wallet/presentation/view/set_amount_screen.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit(
        ServiceLocator.get<WalletService>(),
      )..getWalletTransactions(),
      child: const MyWalletView(),
    );
  }
}

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});

  void _onDepositPressed() {
    NavigationManager.navigateTo(SetAmountScreen());
  }

  void _onSupportPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('support_coming_soon'.tr()),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.walletBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Header Section with Balance
            _buildHeader(context),

            // Main Content Area with Transactions
            Expanded(child: _buildMainContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      constraints: BoxConstraints(minHeight: 28.h, maxHeight: 28.h),
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row - Back Button and Support Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: context.responsiveIconSize * 1.4,
                        height: context.responsiveIconSize * 1.4,
                        decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            NavigationManager.pop();
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            color: AppColors.textPrimary,
                            size: context.responsiveIconSize,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Text(
                        "wallet".tr(),
                        style: TextStyles.textViewBold18.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      // Support Icon
                      GestureDetector(
                        onTap: () => _onSupportPressed(context),
                        child: Container(
                          width: context.responsiveIconSize * 1.7,
                          height: context.responsiveIconSize * 1.7,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.headphone,
                            color: AppColors.white,
                            size: context.responsiveIconSize * 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.responsiveMargin * 4),

                  // Balance Section
                  Expanded(
                    child: BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        String balance = "0.00";
                        if (state is WalletLoaded) {
                          balance = state.walletData.balance;
                        }

                        return Row(
                          children: [
                            // Left Side - Avatar and Balance
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Balance Amount
                                  Text(
                                    '$balance ${"egp".tr()}',
                                    style: TextStyles.textViewBold27.copyWith(
                                      color: AppColors.white,
                                      fontSize: 28,
                                    ),
                                  ),

                                  SizedBox(height: context.responsiveMargin * 0.5),

                                  // Balance Label
                                  Text(
                                    "your_balance".tr(),
                                    style: TextStyles.textViewMedium16.copyWith(
                                      color: AppColors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right Side - Deposit Button
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _onDepositPressed,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.responsivePadding * 1.5,
                                      vertical: context.responsiveMargin * 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(
                                        context.responsiveBorderRadius * 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomSvgImage(
                                          assetName: AppAssets.moneySendIcon,
                                          color: AppColors.textPrimary,
                                          width: context.responsiveIconSize * 0.7,
                                          height: context.responsiveIconSize * 0.7,
                                        ),
                                        SizedBox(
                                          width: context.responsiveMargin * 1,
                                        ),
                                        Text(
                                          "deposit".tr(),
                                          style: TextStyles.textViewMedium14.copyWith(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return _buildLoadingState();
          } else if (state is WalletError) {
            return _buildErrorState(context, state.message);
          } else if (state is WalletLoaded) {
            if (state.walletData.transactions.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTransactionsList(context, state.walletData.transactions);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 2.h),
          Text(
            "loading_transactions".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              context.read<WalletCubit>().getWalletTransactions();
            },
            child: Text("retry".tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 2.h),
          Text(
            "no_transactions".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context, transactions) {
    return ListView(
      padding: EdgeInsets.all(context.responsivePadding),
      children: [
        // Transactions Header
        Text(
          "transactions".tr(),
          style: TextStyles.textViewBold18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2.h),
        
        // Transactions List
        ...transactions.map((transaction) => _buildTransactionCard(context, transaction)).toList(),
      ],
    );
  }

  Widget _buildTransactionCard(BuildContext context, transaction) {
    final isDeposit = transaction.type.toLowerCase() == 'deposit';
    final amountColor = isDeposit ? AppColors.success : AppColors.error;
    final amountPrefix = isDeposit ? '+' : '-';

    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding,vertical: context.responsivePadding * 1.8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
  
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.reason,
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyles.textViewMedium12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                // SizedBox(height: 0.5.h),
                // Text(
                //   "${"request_type".tr()}: ${transaction.requestType}",
                //   style: TextStyles.textViewMedium12.copyWith(
                //     color: AppColors.textSecondary,
                //   ),
                // ),
              ],
            ),
          ),
          
          // Amount
          Text(
            '$amountPrefix${transaction.amount} ${"egp".tr()}',
            style: TextStyles.textViewBold16.copyWith(
              color: amountColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return "${difference.inMinutes} ${"minutes_ago".tr()}";
        }
        return "${difference.inHours} ${"hours_ago".tr()}";
      } else if (difference.inDays == 1) {
        return "yesterday".tr();
      } else if (difference.inDays < 7) {
        return "${difference.inDays} ${"days_ago".tr()}";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return dateString;
    }
  }
}