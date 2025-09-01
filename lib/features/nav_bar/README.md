# Bottom Navigation Bar Feature

This feature provides a complete bottom navigation system with 4 tabs: Home, Cart, Categories, and Profile.

## Features

- **4 Tab Navigation**: Home, Cart, Categories, Profile
- **Responsive Design**: Uses your existing ResponsiveUtils and sizer package
- **Custom Styling**: Follows your AppColors and TextStyles
- **Smooth Transitions**: Clean navigation between screens
- **Active State Indicators**: Visual feedback for selected tabs

## Files Structure

```
lib/features/nav_bar/
├── presentation/
│   └── view/
│       ├── main_navigation_screen.dart    # Main navigation with bottom bar
│       ├── main_navigation_demo.dart      # Demo page with app bar
│       └── home_view.dart                 # Existing home view
├── index.dart                             # Feature exports
└── README.md                              # This file
```

## Usage

### Basic Usage
```dart
import 'package:baqalty/features/nav_bar/index.dart';

// Use the main navigation screen directly
const MainNavigationScreen()
```

### With Demo Page
```dart
import 'package:baqalty/features/nav_bar/index.dart';

// Use the demo page for testing
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const MainNavigationDemo()),
);
```

### Standalone Demo App
```dart
import 'package:baqalty/demo_app.dart';

// Run the demo app
void main() {
  runApp(const DemoApp());
}
```

## Tab Screens

1. **Home Tab** (`HomeScreen`)
   - Welcome header with notification icon
   - Search bar
   - Featured products grid

2. **Cart Tab** (`CartScreen`)
   - Shopping cart header
   - Empty cart state with call-to-action

3. **Categories Tab** (`CategoriesScreen`)
   - Categories header
   - 2x4 grid of category cards
   - Colorful category icons

4. **Profile Tab** (`ProfileScreen`)
   - Dark blue-purple header with user info
   - Light content area with menu items
   - 8 profile menu options

## Customization

### Colors
- Active tab: `AppColors.primary` (dark blue-grey)
- Inactive tab: `AppColors.textSecondary` (light grey)
- Background: `AppColors.white`

### Icons
- Home: `Icons.home_outlined` / `Icons.home`
- Cart: `Icons.shopping_cart_outlined` / `Icons.shopping_cart`
- Categories: `Icons.category_outlined` / `Icons.category`
- Profile: `Icons.person_outline` / `Icons.person`

### Responsive Design
- Uses `context.responsiveIconSize` for icon sizes
- Uses `context.responsiveMargin` for spacing
- Uses `context.responsivePadding` for padding
- Adapts to different screen sizes automatically

## Integration

To integrate this into your main app:

1. Replace your main app's home with `MainNavigationScreen`
2. Or use it as a route in your existing navigation
3. Customize the tab screens as needed
4. Add your own business logic to each screen

## Demo

Run `DemoApp` to see the complete navigation system in action!
