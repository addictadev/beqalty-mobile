import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/features/orders/business/models/order_model.dart';
import 'package:baqalty/features/orders/presentation/view/order_details_screen.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTrackOrder;
  final VoidCallback? onOrderAgain;

  const OrderCard({
    super.key,
    required this.order,
    this.onTrackOrder,
    this.onOrderAgain,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         NavigationManager.navigateTo(
      OrderDetailsScreen(orderId: int.parse(order.id)),
    );
      },
      child: Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
     
          Row(
            children: [
              // Order Icon

              // Order Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Shopping bag icon on the left
                       Container(
                         width: context.responsiveIconSize * 2,
                         height: context.responsiveIconSize * 2,
                         padding: EdgeInsets.all(context.responsivePadding * 0.8),
                         decoration: BoxDecoration(
                           color: AppColors.borderLight.withValues(alpha: .4),
                           borderRadius: BorderRadius.circular(
                             context.responsiveBorderRadius,
                           ),
                         ),
                         child: CustomSvgImage(
                           assetName: AppAssets.shoppingBag,
                           color: AppColors.black,
                         ),
                       ),
                       
                       // Item count and status badge on the right
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           // Item Count
                           Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: context.responsivePadding * 0.8,
                               vertical: context.responsiveMargin * 0.5,
                             ),
                             decoration: BoxDecoration(
                               color: AppColors.borderLight,
                               borderRadius: BorderRadius.circular(
                                 context.responsiveBorderRadius * 2,
                               ),
                             ),
                             child: Text(
                               "${order.itemCount} ${order.itemCount == 1 ? 'item'.tr() : 'items'.tr()}",
                               style: TextStyles.textViewMedium12.copyWith(
                                 color: AppColors.textSecondary,
                               ),
                             ),
                           ),

                           SizedBox(width: context.responsiveMargin),

                           // Status Badge
                           Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: context.responsivePadding * 0.8,
                               vertical: context.responsiveMargin * 0.5,
                             ),
                             decoration: BoxDecoration(
                               color: order.statusColor.withValues(alpha: 0.1),
                               borderRadius: BorderRadius.circular(
                                 context.responsiveBorderRadius * 2,
                               ),
                             ),
                             child: Text(
                               order.statusText.tr(),
                               style: TextStyles.textViewMedium12.copyWith(
                                 color: order.statusColor,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),


SizedBox(height: context.responsiveMargin),
                    // Order ID
               
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(
                      "#${order.orderNumber}",
                      style: TextStyles.textViewBold16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
              _buildActionButton(context),
               ]),
                    // SizedBox(height: context.responsiveMargin * 0.3),

                    // // Order Total Price
                    // Text(
                    //   "${"total".tr()} : ${order.totalAmount.toStringAsFixed(2)} ${"egp".tr()}",
                    //   style: TextStyles.textViewMedium14.copyWith(
                    //     color: AppColors.primary,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),

                    SizedBox(height: context.responsiveMargin * 0.5),

                    // Order Date/Time or Estimated Time
                    _buildTimeInfo(context),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    if (order.status == OrderStatus.outForDelivery &&
        order.estimatedTime != null) {
      return Row(
        children: [
          Text(
            "est_time".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: context.responsiveMargin * 0.5),
          Text(
            order.estimatedTime!,
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "${order.formattedDate}, ${order.formattedTime}",
        style: TextStyles.textViewRegular14.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }
  }

  Widget _buildActionButton(BuildContext context) {
    if (order.status == OrderStatus.outForDelivery) {
      return GestureDetector(
        onTap: onTrackOrder,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsivePadding * 1.2,
            vertical: context.responsiveMargin * 1.2,
          ),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(
              context.responsiveBorderRadius * 2,
            ),
          ),
          child: Text(
            "track_order".tr(),
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else if (order.status == OrderStatus.delivered) {
      return GestureDetector(
        onTap: onOrderAgain,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsivePadding * 1.2,
            vertical: context.responsiveMargin * 1.2,
          ),
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(
              context.responsiveBorderRadius * 2,
            ),
          ),
          child: Text(
            "order_again".tr(),
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
