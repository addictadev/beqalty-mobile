import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/features/rewards/business/cubit/loyalty_cubit.dart';
import 'package:baqalty/features/rewards/business/cubit/loyalty_state.dart';
import 'package:baqalty/features/rewards/data/services/loyalty_service.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoyaltyCubit(
        ServiceLocator.get<LoyaltyService>(),
      )..getLoyaltyData(),
      child: const RewardsView(),
    );
  }
}

class RewardsView extends StatefulWidget {
  const RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {
  int _selectedTabIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<LoyaltyCubit, LoyaltyState>(
        listener: (context, state) {
          if (state is LoyaltyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.rewardsBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildRewardsHeader(),
              Expanded(child: _buildTabbedContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsHeader() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 35.h, maxHeight: 40.h),
      child: Stack(
        children: [
   

         
      

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: context.responsiveIconSize * 1.5,
                    height: context.responsiveIconSize * 1.5,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
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

                  SizedBox(height: context.responsiveMargin * 2),

                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [AppColors.success, AppColors.warning],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'my_rewards_points'.tr(),
                              style: TextStyles.textViewBold20.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: context.responsiveMargin * 2),

                        Text(
                          'earned_points'.tr(),
                          style: TextStyles.textViewMedium16.copyWith(
                            color: AppColors.white,
                          ),
                        ),

                        SizedBox(height: context.responsiveMargin),

                        BlocBuilder<LoyaltyCubit, LoyaltyState>(
                          builder: (context, state) {
                            if (state is LoyaltyLoaded) {
                              return Text(
                                state.loyaltyData.balance.toString(),
                                style: TextStyles.textViewBold27.copyWith(
                                  color: AppColors.white,
                                  fontSize: 32.sp,
                                ),
                              );
                            } else if (state is LoyaltyTransactionsLoaded) {
                              return Text(
                                state.transactionsData.balance.toString(),
                                style: TextStyles.textViewBold27.copyWith(
                                  color: AppColors.white,
                                  fontSize: 32.sp,
                                ),
                              );
                            } else if (state is LoyaltyLoading) {
                              return const CircularProgressIndicator(
                                color: AppColors.white,
                              );
                            } else {
                              return Text(
                                '0',
                                style: TextStyles.textViewBold27.copyWith(
                                  color: AppColors.white,
                                  fontSize: 32.sp,
                                ),
                              );
                            }
                          },
                        ),
                      ],
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

  Widget _buildTabbedContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(context.responsivePadding),
            decoration: BoxDecoration(
              color: AppColors.overlayGray,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius,
              ),
            ),
            child: Row(
              children: [
                _buildTab(
                  context,
                  index: 0,
                  title: 'get_offers'.tr(),
                  isSelected: _selectedTabIndex == 0,
                ),
                _buildTab(
                  context,
                  index: 1,
                  title: 'points_history'.tr(),
                  isSelected: _selectedTabIndex == 1,
                ),
              ],
            ),
          ),

          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required int index,
    required String title,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
          // Load data based on selected tab
          if (index == 0) {
            // Load loyalty data for offers tab
            context.read<LoyaltyCubit>().getLoyaltyData();
          } else if (index == 1) {
            // Load points transactions for history tab
            context.read<LoyaltyCubit>().getPointsTransactions();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.responsiveMargin * 1.5,
            horizontal: context.responsivePadding,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(
              context.responsiveBorderRadius * 2,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.textViewMedium14.copyWith(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedTabIndex == 0) {
      return _buildOffersTab();
    } else {
      return _buildHistoryTab();
    }
  }

  Widget _buildOffersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Text(
            'get_your_offers'.tr(),
            style: TextStyles.textViewMedium18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: BlocBuilder<LoyaltyCubit, LoyaltyState>(
            builder: (context, state) {
              if (state is LoyaltyLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoyaltyError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoyaltyCubit>().getLoyaltyData();
                        },
                        child: Text("retry".tr()),
                      ),
                    ],
                  ),
                );
              } else if (state is LoyaltyLoaded) {
                if (state.loyaltyData.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "no_offers_available".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: context.responsivePadding),
                  itemCount: state.loyaltyData.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.loyaltyData.transactions[index];
                    return _buildLoyaltyOfferItem(transaction);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Text(
            'points_history'.tr(),
            style: TextStyles.textViewMedium18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: BlocBuilder<LoyaltyCubit, LoyaltyState>(
            builder: (context, state) {
              if (state is LoyaltyLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoyaltyError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoyaltyCubit>().getPointsTransactions();
                        },
                        child: Text("retry".tr()),
                      ),
                    ],
                  ),
                );
              } else if (state is LoyaltyTransactionsLoaded) {
                if (state.transactionsData.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "no_transactions".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: context.responsivePadding),
                  itemCount: state.transactionsData.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactionsData.transactions[index];
                    return _buildPointsTransactionItem(transaction);
                  },
                );
              } else if (state is LoyaltyLoaded) {
                // Fallback to old loyalty data if points transactions not loaded
                if (state.loyaltyData.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      "no_transactions".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: context.responsivePadding),
                  itemCount: state.loyaltyData.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.loyaltyData.transactions[index];
                    return _buildTransactionItem(transaction);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoyaltyOfferItem(transaction) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 0.5.h,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            ),
            child: CustomSvgImage(assetName: AppAssets.ser,width: 8.w,height: 8.w,)
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.languageCode == 'ar' 
                    ? transaction.titleAr 
                    : transaction.titleEn,
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
             
             Row(children: [     Text(
                  '${transaction.pricePoints} ${"points".tr()}',
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.success,
                  ),
                ),  Text(
                  ' --- ${transaction.value} ${"egp".tr()}',
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.success,
                  ),
                ),],)
            
            
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
         
              PrimaryButton(
                height: 4.5.h,
                width: 20.w,
                fontSize: 12.sp,
                onPressed: transaction.isActive 
                  ? () => _onLoyaltyOfferGetPressed(transaction)
                  : null,
              text: "get".tr(),
                ),
              
            ],
          ),
        ],
      ),
    );
  }

  void _onLoyaltyOfferGetPressed(transaction) async {
    try {
      await context.read<LoyaltyCubit>().redeemLoyaltyPoints(transaction.id);
      
      // Show success message after redemption
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("redeemed_successfully".tr()),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("error_occurred".tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }


  Widget _buildTransactionItem(transaction) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 0.5.h,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stars,
              color: AppColors.primary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.languageCode == 'ar' 
                    ? transaction.titleAr 
                    : transaction.titleEn,
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${transaction.pricePoints} ${"points".tr()}',
                  style: TextStyles.textViewMedium12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${transaction.value} ${"egp".tr()}',
                  style: TextStyles.textViewBold12.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(transaction.createdAt),
                style: TextStyles.textViewMedium12.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: transaction.isActive 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                ),
                child: Text(
                  transaction.isActive ? "active".tr() : "inactive".tr(),
                  style: TextStyles.textViewMedium10.copyWith(
                    color: transaction.isActive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsTransactionItem(transaction) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 0.5.h,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
               Container(
            padding: EdgeInsets.all(2.w),
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            ),
            child: CustomSvgImage(assetName: AppAssets.ser,width: 8.w,height: 8.w,)
          ),
          
        
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.reason,
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.textPrimary,
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
                //   '${"request_type".tr()}: ${transaction.requestType}',
                //   style: TextStyles.textViewMedium12.copyWith(
                //     color: AppColors.textSecondary,
                //   ),
                // ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
         
          
          Row(children: [    Icon(
              transaction.type == 'earn' ? Icons.add : Icons.remove,
              color: transaction.type == 'earn' ? AppColors.success : AppColors.error,
              size: 5.w,
            ),   Text(
                  '${transaction.points} ${"points".tr()}',
                  style: TextStyles.textViewBold14.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: transaction.type == 'earn' ? AppColors.success : AppColors.error,
                  ),
                ),
          ])
           
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

}
