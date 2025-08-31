import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: "abdallah@addicta.com",
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: Stack(
        children: [
          // Background food pattern
          _buildBackgroundPattern(),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),

                          // Back button
                          _buildBackButton(),

                          SizedBox(height: 32),

                          // Title and description
                          _buildTitleSection(),

                          SizedBox(height: 48),

                          // Email field
                          _buildEmailField(),

                          SizedBox(height: 32),

                          // Send Code button
                          _buildSendCodeButton(),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Login link at bottom
                  _buildLoginLink(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned(
      top: 0,
      right: 0,
      child: SizedBox(
        width: 120.w,
        height: 40.h,
        child: CustomPaint(painter: FoodPatternPainter()),
      ),
    );
  }

  Widget _buildBackButton() {
    return CustomBackButton(
      backgroundColor: AppColors.backButtonColor,
      iconColor: AppColors.black,
      icon: Icons.chevron_left,
      size: 40,
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "forgot_password_title".tr(),
          style: GoogleFonts.robotoFlex(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),

        SizedBox(height: 12),

        Text(
          "forgot_password_description".tr(),
          style: GoogleFonts.robotoFlex(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      label: "email".tr(),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      borderRadius: 8,
    );
  }

  Widget _buildSendCodeButton() {
    return PrimaryButton(
      text: "send_code".tr(),
      onPressed: () {
        // Handle send code
      },
      color: AppColors.loginButtonColor,
      borderRadius: 8,
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.robotoFlex(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(text: "remember_password".tr()),
            TextSpan(
              text: "login".tr(),
              style: GoogleFonts.robotoFlex(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
          ],
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
      ..color = AppColors.foodDoodleColor
      ..style = PaintingStyle.fill;

    // Draw various food icons as simple shapes
    _drawPizzaSlice(canvas, Offset(size.width * 0.8, size.height * 0.1), paint);
    _drawStrawberry(canvas, Offset(size.width * 0.9, size.height * 0.2), paint);
    _drawBurger(canvas, Offset(size.width * 0.7, size.height * 0.15), paint);
    _drawCheese(canvas, Offset(size.width * 0.85, size.height * 0.25), paint);
    _drawDonut(canvas, Offset(size.width * 0.75, size.height * 0.3), paint);
    _drawBroccoli(canvas, Offset(size.width * 0.95, size.height * 0.35), paint);
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
    final seedPaint = Paint()..color = AppColors.white;
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

  void _drawCheese(Canvas canvas, Offset center, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6, center.dy);
    path.lineTo(center.dx + 6, center.dy - 4);
    path.lineTo(center.dx + 6, center.dy + 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDonut(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 8, paint);
    canvas.drawCircle(center, 4, Paint()..color = AppColors.loginBackground);
  }

  void _drawBroccoli(Canvas canvas, Offset center, Paint paint) {
    canvas.drawCircle(center, 6, paint);
    canvas.drawCircle(Offset(center.dx - 3, center.dy - 3), 3, paint);
    canvas.drawCircle(Offset(center.dx + 3, center.dy - 2), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
