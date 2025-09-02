# Saved Items Feature

This feature implements a Saved Items screen based on the attached image design, showcasing individual products saved by the user.

## Features

- **Clean Modern UI**: Implements a responsive design with clean, modern aesthetics
- **Search Functionality**: Allows users to search through their saved items
- **Product Cards**: Displays saved items with product images, names, categories, and prices
- **Responsive Design**: Uses the project's responsive utilities for consistent spacing and sizing
- **Localization**: Supports both English and Arabic languages
- **Interactive Elements**: Tap to view product details, heart icon to remove from saved items

## Files Structure

```
lib/features/saved_carts/
├── business/
│   └── models/
│       ├── saved_cart_model.dart      # Existing saved cart model
│       └── saved_item_model.dart      # New saved item model
├── presentation/
│   ├── view/
│   │   ├── saved_carts_screen.dart    # Existing saved carts screen
│   │   └── saved_items_screen.dart    # New saved items screen
│   └── widgets/
│       ├── saved_cart_card.dart       # Existing saved cart card
│       └── saved_item_card.dart       # New saved item card
├── saved_items_index.dart             # Feature exports
├── demo_saved_items.dart              # Demo screen for testing
└── README.md                          # This file
```

## Implementation Details

### SavedItemModel
- Represents individual saved products
- Includes product ID, name, category, image, price, and save date
- Provides formatted price and date utilities

### SavedItemsScreen
- Main screen displaying the list of saved items
- Implements search functionality with real-time filtering
- Uses responsive design patterns from the project
- Includes loading states and empty states
- Features a clean app bar with back navigation

### SavedItemCard
- Displays individual saved items in a card format
- Shows product image, name, category, and price
- Includes a heart icon for removing items from saved list
- Implements proper error handling for images
- Uses consistent styling with the project's design system

## Design Features

### Visual Elements
- **App Bar**: Clean white header with shadow and centered title
- **Search Bar**: Rounded search input with magnifying glass icon
- **Product Cards**: White cards with subtle shadows and rounded corners
- **Product Images**: Bordered images with fallback icons
- **Category Tags**: Styled category labels with background colors
- **Price Display**: Prominent price text in primary color
- **Remove Button**: Heart icon in error color for removing items

### Responsive Design
- Uses `context.responsivePadding` for consistent spacing
- Implements `context.responsiveMargin` for margins
- Applies `context.responsiveBorderRadius` for rounded corners
- Utilizes `context.responsiveIconSize` for icon sizing

### Color Scheme
- **Primary**: `AppColors.primary` for main elements
- **Background**: `AppColors.scaffoldBackground` for screen background
- **Cards**: `AppColors.white` for card backgrounds
- **Text**: `AppColors.textPrimary` and `AppColors.textSecondary`
- **Borders**: `AppColors.borderLight` for subtle borders
- **Shadows**: `AppColors.shadowLight` for depth

## Usage

### Basic Navigation
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const SavedItemsScreen(),
  ),
);
```

### Demo
Use the `SavedItemsDemo` class to test the screen:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const SavedItemsDemo(),
  ),
);
```

## Localization

The screen supports both English and Arabic languages:

- **English**: "Saved Items", "Search Saved Items"
- **Arabic**: "العناصر المحفوظة", "البحث في العناصر المحفوظة"

## Dependencies

- `flutter/material.dart` - Core Flutter widgets
- `iconsax/iconsax.dart` - Icon library
- `localize_and_translate/localize_and_translate.dart` - Localization
- Project-specific utilities and theme files

## Future Enhancements

- Add product detail navigation
- Implement add to cart functionality
- Add sorting and filtering options
- Include product ratings and reviews
- Add bulk actions for multiple items
- Implement offline storage for saved items
