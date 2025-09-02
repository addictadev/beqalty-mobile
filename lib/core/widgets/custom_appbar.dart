import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../images_preview/app_assets.dart';
import '../images_preview/custom_asset_img.dart';
import 'package:sizer/sizer.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final double elevation;
  final bool centerTitle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? titleSpacing;
  final TextStyle? titleStyle;
  final double height;
  final bool centerLogo;
  final String? logoAssetPath;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.systemOverlayStyle,
    this.titleSpacing,
    this.titleStyle,
    this.height = 56,
    this.centerLogo = false,
    this.logoAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = backgroundColor ?? Colors.transparent;
    final defaultIconColor = iconColor ?? AppColors.textPrimary;
    final defaultTitleColor = titleColor ?? AppColors.textPrimary;

    return AppBar(
      systemOverlayStyle: _buildSystemOverlayStyle(),
      backgroundColor: defaultBackgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      title: _buildTitle(theme, defaultTitleColor),
      leading: _buildActions(context, defaultIconColor),
    );
  }

  SystemUiOverlayStyle _buildSystemOverlayStyle() {
    return systemOverlayStyle ??
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        );
  }

  Widget? _buildTitle(ThemeData theme, Color defaultTitleColor) {
    if (centerLogo) {
      return _buildCenterLogo();
    }

    if (titleWidget != null) {
      return titleWidget;
    }

    if (title != null) {
      return Text(
        title!,
        style:
            titleStyle ??
            theme.textTheme.titleLarge?.copyWith(
              color: defaultTitleColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
      );
    }

    return null;
  }

  Widget _buildCenterLogo() {
    return CustomImageAsset(
      assetName: logoAssetPath ?? AppAssets.appIcon,
      height: 4.h,
    );
  }

  _buildActions(BuildContext context, Color defaultIconColor) {
    if (actions != null) {
      return actions;
    }

    if (!showBackButton) {
      return null;
    }

    return _buildBackButton(context, defaultIconColor);
  }

  Widget _buildBackButton(BuildContext context, Color defaultIconColor) {
    return CustomBackButton(icon: Icons.chevron_left, size: 30);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
