import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

/// A custom app bar that integrates background image into the app bar shape
class CustomAppBarWithBackground extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final String? backgroundImagePath;
  final BoxFit backgroundImageFit;
  final Color? overlayColor;
  final double overlayOpacity;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool centerTitle;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? leading;
  final Widget? titleWidget;

  const CustomAppBarWithBackground({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.backgroundImagePath,
    this.backgroundImageFit = BoxFit.cover,
    this.overlayColor,
    this.overlayOpacity = 0.3,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.centerTitle = false,
    this.borderRadius,
    this.contentPadding,
    this.leading,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = kToolbarHeight + statusBarHeight;

    return Container(
      height: appBarHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius != null
            ? BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius!),
                bottomRight: Radius.circular(borderRadius!),
              )
            : null,
        image: backgroundImagePath != null
            ? DecorationImage(
                image: AssetImage(backgroundImagePath!),
                fit: backgroundImageFit,
                alignment: Alignment.topCenter,
              )
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius != null
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius!),
                  bottomRight: Radius.circular(borderRadius!),
                )
              : null,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (overlayColor ?? AppColors.black).withValues(
                alpha: overlayOpacity,
              ),
              (overlayColor ?? AppColors.black).withValues(
                alpha: overlayOpacity * 0.7,
              ),
              (overlayColor ?? AppColors.black).withValues(
                alpha: overlayOpacity * 0.5,
              ),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: kToolbarHeight,
            padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                // Leading Widget (Back Button or Custom)
                if (leading != null)
                  leading!
                else if (showBackButton)
                  _buildBackButton(context),

                // Title Section
                if (title != null || titleWidget != null) ...[
                  SizedBox(width: 4.w),
                  Expanded(
                    child: centerTitle
                        ? Center(child: titleWidget ?? _buildTitle(context))
                        : titleWidget ?? _buildTitle(context),
                  ),
                ] else
                  const Spacer(),

                // Actions
                if (actions != null) ...[...actions!],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onBackPressed ?? () => Navigator.of(context).pop(),
          child: Container(
            width: 12.w,
            height: 12.w,
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: ResponsiveUtils.getResponsiveIconSize(context) * 0.6,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title!,
      style: ResponsiveUtils.getResponsiveTextStyle(
        context,
        fontSize:
            titleFontSize ??
            ResponsiveUtils.getResponsiveFontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
        fontWeight: titleFontWeight ?? FontWeight.w600,
        color: titleColor ?? AppColors.white,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 44);
}

/// A simplified version for quick implementation
class BackgroundAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final String backgroundImagePath;
  final bool showBackButton;
  final Color? titleColor;

  const BackgroundAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    required this.backgroundImagePath,
    this.showBackButton = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWithBackground(
      title: title,
      onBackPressed: onBackPressed,
      showBackButton: showBackButton,
      backgroundImagePath: backgroundImagePath,
      titleColor: titleColor ?? AppColors.white,
      overlayColor: AppColors.black,
      overlayOpacity: 0.4,
      borderRadius: 20,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 44);
}
