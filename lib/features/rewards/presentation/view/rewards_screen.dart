import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/features/rewards/business/models/reward_offer.dart';
import 'package:baqalty/features/rewards/business/models/reward_history.dart';
import 'package:baqalty/features/rewards/presentation/widgets/rewards_header.dart';
import 'package:baqalty/features/rewards/presentation/widgets/rewards_tab_bar.dart';
import 'package:baqalty/features/rewards/presentation/widgets/offer_list_item.dart';
import 'package:baqalty/features/rewards/presentation/widgets/history_list_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTabIndex = 0;
  final int _earnedPoints = 3222;

  // Mock data for offers
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

  // Mock data for history
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
          // Header with points balance
          RewardsHeader(
            earnedPoints: _earnedPoints,
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          // Tab bar and content
          Expanded(
            child: RewardsTabBar(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),

          // Content area
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
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
        // Section title
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

        // Offers list
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
        // Section title
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

        // History list
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
    // Handle offer redemption
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'redeeming'.tr()} ${offer.description}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onHistoryItemTapped(RewardHistory history) {
    // Handle history item tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${'viewing'.tr()} ${history.description}'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
