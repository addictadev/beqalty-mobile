import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final double borderWidth;

  const BorderedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.borderColor,
    this.textColor,
    this.borderRadius = 28,
    this.textStyle,
    this.width,
    this.height,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.white,
          width: borderWidth,
        ),
        // Transparent background
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: (borderColor ?? AppColors.white).withValues(alpha: 0.1),
          highlightColor: (borderColor ?? AppColors.white).withValues(
            alpha: 0.05,
          ),
          onTap: loading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: loading
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: textColor ?? AppColors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text,
                        style:
                            textStyle ??
                            theme.textTheme.labelLarge?.copyWith(
                              color: textColor ?? AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
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
