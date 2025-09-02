import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/features/rewards/business/models/reward_offer.dart';
import 'package:baqalty/features/rewards/business/models/reward_history.dart';
import 'package:baqalty/features/rewards/presentation/widgets/offer_list_item.dart';
import 'package:baqalty/features/rewards/presentation/widgets/history_list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTabIndex = 0;
  final int _earnedPoints = 3222;

  final List<RewardOffer> _offers = [
    const RewardOffer(
      id: '1',
      title: 'Fruits Discount',
      pointsRequired: 400,
      description: '5% On Fruits',
      iconPath: 'fruits',
    ),
    const RewardOffer(
      id: '2',
      title: 'Vegetables Discount',
      pointsRequired: 300,
      description: '10% On Vegetables',
      iconPath: 'vegetables',
    ),
    const RewardOffer(
      id: '3',
      title: 'Bread Discount',
      pointsRequired: 200,
      description: '15% On Bread',
      iconPath: 'bread',
    ),
    const RewardOffer(
      id: '4',
      title: 'Snacks Discount',
      pointsRequired: 500,
      description: '8% On Snacks',
      iconPath: 'snacks',
    ),
  ];

  final List<RewardHistory> _history = [
    RewardHistory(
      id: '1',
      title: 'Earned Points',
      description: 'Earned Points',
      points: 450,
      type: TransactionType.earned,
      iconPath: 'gift',
      date: DateTime(2024, 8, 1),
    ),
    RewardHistory(
      id: '2',
      title: 'Fruits Discount',
      description: '5% On Fruits',
      points: 550,
      type: TransactionType.redeemed,
      iconPath: 'fruits',
      date: DateTime(2024, 7, 29),
    ),
    RewardHistory(
      id: '3',
      title: 'Chicken Discount',
      description: '5% On chicken',
      points: 850,
      type: TransactionType.redeemed,
      iconPath: 'chicken',
      date: DateTime(2024, 7, 28),
    ),
    RewardHistory(
      id: '4',
      title: 'Earned Points',
      description: 'Earned Points',
      points: 700,
      type: TransactionType.earned,
      iconPath: 'gift',
      date: DateTime(2024, 7, 25),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          _buildRewardsHeader(),

          Expanded(child: _buildTabbedContent()),
        ],
      ),
    );
  }

  Widget _buildRewardsHeader() {
    return SizedBox(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: AppColors.primary),
          ),

          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warning.withValues(alpha: 0.4),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 40,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.5),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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

                        Text(
                          _earnedPoints.toString(),
                          style: TextStyles.textViewBold27.copyWith(
                            color: AppColors.white,
                            fontSize: 32.sp,
                          ),
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
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: context.responsivePadding),
            itemCount: _offers.length,
            itemBuilder: (context, index) {
              return OfferListItem(
                offer: _offers[index],
                onGetPressed: () => _onOfferGetPressed(_offers[index]),
              );
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
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: context.responsivePadding),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return HistoryListItem(
                history: _history[index],
                onTap: () => _onHistoryItemTapped(_history[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onOfferGetPressed(RewardOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'redeeming'.tr()} ${offer.description}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onHistoryItemTapped(RewardHistory history) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'viewing'.tr()} ${history.description}'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
