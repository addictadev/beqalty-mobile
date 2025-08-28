import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ResponsiveUtils {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Device type helpers
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint &&
        MediaQuery.of(context).size.width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Responsive spacing
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 4.w;
    if (isTablet(context)) return 6.w;
    return 8.w;
  }

  static double getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) return 2.w;
    if (isTablet(context)) return 3.w;
    return 4.w;
  }

  // Responsive font sizes
  static double getResponsiveFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) return mobile ?? 4.w;
    if (isTablet(context)) return tablet ?? 5.w;
    return desktop ?? 6.w;
  }

  // Responsive grid helpers
  static int getResponsiveGridCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static double getResponsiveAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.2;
    if (isTablet(context)) return 1.5;
    return 1.8;
  }

  // Responsive icon sizes
  static double getResponsiveIconSize(BuildContext context) {
    if (isMobile(context)) return 6.w;
    if (isTablet(context)) return 8.w;
    return 10.w;
  }

  // Responsive button heights
  static double getResponsiveButtonHeight(BuildContext context) {
    if (isMobile(context)) return 12.h;
    if (isTablet(context)) return 10.h;
    return 8.h;
  }

  // Responsive card padding
  static EdgeInsets getResponsiveCardPadding(BuildContext context) {
    if (isMobile(context)) return EdgeInsets.all(4.w);
    if (isTablet(context)) return EdgeInsets.all(5.w);
    return EdgeInsets.all(6.w);
  }

  // Responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    if (isMobile(context)) return 3.w;
    if (isTablet(context)) return 4.w;
    return 5.w;
  }

  // Responsive container heights
  static double getResponsiveContainerHeight(BuildContext context) {
    if (isMobile(context)) return 20.h;
    if (isTablet(context)) return 25.h;
    return 30.h;
  }

  // Responsive width
  static double getResponsiveWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Orientation helpers
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Responsive text styles
  static TextStyle getResponsiveTextStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? getResponsiveFontSize(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      fontFamily: fontFamily ?? GoogleFonts.cairo().fontFamily,
    );
  }

  // Responsive spacing widgets
  static Widget responsiveSpacing(BuildContext context) {
    return SizedBox(height: getResponsiveMargin(context));
  }

  static Widget responsiveVerticalSpacing(BuildContext context) {
    return SizedBox(height: getResponsiveMargin(context) * 2);
  }

  static Widget responsiveHorizontalSpacing(BuildContext context) {
    return SizedBox(width: getResponsiveMargin(context));
  }
}

// Extension methods for easier responsive design
extension ResponsiveExtensions on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isPortrait => ResponsiveUtils.isPortrait(this);
  bool get isLandscape => ResponsiveUtils.isLandscape(this);

  double get responsivePadding => ResponsiveUtils.getResponsivePadding(this);
  double get responsiveMargin => ResponsiveUtils.getResponsiveMargin(this);
  double get responsiveIconSize => ResponsiveUtils.getResponsiveIconSize(this);
  double get responsiveButtonHeight =>
      ResponsiveUtils.getResponsiveButtonHeight(this);
  double get responsiveBorderRadius =>
      ResponsiveUtils.getResponsiveBorderRadius(this);
  double get responsiveContainerHeight =>
      ResponsiveUtils.getResponsiveContainerHeight(this);
  double get responsiveWidth => ResponsiveUtils.getResponsiveWidth(this);

  int get responsiveGridCount => ResponsiveUtils.getResponsiveGridCount(this);
  double get responsiveAspectRatio =>
      ResponsiveUtils.getResponsiveAspectRatio(this);
}
