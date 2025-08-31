import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class PromotionalCard extends StatelessWidget {
  final VoidCallback? onPlaceOrderTap;
  final String? title;
  final String? buttonText;

  const PromotionalCard({
    super.key,
    this.onPlaceOrderTap,
    this.title,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background food pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(painter: FoodPatternPainter()),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Row(
              children: [
                // Character illustration
                _buildCharacterIllustration(),

                SizedBox(width: context.responsivePadding),

                // Text and button
                Expanded(child: _buildContentSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterIllustration() {
    return CustomSvgImage(
      assetName: AppAssets.authLoginBackground,
      width: 80,
      height: 80,
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          title ?? "free_delivery_title".tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            height: 1.2,
          ),
        ),

        SizedBox(height: 16),

        // Place Order button
        _buildPlaceOrderButton(),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return GestureDetector(
      onTap: onPlaceOrderTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          buttonText ?? "place_order".tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// Custom painter for food pattern background
class FoodPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw various food icons as simple shapes
    _drawDonut(canvas, Offset(size.width * 0.1, size.height * 0.2), paint);
    _drawPizzaSlice(canvas, Offset(size.width * 0.8, size.height * 0.1), paint);
    _drawStrawberry(canvas, Offset(size.width * 0.9, size.height * 0.3), paint);
    _drawBurger(canvas, Offset(size.width * 0.7, size.height * 0.4), paint);
    _drawPopcorn(canvas, Offset(size.width * 0.2, size.height * 0.7), paint);
    _drawBroccoli(canvas, Offset(size.width * 0.85, size.height * 0.6), paint);
    _drawFish(canvas, Offset(size.width * 0.3, size.height * 0.8), paint);
    _drawCarrot(canvas, Offset(size.width * 0.6, size.height * 0.2), paint);
    _drawEggplant(canvas, Offset(size.width * 0.4, size.height * 0.5), paint);
    _drawCup(canvas, Offset(size.width * 0.1, size.height * 0.6), paint);
  }

  void _drawDonut(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 8, paint);
    canvas.drawCircle(center, 4, Paint()..color = AppColors.primary);
  }

  void _drawPizzaSlice(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 8, center.dy - 8);
    path.lineTo(center.dx + 12, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStrawberry(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 6, paint);
    // Add small dots for seeds
    final seedPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(center.dx - 2, center.dy - 2), 1, seedPaint);
    canvas.drawCircle(Offset(center.dx + 2, center.dy + 1), 1, seedPaint);
  }

  void _drawBurger(Canvas canvas, Offset center, Paint paint) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 16, height: 8),
      Radius.circular(2),
    );
    canvas.drawRRect(rect, paint);
  }

  void _drawPopcorn(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 6, paint);
    canvas.drawCircle(Offset(center.dx - 3, center.dy - 3), 3, paint);
    canvas.drawCircle(Offset(center.dx + 3, center.dy - 2), 3, paint);
  }

  void _drawBroccoli(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 6, paint);
    canvas.drawCircle(Offset(center.dx - 3, center.dy - 3), 3, paint);
    canvas.drawCircle(Offset(center.dx + 3, center.dy - 2), 3, paint);
  }

  void _drawFish(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 8, center.dy);
    path.lineTo(center.dx + 8, center.dy - 4);
    path.lineTo(center.dx + 8, center.dy + 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCarrot(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - 8);
    path.lineTo(center.dx + 4, center.dy + 8);
    path.lineTo(center.dx - 4, center.dy + 8);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawEggplant(Canvas canvas, Offset center, Paint paint) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 12, height: 16),
      Radius.circular(6),
    );
    canvas.drawRRect(rect, paint);
  }

  void _drawCup(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6, center.dy - 4);
    path.lineTo(center.dx + 6, center.dy - 4);
    path.lineTo(center.dx + 8, center.dy + 4);
    path.lineTo(center.dx - 8, center.dy + 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
