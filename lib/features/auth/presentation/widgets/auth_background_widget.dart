import 'package:flutter/material.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class AuthBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double backgroundHeight;
  final BoxFit backgroundFit;
  final Alignment backgroundAlignment;
  final Color? overlayColor;
  final double overlayOpacity;

  const AuthBackgroundWidget({
    super.key,
    required this.child,
    this.backgroundHeight = 200,
    this.backgroundFit = BoxFit.cover,
    this.backgroundAlignment = Alignment.topCenter,
    this.overlayColor,
    this.overlayOpacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Background image at bottom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: backgroundHeight,
              width: double.infinity,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(AppAssets.authBackground),
              //     fit: backgroundFit,
              //     alignment: Alignment.bottomCenter,
              //     colorFilter: ColorFilter.mode(
              //       AppColors.backButtonColor,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              // ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         AppColors.scaffoldBackground,
              //         AppColors.scaffoldBackground.withOpacity(0.8),
              //         (overlayColor ?? AppColors.white).withOpacity(overlayOpacity * 0.3),
              //         (overlayColor ?? AppColors.white).withOpacity(overlayOpacity * 0.7),
              //         (overlayColor ?? AppColors.white).withOpacity(overlayOpacity),
              //       ],
              //       stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
              //     ),
              //   ),
              // ),
            ),
          ),
        
        
          // Content section
          child,
        ],
      ),
    );
  }
}
