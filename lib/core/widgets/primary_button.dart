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

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.borderRadius = 28,
    this.textStyle,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
            AppColors.primary,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        text,
                        style: textStyle ??
                            theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize ?? 16,
                            ),
                      ),
                      if (isLoading) ...[
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: loadingWidget ??
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                ),
                if (!isLoading)
                  Icon(
                    icon ?? Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
