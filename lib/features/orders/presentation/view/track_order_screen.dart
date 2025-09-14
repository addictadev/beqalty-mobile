import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/features/orders/business/models/order_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackOrderScreen extends StatefulWidget {
  final OrderModel order;

  const TrackOrderScreen({
    super.key,
    required this.order,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final int _estimatedMinutes = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            CustomAppBar(
              title: "track_order".tr(),
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            ),

            // Map View
            Expanded(
              flex: 3,
              child: _buildMapView(context),
            ),

            // Status Panel
            Expanded(
              flex: 2,
              child: _buildStatusPanel(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
        child:   Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.mapImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      ),
    );
  }


  Widget _buildStatusPanel(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          SizedBox(height: context.responsiveMargin),

          // Progress Indicator
          _buildProgressIndicator(context),

          SizedBox(height: context.responsiveMargin * 1.5),

          // Delivery Status Card
          _buildDeliveryStatusCard(context),

          SizedBox(height: context.responsiveMargin),

          // Driver Information
          _buildDriverInfo(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          "$_estimatedMinutes ${"minutes_left".tr()}",
          style: TextStyles.textViewBold20.copyWith(
            color: AppColors.textPrimary,
            fontSize: FontSizes.s20,
          ),
        ),
        SizedBox(height: context.responsiveMargin * 0.5),
        Text(
          "delivery_to".tr(),
          style: TextStyles.textViewMedium14.copyWith(
            color: AppColors.textSecondary,
            fontSize: FontSizes.s14,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(0.25.h),
            ),
          ),
        ),
        SizedBox(width: context.responsiveMargin * 0.5),
        Expanded(
          child: Container(
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(0.25.h),
            ),
          ),
        ),
        SizedBox(width: context.responsiveMargin * 0.5),
        Expanded(
          child: Container(
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(0.25.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryStatusCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Delivery Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
              shape: BoxShape.circle,
            ),
            child: CustomSvgImage(
              assetName: AppAssets.deliveryIcon,
              width: 6.w,
              height: 6.w,
            ),
          ),

          SizedBox(width: context.responsiveMargin),

          // Status Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "delivered_your_order".tr(),
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: FontSizes.s16,
                  ),
                ),
                SizedBox(height: context.responsiveMargin * 0.5),
                Text(
                  "delivery_message".tr(),
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: FontSizes.s14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,

        boxShadow: [
     
        ],
      ),
      child: Row(
        children: [
          // Driver Avatar
          Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CustomImageAsset(
              assetName: AppAssets.appIcon,
            ),
          ),

          SizedBox(width: context.responsiveMargin),

          // Driver Name
          Expanded(
            child: Text(
              "driver_name".tr(),
              style: TextStyles.textViewBold16.copyWith(
                color: AppColors.textPrimary,
                fontSize: FontSizes.s16,
              ),
            ),
          ),

          // Call Button
          GestureDetector(
            onTap: _callDriver,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                
                border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1),
              ),
              child: Icon(
                Iconsax.call,
                color: AppColors.primary,
                size: 6.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callDriver() {
//url launch
  launchUrl(Uri.parse('tel:01010300353'));
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Create a curved route from driver location to destination
    path.moveTo(size.width * 0.8, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      size.width * 0.2,
      size.height * 0.8,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
