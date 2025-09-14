# My Wallet Feature

This feature implements a My Wallet screen based on the attached image design, showcasing the user's wallet balance and transaction history.

## Features

- **Clean Modern UI**: Implements a responsive design with clean, modern aesthetics matching the attached image
- **Balance Display**: Shows current wallet balance prominently in the header
- **Transaction History**: Displays transactions grouped by date (Today, Yesterday)
- **Responsive Design**: Uses the project's responsive utilities for consistent spacing and sizing
- **Localization**: Supports both English and Arabic languages
- **Interactive Elements**: Deposit button and support icon for user actions

## Files Structure

```
lib/features/wallet/
├── business/
│   └── models/
│       └── wallet_transaction_model.dart    # Wallet transaction data model
├── presentation/
│   └── view/
│       └── my_wallet_screen.dart            # Main wallet screen
├── wallet_index.dart                         # Feature exports
├── demo_wallet.dart                          # Demo screen for testing
└── README.md                                 # This file
```

## Implementation Details

### WalletTransactionModel
- Represents individual wallet transactions
- Includes transaction ID, type, amount, currency, and timestamp
- Provides formatted amount and timestamp utilities
- Supports different transaction types (deposit, withdrawal, purchase, refund)

### MyWalletScreen
- Main screen displaying wallet information and transactions
- Dark blue header with balance display and deposit button
- Light content area with transaction history
- Uses responsive design patterns from the project
- Includes loading states and proper error handling

## Design Features

### Visual Elements
- **Header Section**: Dark blue background with balance display and deposit button
- **Balance Display**: Large white text showing current balance in EGP
- **Avatar**: Circular icon with user initial
- **Deposit Button**: White button with clock icon and "Deposit" text
- **Support Icon**: Headphone icon in top right corner
- **Transaction Cards**: White cards with transaction details and colored amounts

### Responsive Design
- Uses `context.responsivePadding` for consistent spacing
- Implements `context.responsiveMargin` for margins
- Applies `context.responsiveBorderRadius` for rounded corners
- Utilizes `context.responsiveIconSize` for icon sizing

### Color Scheme
- **Header**: `AppColors.primary` for dark blue background
- **Balance**: White text for balance display
- **Avatar**: `AppColors.primaryLight` for circular background
- **Deposit Button**: White background with dark text
- **Transaction Amounts**: Green for positive, red for negative
- **Background Pattern**: Subtle circular overlays for visual interest

## Usage

### Basic Navigation
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const MyWalletScreen(),
  ),
);
```

### From Profile Screen
The wallet screen is automatically integrated into the profile screen:
```dart
ProfileMenuItem(
  iconPath: AppAssets.profileWallet,
  title: "my_wallet".tr(),
  onTap: () {
    NavigationManager.navigateTo(MyWalletScreen());
  },
),
```

### Demo
Use the `WalletDemo` class to test the screen:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const WalletDemo(),
  ),
);
```

## Localization

The screen supports both English and Arabic languages:

- **English**: "My Wallet", "Your Balance", "Deposit", "Today", "Yesterday"
- **Arabic**: "محفظتي", "رصيدك", "إيداع", "اليوم", "أمس"

## Dependencies

- `flutter/material.dart` - Core Flutter widgets
- `iconsax/iconsax.dart` - Icon library
- `localize_and_translate/localize_and_translate.dart` - Localization
- `sizer/sizer.dart` - Responsive sizing
- Project-specific utilities and theme files

## Mock Data

The screen includes sample transaction data:
- **Today**: BAQ10247 (+225 EGP), BAQ10248 (+1540 EGP), BAQ10249 (-798 EGP)
- **Yesterday**: BAQ10248 (+105 EGP), BAQ10249 (+150 EGP)

## Future Enhancements

- Implement actual deposit functionality
- Add transaction filtering and search
- Include transaction details view
- Add wallet settings and preferences
- Implement real-time balance updates
- Add transaction export functionality
- Include wallet analytics and insights
