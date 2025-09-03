# Change Password Feature

This feature implements a Change Password screen based on the attached image design, allowing users to securely change their password with proper validation.

## Features

- **Clean Modern UI**: Implements a responsive design with clean, modern aesthetics matching the attached image
- **Three Password Fields**: Old password, new password, and retype new password
- **Real-time Validation**: Instant feedback on password requirements and matching
- **Responsive Design**: Uses the project's responsive utilities for consistent spacing and sizing
- **Localization**: Supports both English and Arabic languages
- **Form Validation**: Comprehensive validation with user-friendly error messages
- **Loading States**: Shows loading state during password change process

## Files Structure

```
lib/features/profile/
├── presentation/
│   ├── view/
│   │   ├── my_account_screen.dart        # Existing account screen
│   │   ├── settings_screen.dart           # Existing settings screen
│   │   └── change_password_screen.dart    # New change password screen
│   └── widgets/
│       └── profile_menu_item.dart         # Existing profile menu item
├── profile_index.dart                      # Feature exports
├── demo_change_password.dart               # Demo screen for testing
└── README.md                               # This file
```

## Implementation Details

### ChangePasswordScreen
- Main screen for changing user passwords
- Clean white header with back button and centered title
- Three password input fields with proper validation
- Save button that's only enabled when form is valid
- Loading states and success feedback
- Responsive design using project utilities

### Password Fields
- **Old Password**: Required field for current password
- **New Password**: Required field with minimum 8 characters
- **Retype Password**: Must match new password exactly
- All fields include visibility toggle for better UX
- Real-time validation feedback

## Design Features

### Visual Elements
- **App Bar**: Clean white header with back button and centered title
- **Input Fields**: White containers with rounded corners and subtle borders
- **Labels**: Dark text for field labels with proper typography
- **Save Button**: Light purple background (primary color) when enabled
- **Background**: Light gray/white background for clean appearance

### Responsive Design
- Uses `context.responsivePadding` for consistent spacing
- Implements `context.responsiveMargin` for margins
- Applies responsive border radius for rounded corners
- Maintains consistent spacing across different screen sizes

### Color Scheme
- **Background**: `AppColors.scaffoldBackground` for screen background
- **Header**: `AppColors.white` for app bar background
- **Text**: `AppColors.textPrimary` for labels and text
- **Borders**: `AppColors.borderLight` for input field borders
- **Primary**: `AppColors.primary` for enabled save button
- **Disabled**: `AppColors.borderLight` for disabled save button

## Usage

### Basic Navigation
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const ChangePasswordScreen(),
  ),
);
```

### From Settings Screen
The change password screen is automatically integrated into the settings screen:
```dart
_buildSettingsItem(
  context,
  title: "reset_password".tr(),
  onTap: () {
    NavigationManager.navigateTo(ChangePasswordScreen());
  },
),
```

### Demo
Use the `ChangePasswordDemo` class to test the screen:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const ChangePasswordDemo(),
  ),
);
```

## Localization

The screen supports both English and Arabic languages:

- **English**: "Change Password", "Old Password", "New Password", "Retype New Password", "Save"
- **Arabic**: "تغيير كلمة المرور", "كلمة المرور القديمة", "كلمة المرور الجديدة", "إعادة كتابة كلمة المرور الجديدة", "حفظ"

## Form Validation

### Old Password
- Required field
- Must not be empty

### New Password
- Required field
- Minimum 8 characters
- Real-time validation

### Retype Password
- Required field
- Must match new password exactly
- Real-time validation

### Save Button
- Only enabled when all fields are valid
- Shows loading state during submission
- Provides success feedback

## Dependencies

- `flutter/material.dart` - Core Flutter widgets
- `localize_and_translate/localize_and_translate.dart` - Localization
- Project-specific utilities and theme files
- Custom widgets: `CustomAppBar`, `CustomTextFormField`, `PrimaryButton`

## Integration

The change password screen is fully integrated into the profile flow:
1. **Settings Screen** → "Reset Password" menu item
2. **Change Password Screen** → Password change form
3. **Success Feedback** → SnackBar notification and navigation back

## Future Enhancements

- Add password strength indicator
- Implement actual password change API
- Add biometric authentication option
- Include password history validation
- Add security questions backup
- Implement two-factor authentication
- Add password expiration notifications
