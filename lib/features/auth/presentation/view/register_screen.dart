import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Abdallah Ibrahim",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+01026329736",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "abdallah@addicta.com",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "************",
  );
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: "************");

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),

                      _buildBackButton(),

                      SizedBox(height: 24),

                      _buildWelcomeSection(),

                      SizedBox(height: 48),

                      _buildFormFields(),

                      SizedBox(height: 32),

                      _buildRegisterButton(),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              _buildLoginLink(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return CustomBackButton(
      iconColor: AppColors.black,
      icon: Icons.chevron_left,
      size: 40,
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        _buildCharacterIllustration(),

        SizedBox(width: 16),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.robotoFlex(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
                fontStyle: FontStyle.italic,
              ),
              children: [
                TextSpan(text: "hello_register".tr()),
                const TextSpan(text: "\n"),
                TextSpan(text: "to_get_started".tr()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterIllustration() {
    return CustomSvgImage(
      assetName: AppAssets.authLoginBackground,
      width: 30.w,
      height: 30.w,
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextFormField(
          label: "name".tr(),
          controller: _nameController,
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 20),

        CustomTextFormField(
          label: "phone_number".tr(),
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 20),

        CustomTextFormField(
          label: "email".tr(),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 20),

        CustomTextFormField(
          label: "password".tr(),
          controller: _passwordController,
          obscureText: true,
          showVisibilityToggle: true,
          textInputAction: TextInputAction.next,
        ),

        SizedBox(height: 20),

        CustomTextFormField(
          label: "confirm_password".tr(),
          controller: _confirmPasswordController,
          obscureText: true,
          showVisibilityToggle: true,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return PrimaryButton(text: "register".tr(), onPressed: () {});
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
            TextSpan(text: "already_have_account".tr()),
            TextSpan(
              text: "login_now".tr(),
              style: GoogleFonts.robotoFlex(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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

class FoodPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.foodDoodleColor
      ..style = PaintingStyle.fill;

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
