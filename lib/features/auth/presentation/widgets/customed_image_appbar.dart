import 'package:baqalty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomImageAppBar extends StatelessWidget {
  final String backgroundImagePath;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final Color backgroundColor;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final bool showHelpButton;
  final VoidCallback? onHelpPressed;
  final Gradient? overlayGradient;
  final BoxFit imageFit;
  final Alignment imageAlignment;

  const CustomImageAppBar({
    super.key,
    required this.backgroundImagePath,
    this.expandedHeight = 180.0,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor = Colors.transparent,
    this.title,
    this.actions,
    this.leading,
    this.onBackPressed,
    this.showBackButton = true,
    this.showHelpButton = true,
    this.onHelpPressed,
    this.overlayGradient,
    this.imageFit = BoxFit.cover,
    this.imageAlignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      elevation: 0,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,

      flexibleSpace: SafeArea(
        child: FlexibleSpaceBar(
          title: title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
          centerTitle: true,
          background: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImagePath),
                fit: imageFit,
                alignment: imageAlignment,
              ),
            ),
          ),
        ),
      ),

      leading: _buildBackButton(context),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
