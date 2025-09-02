// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ExitPopUp extends StatefulWidget {
  const ExitPopUp({super.key});

  @override
  State<ExitPopUp> createState() => _ExitPopUpState();
}

class _ExitPopUpState extends State<ExitPopUp> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Scale animation for the popup
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Fade animation for the background
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _exitApp() async {
    await _scaleController.reverse();
    await _fadeController.reverse();
    if (mounted) {
      exit(0);
    }
  }

  Future<void> _dismissDialog() async {
    await _scaleController.reverse();
    await _fadeController.reverse();
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: AppColors.overlayDark,
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildDialogContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final double dialogWidth = context.isMobile
        ? MediaQuery.of(context).size.width * 0.85
        : context.isTablet
        ? 400
        : 450;

    final double iconSize = context.responsiveIconSize * 2.5;
    final double borderRadius = context.responsiveBorderRadius * 2;
    final EdgeInsets padding = EdgeInsets.all(context.responsivePadding * 1.5);

    return Container(
      width: dialogWidth,
      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppIcon(context, iconSize),
            SizedBox(height: context.responsiveMargin * 2),
            _buildTitle(context),
            SizedBox(height: context.responsiveMargin * 2),
            _buildMessage(context),
            SizedBox(height: context.responsiveMargin * 3),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon(BuildContext context, double iconSize) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),

      child: CustomImageAsset(
        width: iconSize * 2,
        height: iconSize * 2,
        assetName: AppAssets.appIcon,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'exit_app_title'.tr(),
      style: ResponsiveUtils.getResponsiveTextStyle(
        context,
        fontSize: context.isMobile ? 18 : 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      'exit_app_message'.tr(),
      style: ResponsiveUtils.getResponsiveTextStyle(
        context,
        fontSize: context.isMobile ? 14 : 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final double buttonHeight = context.responsiveButtonHeight / 2;
    final double spacing = context.responsiveMargin;
    final double borderRadius = context.responsiveBorderRadius;

    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(context, buttonHeight, borderRadius),
        ),
        SizedBox(width: spacing),
        Expanded(child: _buildExitButton(context, buttonHeight, borderRadius)),
      ],
    );
  }

  Widget _buildCancelButton(
    BuildContext context,
    double height,
    double borderRadius,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: _dismissDialog,
          child: Center(
            child: Text(
              'cancel'.tr(),
              style: ResponsiveUtils.getResponsiveTextStyle(
                context,
                fontSize: context.isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton(
    BuildContext context,
    double height,
    double borderRadius,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: _exitApp,
          child: Center(
            child: Text(
              'exit'.tr(),
              style: ResponsiveUtils.getResponsiveTextStyle(
                context,
                fontSize: context.isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
