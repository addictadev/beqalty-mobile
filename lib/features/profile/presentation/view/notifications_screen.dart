import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_toggle_switch.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _transactionAlert = true;
  bool _insightAlert = false;
  bool _sortTransactionsAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "notifications".tr(),
        titleColor: AppColors.textPrimary,
        iconColor: AppColors.textPrimary,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.responsiveMargin * 2),

              // Notification Settings
              _buildNotificationSetting(
                title: "transaction_alert".tr(),
                value: _transactionAlert,
                onChanged: (value) {
                  setState(() {
                    _transactionAlert = value;
                  });
                  _showNotificationChangeSnackBar(
                    "transaction_alert".tr(),
                    value,
                  );
                },
              ),

              SizedBox(height: context.responsiveMargin * 3),

              _buildNotificationSetting(
                title: "insight_alert".tr(),
                value: _insightAlert,
                onChanged: (value) {
                  setState(() {
                    _insightAlert = value;
                  });
                  _showNotificationChangeSnackBar("insight_alert".tr(), value);
                },
              ),

              SizedBox(height: context.responsiveMargin * 3),

              _buildNotificationSetting(
                title: "sort_transactions_alert".tr(),
                value: _sortTransactionsAlert,
                onChanged: (value) {
                  setState(() {
                    _sortTransactionsAlert = value;
                  });
                  _showNotificationChangeSnackBar(
                    "sort_transactions_alert".tr(),
                    value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSetting({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin * 1.5,
      ),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyles.textViewMedium16.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Toggle Switch
          CustomToggleSwitch(
            value: value,
            onChanged: onChanged,
            width: 51,
            height: 31,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.borderLight,
            thumbColor: AppColors.white,
          ),
        ],
      ),
    );
  }

  void _showNotificationChangeSnackBar(
    String notificationType,
    bool isEnabled,
  ) {
    final message = isEnabled
        ? '$notificationType enabled'
        : '$notificationType disabled';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyles.textViewMedium14.copyWith(color: AppColors.white),
        ),
        backgroundColor: isEnabled
            ? AppColors.success
            : AppColors.textSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
