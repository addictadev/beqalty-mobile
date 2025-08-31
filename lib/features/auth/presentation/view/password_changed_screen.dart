import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'login_screen.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() => _PasswordChangedScreenState();
}

class _PasswordChangedScreenState extends State<PasswordChangedScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep blue
              Color(0xFF3949AB), // Medium blue
              Color(0xFF5E35B1), // Purple
            ],
          ),
        ),
        child: Stack(
          children: [
            // Confetti-like background shapes
            ..._buildConfettiShapes(),
            
            // Main content
            SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildSuccessCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConfettiShapes() {
    return [
      // Green triangle
      Positioned(
        top: 0.1.h,
        left: 0.1.w,
        child: Transform.rotate(
          angle: 0.5,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      // Pink circle
      Positioned(
        top: 0.15.h,
        right: 0.1.w,
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
      // Yellow square
      Positioned(
        top: 0.25.h,
        left: 0.2.w,
        child: Transform.rotate(
          angle: 0.3,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
      // Light blue squiggle
      Positioned(
        top: 0.3.h,
        right: 0.25.w,
        child: Container(
          width: 25,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // More shapes for variety
      Positioned(
        bottom: 0.2.h,
        left: 0.15.w,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        bottom: 0.3.h,
        right: 0.1.w,
        child: Transform.rotate(
          angle: -0.4,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildSuccessCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.white,
              size: 40,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Title
          Text(
            "password_changed".tr(),
            style: GoogleFonts.robotoFlex(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 2.h),
          
          // Description
          Text(
            "password_changed_success".tr(),
            style: GoogleFonts.robotoFlex(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 5.h),
          
          // Back to login button
          PrimaryButton(
            text: "back_to_login".tr(),
            onPressed: () {
              NavigationManager.navigateToAndFinish(LoginScreen());
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
