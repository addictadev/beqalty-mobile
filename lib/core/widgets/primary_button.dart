import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double borderRadius;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool showIcon;
  final EdgeInsets? margin;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.margin,
    this.color,
    this.borderRadius = 30,
    this.textStyle,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
    this.loadingWidget,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: width ?? double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color ?? AppColors.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        loadingWidget ??
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  text,
                  style:
                      textStyle ??
                      theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize ?? 16,
                      ),
                ),
                if (showIcon && !isLoading && icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: AppColors.white, size: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
