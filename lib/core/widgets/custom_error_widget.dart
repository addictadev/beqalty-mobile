import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'primary_button.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final bool showRetryButton;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.responsiveIconSize,
              height: context.responsiveIconSize,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: ResponsiveUtils.getResponsiveTextStyle(
                context,
                fontSize: context.isMobile ? 14 : 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            if (showRetryButton && onRetry != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding * 6,
                ),
                child: PrimaryButton(
                  onPressed: onRetry,
                  text: retryText ?? 'retry'.tr(),
                  icon: Icons.refresh,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CompactErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBackground,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                size: 32,
                color: AppColors.error,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: ResponsiveUtils.getResponsiveTextStyle(
                  context,
                  fontSize: context.isMobile ? 12 : 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsivePadding * 6,
                  ),
                  child: PrimaryButton(
                    onPressed: onRetry,
                    text: 'retry'.tr(),
                    icon: Icons.refresh,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
