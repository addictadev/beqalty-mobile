import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/features/wallet/business/models/wallet_transaction_model.dart';
import 'package:baqalty/features/wallet/presentation/view/set_amount_screen.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  final double _currentBalance = 1800.0;
  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    // Simulate loading transactions
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _transactions = _getMockTransactions();
        _isLoading = false;
      });
    });
  }

  void _onDepositPressed() {
    NavigationManager.navigateTo(SetAmountScreen());
  }

  void _onSupportPressed() {
    // TODO: Implement support functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Support functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Header Section with Balance
          _buildHeader(context),

          // Main Content Area with Transactions
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 30.h, maxHeight: 30.h),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.1),
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
                color: AppColors.primaryLight.withValues(alpha: 0.3),
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
                color: AppColors.success.withValues(alpha: 0.4),
              ),
            ),
          ),

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
                      CustomBackButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icons.arrow_back_ios,
                      ),
                      Text(
                        "wallet".tr(),
                        style: TextStyles.textViewBold18.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      // Support Icon
                      GestureDetector(
                        onTap: _onSupportPressed,
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

                  SizedBox(height: context.responsiveMargin * 1),

                  // Balance Section
                  Expanded(
                    child: Row(
                      children: [
                        // Left Side - Avatar and Balance
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Balance Amount
                              Text(
                                '${_currentBalance.toStringAsFixed(0)} EGP',
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
                                  horizontal: context.responsivePadding * 1.4,
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
                                      width: context.responsiveIconSize * 0.8,
                                      height: context.responsiveIconSize * 0.8,
                                    ),
                                    SizedBox(
                                      width: context.responsiveMargin * 1,
                                    ),
                                    Text(
                                      "deposit".tr(),
                                      style: TextStyles.textViewMedium16
                                          .copyWith(
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
      child: _isLoading
          ? _buildLoadingState()
          : _buildTransactionsList(context),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: context.responsiveMargin * 2),
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

  Widget _buildTransactionsList(BuildContext context) {
    // Group transactions by date
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    final todayTransactions = _transactions.where((t) {
      final transactionDate = DateTime(
        t.timestamp.year,
        t.timestamp.month,
        t.timestamp.day,
      );
      return transactionDate == DateTime(today.year, today.month, today.day);
    }).toList();

    final yesterdayTransactions = _transactions.where((t) {
      final transactionDate = DateTime(
        t.timestamp.year,
        t.timestamp.month,
        t.timestamp.day,
      );
      return transactionDate ==
          DateTime(yesterday.year, yesterday.month, yesterday.day);
    }).toList();

    return ListView(
      padding: EdgeInsets.all(context.responsivePadding),
      children: [
        // Today Section
        if (todayTransactions.isNotEmpty) ...[
          _buildSectionHeader("today".tr()),
          ...todayTransactions.map(
            (transaction) => _buildTransactionCard(transaction),
          ),
          SizedBox(height: context.responsiveMargin * 2),
        ],

        // Yesterday Section
        if (yesterdayTransactions.isNotEmpty) ...[
          _buildSectionHeader("yesterday".tr()),
          ...yesterdayTransactions.map(
            (transaction) => _buildTransactionCard(transaction),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.responsiveMargin,
        top: context.responsiveMargin,
      ),
      child: Text(
        title,
        style: TextStyles.textViewMedium16.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(WalletTransactionModel transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Transaction ID and timestamp
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${transaction.transactionId}',
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  transaction.formattedTimestamp,
                  style: TextStyles.textViewRegular12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Right side - Amount
          Text(
            transaction.formattedAmount,
            style: TextStyles.textViewSemiBold16.copyWith(
              color: transaction.amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<WalletTransactionModel> _getMockTransactions() {
    return [
      WalletTransactionModel(
        id: '1',
        transactionId: 'BAQ10247',
        type: TransactionType.deposit,
        amount: 225,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WalletTransactionModel(
        id: '2',
        transactionId: 'BAQ10248',
        type: TransactionType.deposit,
        amount: 1540,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      WalletTransactionModel(
        id: '3',
        transactionId: 'BAQ10249',
        type: TransactionType.purchase,
        amount: 798,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      WalletTransactionModel(
        id: '4',
        transactionId: 'BAQ10248',
        type: TransactionType.deposit,
        amount: 105,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      WalletTransactionModel(
        id: '5',
        transactionId: 'BAQ10249',
        type: TransactionType.refund,
        amount: 150,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ];
  }
}
