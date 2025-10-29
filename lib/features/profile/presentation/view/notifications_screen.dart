import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/orders/presentation/view/order_details_screen.dart';
import 'package:baqalty/features/orders/presentation/view/replacement_orders_screen.dart';
import 'package:baqalty/features/rewards/presentation/view/rewards_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/features/profile/business/cubit/notification_cubit.dart';
import 'package:baqalty/features/profile/business/cubit/notification_state.dart';
import 'package:baqalty/features/profile/data/services/notification_service.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(
        ServiceLocator.get<NotificationService>(),
      )..getNotifications(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: CustomAppBar(
        title: "notifications".tr(),
        onBackPressed: () => Navigator.of(context).pop(),

      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is NotificationError) {
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
                    state.message,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().getNotifications();
                    },
                    child: Text("retry".tr()),
                  ),
                ],
              ),
            );
          } else if (state is NotificationLoaded) {
            if (state.notificationData.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "no_notifications".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(context.responsivePadding),
              itemCount: state.notificationData.data.length,
              itemBuilder: (context, index) {
                final notification = state.notificationData.data[index];
                return _buildNotificationCard(context, notification);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, notification) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
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
      child: InkWell(
        onTap: () {
         if(notification.type.toLowerCase() == 'order') {
          NavigationManager.navigateTo(OrderDetailsScreen(orderId: notification.requestId));
         }else if(notification.type.toLowerCase() == 'discount') {
         NavigationManager.navigateTo(RewardsScreen());
         }else if(notification.type.toLowerCase() == 'replace_order') {
          NavigationManager.navigateTo(ReplacementOrdersScreen());
         }
        },
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: notification.isRead 
                    ? AppColors.textSecondary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: notification.isRead 
                    ? AppColors.textSecondary
                    : AppColors.primary,
                  size: 6.w,
                ),
              ),
              
              SizedBox(width: 3.w),
              
              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: TextStyles.textViewMedium14.copyWith(
                        color: notification.isRead 
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                        fontWeight: notification.isRead 
                          ? FontWeight.normal
                          : FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      notification.timeAgo,
                      style: TextStyles.textViewMedium12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Copy Code Button for Discount Notifications
              if (notification.type.toLowerCase() == 'discount')
              SizedBox(width: 2.w),
              if (notification.type.toLowerCase() == 'discount')
                GestureDetector(
                  onTap: () {
                    _copyDiscountCode(context, notification.message);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                    ),
                    child: Icon(
                      Iconsax.copy,
                      color: AppColors.primary,
                      size: 5.w,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Iconsax.shopping_bag;
      case 'promotion':
        return Iconsax.discount_shape;
      case 'system':
        return Iconsax.info_circle;
      default:
        return Iconsax.notification;
    }
  }

  void _copyDiscountCode(BuildContext context, String message) {
    // Extract discount code from message using regex
    // Looking for patterns like: "كود الخصم: ABC123" or "Discount Code: ABC123"
    final RegExp codeRegex = RegExp(r'كود[:\s]*([A-Z0-9]+)|كوبون[:\s]*([A-Z0-9]+)|كود الخصم[:\s]*([A-Z0-9]+)|Discount Code[:\s]*([A-Z0-9]+)|Code[:\s]*([A-Z0-9]+)', caseSensitive: false);
    
    final Match? match = codeRegex.firstMatch(message);
    String? discountCode;
    
    if (match != null) {
      // Get the first non-null group (the actual code)
      for (int i = 1; i <= match.groupCount; i++) {
        if (match.group(i) != null) {
          discountCode = match.group(i);
          break;
        }
      }
    }
    
    if (discountCode != null && discountCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: discountCode));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${"code_copied".tr()}: $discountCode"),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // If no specific code found, try to extract any alphanumeric code
      final RegExp generalCodeRegex = RegExp(r'\b([A-Z0-9]{4,})\b');
      final Match? generalMatch = generalCodeRegex.firstMatch(message);
      
      if (generalMatch != null) {
        final String generalCode = generalMatch.group(1)!;
        Clipboard.setData(ClipboardData(text: generalCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${"code_copied".tr()}: $generalCode"),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("no_code_found".tr()),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}