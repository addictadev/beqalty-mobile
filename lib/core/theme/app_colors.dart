import 'package:flutter/material.dart';

class AppColors {
  // Existing colors
  static const Color primary = Color(0xFF2D3043);
  static const Color primaryLight = Color(0xFF44AAFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color overlayLight = Color(0x33000000);
  static const Color overlayDark = Color(0x66000000);
  static const Color overlayQueue = Color(0xFFF6F7FD);
  static const Color overlayGray = Color(0xFFF6F7FD);
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color bgProfile = Color(0xFFE9E9FF);
  // Extended colors for forms and UI
  static const Color scaffoldBackground = Color(0xFFF5F7FF);
  static const Color scaffoldColor = Color(0xFFF8F9FA);
  static const Color inputBackground = Color(0xFFFFFFFF);

  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFFD1D5DB);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color pending = Color(0xFFFFC107);
  static const Color info = Color(0xFF3B82F6);

  // Card and surface colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0D000000);

  // Chat-specific colors
  static const Color chatBackgroundGradientTop = Color(0xFFE0F2F7);
  static const Color chatBackgroundGradientBottom = Color(0xFFC8E6F0);
  static const Color chatSenderBubble = Color(0xFF1A237E);
  static const Color chatReceiverBubble = Color(0xFFFFFFFF);
  static const Color chatTimestamp = Color(0xFFA0A0A0);
  static const Color chatInputBackground = Color(0xFFFFFFFF);
  static const Color chatButtonBlue = Color(0xFF42A5F5);
  static const Color chatSpecialButton = Color(0xFFADD8E6);
  static const Color chatCircularButton = Color(0xFFE0E0E0);
  static const Color messagebackColor = Color(0xFF060C32);

  // Login screen specific colors
  static const Color loginButtonColor = Color(0xFF424242); // Dark grey button
  static const Color loginBackground = Color(0xFFF8F9FA); // Light background
  static const Color foodDoodleColor = Color(
    0xFFE0E0E0,
  ); // Light grey for food doodles
  static const Color characterShirtColor = Color(0xFF1976D2); // Dark blue shirt
  static const Color characterApronColor = Color(0xFFE53935); // Red apron
  static const Color characterSkinColor = Color(0xFFFFE0B2); // Skin tone
  static const Color backButtonColor = Color(
    0xFFE0E0E0,
  ); // Light grey back button

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight, primary],
    stops: [0.0, 0.5, 1.0],
  );

  // Chat background gradient
  static const LinearGradient chatBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [chatBackgroundGradientTop, chatBackgroundGradientBottom],
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Home background gradient colors
  static const Color homeGradientBlue = Color(0x7A1195F7); // #1195F77A
  static const Color homeGradientCyan = Color(0x57C1E2ED); // #C1E2ED57
  static const Color homeGradientWhite = Color(0xFFF5F5F5); // #F5F5F5

  static const LinearGradient homeBackgroundGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [homeGradientBlue, homeGradientCyan, homeGradientWhite],
    stops: [0.0, 0.48, 1.0],
  );

  // Welcome screen colors
  static const Color welcomeBackground = Color(0xFFF8F5FF);
  static const Color welcomeTextPrimary = Color(0xFF424242);
  static const Color welcomeTextSecondary = Color(0xFF666666);
  static const Color characterSkinTone = Color(0xFFFFE0B2);
  static const Color characterShirt = Color(0xFF1976D2);
  static const Color characterApron = Color(0xFFE53935);
  static const Color characterHalo = Color(0xFFFFF8E1);

  // App specific colors
  static const Color appBackground = Color(
    0xFFF8F5FF,
  ); // Light purple background
  static const Color appHeaderBackground = Color(
    0xFF2D3043,
  ); // Dark purple header

  // Tracking screen specific colors
  static const Color trackingDarkBlue = Color(
    0xFF1E3A8A,
  ); // Dark blue for icons and active states
  static const Color trackingLightGray = Color(
    0xFFF3F4F6,
  ); // Light gray for map background
  static const Color trackingMediumGray = Color(
    0xFF9CA3AF,
  ); // Medium gray for secondary text
  static const Color trackingDarkGray = Color(
    0xFF374151,
  ); // Dark gray for main text
  static const Color trackingProgressActive = Color(
    0xFF1E3A8A,
  ); // Dark blue for active progress segments
  static const Color trackingProgressInactive = Color(
    0xFFE5E7EB,
  ); // Light gray for inactive progress segments
  static const Color trackingCardShadow = Color(
    0x1A000000,
  ); // Subtle shadow for cards
}
