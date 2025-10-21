import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/features/orders/business/cubit/order_details_cubit.dart';
import 'package:baqalty/features/orders/data/services/order_details_service.dart';
import 'package:baqalty/features/orders/data/models/order_details_response_model.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import '../widgets/rating_bottom_sheet.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsCubit(ServiceLocator.get<OrderDetailsService>())
        ..getOrderDetails(orderId),
      child: const OrderDetailsScreenBody(),
    );
  }
}

class OrderDetailsScreenBody extends StatelessWidget {
  const OrderDetailsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(title: "order_details".tr()),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (state is OrderDetailsLoading) {
            return _buildLoadingState(context);
          } else if (state is OrderDetailsLoaded) {
            return _buildLoadedState(context, state.orderDetails);
          } else if (state is OrderDetailsError) {
            return _buildErrorState(context, state.message);
          }
          return _buildLoadingState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "loading_order_details".tr(),
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
            Iconsax.warning_2,
            size: context.responsiveIconSize * 4,
            color: AppColors.error,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "error_loading_order_details".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            message,
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          ElevatedButton(
            onPressed: () {
              context.read<OrderDetailsCubit>().getOrderDetails(
                (context.read<OrderDetailsCubit>().state as OrderDetailsLoaded).orderDetails.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text("retry".tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, OrderDetailsDataModel orderDetails) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          _buildOrderHeader(context, orderDetails),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          // Order Items
          _buildOrderItems(context, orderDetails.items),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          // Order Summary
          _buildOrderSummary(context, orderDetails),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          // Payment Information
          _buildPaymentInfo(context, orderDetails.payments),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          // Delivery Information
          _buildDeliveryInfo(context, orderDetails),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          // Rating Button (only for delivered orders that can be rated and haven't been rated)
          if (_isDeliveredOrder(orderDetails.status) && 
              orderDetails.canRating && 
              !orderDetails.isRating)
            _buildRatingButton(context, orderDetails),
          
          // Already Rated Section (for delivered orders that have been rated)
          if (_isDeliveredOrder(orderDetails.status) && 
              orderDetails.isRating)
            _buildAlreadyRatedSection(context, orderDetails),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, OrderDetailsDataModel orderDetails) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderDetails.code,
                style: TextStyles.textViewBold18.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding * 0.8,
                  vertical: context.responsiveMargin * 0.5,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(orderDetails.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
                ),
                child: Text(
                  _translateStatus(orderDetails.status),
                  style: TextStyles.textViewMedium12.copyWith(
                    color: _getStatusColor(orderDetails.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "${"warehouse".tr()}: ${orderDetails.warehouse}",
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      // Arabic statuses
      case 'قيد الانتظار':
        return 'pending'.tr();
      case 'تم التأكيد':
      case 'مؤكد':
        return 'confirmed'.tr();
      case 'جاري تجهيز الطلب':
        return 'preparing'.tr();
      case 'في طريقه للتسليم':
      case 'في الطريق':
        return 'out_for_delivery'.tr();
      case 'تم التسليم':
        return 'delivered'.tr();
      case 'فشل':
      case 'فشل التسليم':
        return 'failed'.tr();
      case 'ملغي':
      case 'تم الإلغاء':
        return 'cancelled'.tr();
      // English statuses (fallback)
      case 'pending':
        return 'pending'.tr();
      case 'confirmed':
        return 'confirmed'.tr();
      case 'preparing':
        return 'preparing'.tr();
      case 'out_for_delivery':
        return 'out_for_delivery'.tr();
      case 'delivered':
        return 'delivered'.tr();
      case 'failed':
        return 'failed'.tr();
      case 'cancelled':
        return 'cancelled'.tr();
      default:
        return status; // Return original if no match found
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      // Arabic statuses
      case 'قيد الانتظار':
        return const Color(0xFFFFC107); // Warning yellow
      case 'تم التأكيد':
      case 'مؤكد':
        return const Color(0xFF3B82F6); // Info blue
      case 'جاري تجهيز الطلب':
        return const Color(0xFF8B5CF6); // Purple
      case 'في طريقه للتسليم':
      case 'في الطريق':
        return const Color(0xFF3B82F6); // Blue
      case 'تم التسليم':
        return const Color(0xFF10B981); // Success green
      case 'فشل':
      case 'فشل التسليم':
      case 'فشل التوصيل':
        return const Color(0xFFEF4444); // Error red
      case 'ملغي':
      case 'تم الإلغاء':
        return const Color(0xFF6B7280); // Gray
      // English statuses (fallback)
      case 'pending':
        return const Color(0xFFFFC107); // Warning yellow
      case 'confirmed':
        return const Color(0xFF3B82F6); // Info blue
      case 'preparing':
        return const Color(0xFF8B5CF6); // Purple
      case 'out_for_delivery':
        return const Color(0xFF3B82F6); // Blue
      case 'delivered':
        return const Color(0xFF10B981); // Success green
      case 'failed':
        return const Color(0xFFEF4444); // Error red
      case 'cancelled':
        return const Color(0xFF6B7280); // Gray
      default:
        return const Color(0xFFFFC107); // Warning yellow (pending)
    }
  }

  Widget _buildOrderItems(BuildContext context, List<OrderItemDetailsModel> items) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        children: [
          Text(
            "order_items".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          ...items.map((item) => _buildOrderItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, OrderItemDetailsModel item) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.responsiveMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "${"quantity".tr()}: ${item.quantity}",
                  style: TextStyles.textViewRegular12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${item.total} ${"egp".tr()}",
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderDetailsDataModel orderDetails) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        children: [
          Text(
            "order_summary".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          _buildSummaryRow(context, "subtotal".tr(), 
            "${(double.parse(orderDetails.totalPrice) - double.parse(orderDetails.deliveryFees)).toStringAsFixed(2)} ${"egp".tr()}"),
          _buildSummaryRow(context, "delivery_fees".tr(), 
            "${orderDetails.deliveryFees} ${"egp".tr()}"),
          if (double.parse(orderDetails.discountValue) > 0)
            _buildSummaryRow(context, "discount".tr(), 
              "-${orderDetails.discountValue} ${"egp".tr()}", isDiscount: true),
          Divider(color: AppColors.borderLight),
          _buildSummaryRow(context, "total".tr(), 
            "${orderDetails.totalPrice} ${"egp".tr()}", isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.responsiveMargin * 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
              ? TextStyles.textViewBold16.copyWith(color: AppColors.textPrimary)
              : TextStyles.textViewRegular14.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: isTotal 
              ? TextStyles.textViewBold16.copyWith(color: AppColors.primary)
              : TextStyles.textViewMedium14.copyWith(
                  color: isDiscount ? AppColors.error : AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context, List<OrderPaymentModel> payments) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        children: [
          Text(
            "payment_info".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          ...payments.map((payment) => _buildPaymentItem(context, payment)),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(BuildContext context, OrderPaymentModel payment) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.responsiveMargin * 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.type,
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${"status_payment".tr()} : ${payment.status}',
                style: TextStyles.textViewRegular12.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            "${payment.amount} ${"egp".tr()}",
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(BuildContext context, OrderDetailsDataModel orderDetails) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        children: [
          Text(
            "delivery_address".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          Row(
            children: [
              Icon(
                Iconsax.map,
                color: AppColors.primary,
                size: context.responsiveIconSize * 1.2,
              ),
              SizedBox(width: context.responsiveMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderDetails.address.city,
                      style: TextStyles.textViewMedium14.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      orderDetails.address.street,
                      style: TextStyles.textViewRegular14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (orderDetails.address.details != null)
                      Text(
                        orderDetails.address.details!,
                        style: TextStyles.textViewRegular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isDeliveredOrder(String status) {
    return status.toLowerCase() == 'تم التسليم' || 
           status.toLowerCase() == 'delivered';
  }

  Widget _buildRatingButton(BuildContext context, OrderDetailsDataModel orderDetails) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showRatingBottomSheet(context, orderDetails),
        icon: Icon(
          Iconsax.star,
          color: Colors.white,
          size: context.responsiveIconSize * 1.2,
        ),
        label: Text(
          "rate_delivery".tr(),
          style: TextStyles.textViewBold16.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: context.responsiveMargin * 1.5,
            horizontal: context.responsivePadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.w),
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyRatedSection(BuildContext context, OrderDetailsDataModel orderDetails) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
      color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
       boxShadow: [BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 4,
        offset: const Offset(0, 1),
       )]
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.star_1,
            weight: 9.w,
            color: AppColors.warning,
            size: context.responsiveIconSize * 1.5,
          ),
          SizedBox(width: context.responsiveMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               if (orderDetails.rating['comment'] == null)  Text(
                  "already_rated".tr().isEmpty ? "Already Rated" : "already_rated".tr(),
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.success,
                  ),
                ),
              if (orderDetails.rating['comment'] != null)
                  Text(
                    "${"comment".tr().isEmpty ? "Comment" : "comment".tr()} : ${orderDetails.rating['comment']}",
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (orderDetails.rating != null)
                  Text(
                    "${"rating".tr().isEmpty ? "Rating" : "rating".tr()} : ${orderDetails.rating['rating']}/5",
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingBottomSheet(BuildContext context, OrderDetailsDataModel orderDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RatingBottomSheet(
        orderId: orderDetails.id,
        deliveryPersonName: "", 
        onRatingSubmitted: () {
          // Refresh order details to hide the rating button
          context.read<OrderDetailsCubit>().getOrderDetails(orderDetails.id);
        },
      ),
    );
  }
}
