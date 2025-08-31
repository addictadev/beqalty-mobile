# Auth Background Widget

The `AuthBackgroundWidget` is a reusable widget that provides a consistent background for all authentication screens in the app.

## Features

- Displays the `AppAssets.authBackground` image at the bottom of auth screens
- Provides a smooth gradient overlay that transitions from the app's background color to the image
- Customizable height, overlay opacity, and alignment
- Maintains consistent styling across all auth screens

## Usage

```dart
import '../widgets/auth_background_widget.dart';

class YourAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      backgroundHeight: 180, // Height of the background image section
      overlayOpacity: 0.15,  // Opacity of the overlay gradient
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
          child: Column(
            children: [
              // Your auth screen content here
              CustomBackButton(),
              // ... other widgets
            ],
          ),
        ),
      ),
    );
  }
}
```

## Parameters

- `child` (required): The main content of your auth screen
- `backgroundHeight` (optional): Height of the background image section (default: 200)
- `backgroundFit` (optional): How the background image should be fitted (default: BoxFit.cover)
- `backgroundAlignment` (optional): Alignment of the background image (default: Alignment.bottomCenter)
- `overlayColor` (optional): Color for the overlay gradient (default: AppColors.white)
- `overlayOpacity` (optional): Opacity of the overlay gradient (default: 0.1)

## Current Implementation

This widget is currently used in:
- `LoginScreen`
- `RegisterScreen`
- `ForgotPasswordScreen`
- `OtpVerificationScreen`
- `CreateNewPasswordScreen`

## Background Image

The widget uses `AppAssets.authBackground` which points to `assets/images/auth_background.png`. This image contains a subtle food-themed pattern that provides a welcoming visual element for authentication screens.
