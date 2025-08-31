import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:flash/flash.dart';
import '../navigation_services/navigation_manager.dart';

enum MessageType { success, error, warning, info }

class ToastHelper {
  static Future<void> showToast(
    String description, {
    String? title,
    int duration = 5,
    MessageType type = MessageType.error,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
    EdgeInsets? margin,
    FlashPosition? position,
  }) async {
    if (description.isEmpty) return;

    return showFlash(
      context: NavigationManager.getContext(),
      builder: (context, controller) {
        return FlashBar(
          controller: controller,
          position: position ?? FlashPosition.top,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin:
              margin ??
              EdgeInsets.symmetric(
                horizontal: _getResponsiveHorizontalMargin(),
                vertical: _getResponsiveVerticalMargin(),
              ),
          content: _buildToastContent(
            title ?? '',
            description,
            type,
            controller,
            showIcon: showIcon,
            showCloseButton: showCloseButton,
            autoDismiss: autoDismiss,
            showTitle: showTitle,
          ),
        );
      },
      duration: autoDismiss ? const Duration(seconds: 4) : null,
    );
  }

  static Widget _buildToastContent(
    String title,
    String description,
    MessageType type,
    FlashController controller, {
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(type),
            blurRadius: _getShadowBlur(),
            offset: Offset(0, _getShadowOffset()),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        child: Container(
          decoration: BoxDecoration(
            gradient: _getGradient(type),
            border: Border.all(
              color: _getBorderColor(type),
              width: _getBorderWidth(),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showIcon) ...[
                  SizedBox(
                    width: _getIconContainerSize(),
                    height: _getIconContainerSize(),
                    child: Icon(
                      _getIcon(type),
                      color: _getIconColor(type),
                      size: _getIconSize(),
                    ),
                  ),
                  SizedBox(width: _getIconSpacing()),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: _getDescriptionFontSize(),
                          fontWeight: FontWeight.w400,
                          color: AppColors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                        maxLines: _getMaxLines(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: _getIconSpacing()),
                    ],
                  ),
                ),
                if (showCloseButton) ...[
                  SizedBox(width: _getCloseButtonSpacing()),
                  GestureDetector(
                    onTap: () => controller.dismiss(),
                    child: SizedBox(
                      width: _getCloseButtonSize(),
                      height: _getCloseButtonSize(),
                      child: Icon(
                        Iconsax.close_square,
                        color: AppColors.white,
                        size: _getCloseButtonIconSize(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static double _getResponsiveHorizontalMargin() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 1.w;
    if (screenWidth > 768) return 1.w;
    return 1.w;
  }

  static double _getResponsiveVerticalMargin() {
    double screenHeight = 100.h;
    if (screenHeight < 600) return 0.5.h;
    if (screenHeight > 900) return 0.5.h;
    return 0.5.h;
  }

  static double _getBorderRadius() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 12;
    if (screenWidth > 768) return 20;
    return 16;
  }

  static double _getBorderWidth() {
    return 1;
  }

  static double _getShadowBlur() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 15;
    if (screenWidth > 768) return 25;
    return 20;
  }

  static double _getShadowOffset() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 6;
    if (screenWidth > 768) return 10;
    return 8;
  }

  static double _getIconContainerSize() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 10.w;
    if (screenWidth > 768) return 14.w;
    return 12.w;
  }

  static double _getIconSize() {
    double screenWidth = 100.w;
    double baseSize = _getIconContainerSize() * 0.5;
    if (screenWidth < 360) return baseSize * 0.9;
    if (screenWidth > 768) return baseSize * 1.1;
    return baseSize;
  }

  static double _getIconSpacing() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 2.5.w;
    if (screenWidth > 768) return 4.w;
    return 3.w;
  }

  static double _getDescriptionFontSize() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 16.sp;
    if (screenWidth > 768) return 18.sp;
    return 16.sp;
  }

  static double _getCloseButtonSize() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 8.w;
    if (screenWidth > 768) return 10.w;
    return 9.w;
  }

  static double _getCloseButtonIconSize() {
    return _getCloseButtonSize() * 0.5;
  }

  static double _getCloseButtonSpacing() {
    double screenWidth = 100.w;
    if (screenWidth < 360) return 2.w;
    if (screenWidth > 768) return 3.w;
    return 2.5.w;
  }

  static int _getMaxLines() {
    double screenHeight = 100.h;
    if (screenHeight < 600) return 2;
    if (screenHeight > 900) return 4;
    return 3;
  }

  static IconData _getIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Iconsax.tick_circle;
      case MessageType.error:
        return Iconsax.info_circle;
      case MessageType.warning:
        return Iconsax.warning_2;
      case MessageType.info:
        return Iconsax.info_circle;
    }
  }

  static LinearGradient _getGradient(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, Color(0xFF059669)],
        );
      case MessageType.error:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.error, Color(0xFFDC2626)],
        );
      case MessageType.warning:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.warning, Color(0xFFD97706)],
        );
      case MessageType.info:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.info, Color(0xFF2563EB)],
        );
    }
  }

  static Color _getBorderColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return AppColors.success;
      case MessageType.error:
        return AppColors.error;
      case MessageType.warning:
        return AppColors.warning;
      case MessageType.info:
        return AppColors.info;
    }
  }

  static Color _getShadowColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return AppColors.success.withValues(alpha: 0.3);
      case MessageType.error:
        return AppColors.error.withValues(alpha: 0.3);
      case MessageType.warning:
        return AppColors.warning.withValues(alpha: 0.3);
      case MessageType.info:
        return AppColors.info.withValues(alpha: 0.3);
    }
  }

  static Color _getIconColor(MessageType type) {
    return AppColors.white;
  }

  static Future<void> showSuccessToast(
    String description, {
    String? title,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
    EdgeInsets? margin,
  }) async {
    return showToast(
      position: FlashPosition.bottom,
      description,
      title: title,
      type: MessageType.success,
      showIcon: showIcon,
      showCloseButton: showCloseButton,
      autoDismiss: autoDismiss,
      showTitle: showTitle,
      margin: margin,
    );
  }

  static Future<void> showErrorToast(
    String description, {
    String? title,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
    EdgeInsets? margin,
  }) async {
    return showToast(
      description,
      title: title,
      type: MessageType.error,
      showIcon: showIcon,
      showCloseButton: showCloseButton,
      autoDismiss: autoDismiss,
      showTitle: showTitle,
      margin: margin,
    );
  }

  static Future<void> showWarningToast(
    String description, {
    String? title,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
    EdgeInsets? margin,
  }) async {
    return showToast(
      description,
      title: title,
      type: MessageType.warning,
      showIcon: showIcon,
      showCloseButton: showCloseButton,
      autoDismiss: autoDismiss,
      showTitle: showTitle,
      margin: margin,
    );
  }

  static Future<void> showInfoToast(
    String description, {
    String? title,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
    EdgeInsets? margin,
  }) async {
    return showToast(
      description,
      title: title,
      type: MessageType.info,
      showIcon: showIcon,
      showCloseButton: showCloseButton,
      autoDismiss: autoDismiss,
      showTitle: showTitle,
      margin: margin,
    );
  }

  static Future<void> showToastAtPosition(
    String description,
    MessageType type, {
    String? title,
    FlashPosition position = FlashPosition.top,
    EdgeInsets? margin,
    bool showIcon = true,
    bool showCloseButton = true,
    bool autoDismiss = true,
    bool showTitle = true,
  }) async {
    if (description.isEmpty) return;

    return showFlash(
      context: NavigationManager.getContext(),
      builder: (context, controller) {
        return FlashBar(
          controller: controller,
          position: position,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin:
              margin ??
              EdgeInsets.symmetric(
                horizontal: _getResponsiveHorizontalMargin(),
                vertical: _getResponsiveVerticalMargin(),
              ),
          content: _buildToastContent(
            title ?? '',
            description,
            type,
            controller,
            showIcon: showIcon,
            showCloseButton: showCloseButton,
            autoDismiss: autoDismiss,
            showTitle: showTitle,
          ),
        );
      },
      duration: autoDismiss ? const Duration(seconds: 4) : null,
    );
  }
}

Widget loadingIndicator = Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
  ),
);
