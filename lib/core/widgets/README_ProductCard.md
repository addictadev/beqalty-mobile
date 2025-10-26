# ProductCard Widget

## Overview
`ProductCard` is a reusable widget for displaying product information in a card format. It's designed to be used in grid views, search results, and other product listing screens.

## Features
- **Responsive Design**: Adapts to different screen sizes using Sizer
- **Image Loading**: Handles product images with loading states and error handling
- **Navigation**: Automatically navigates to product details screen
- **Customizable**: Supports custom dimensions, margins, and padding
- **Localization**: Supports multiple languages

## Usage

### Basic Usage
```dart
ProductCard(
  product: searchProduct,
)
```

### With Custom Dimensions
```dart
ProductCard(
  product: searchProduct,
  width: 200,
  height: 300,
)
```

### With Custom Styling
```dart
ProductCard(
  product: searchProduct,
  margin: EdgeInsets.all(8),
  padding: EdgeInsets.all(12),
)
```

### With Custom Tap Handler
```dart
ProductCard(
  product: searchProduct,
  onTap: () {
    // Custom navigation logic
    print('Product tapped: ${product.name}');
  },
)
```

## Grid View Implementation

### Using SearchGridView
```dart
SearchGridView(
  products: searchResults,
  onLoadMore: () {
    // Load more products
  },
  isLoadingMore: isLoadingMore,
)
```

### Custom Grid View
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(
      product: products[index],
    );
  },
)
```

## Properties

### ProductCard Properties
- `product` (SearchProductModel, required): The product data to display
- `width` (double?, optional): Custom width for the card
- `height` (double?, optional): Custom height for the card
- `margin` (EdgeInsets?, optional): Custom margin around the card
- `padding` (EdgeInsets?, optional): Custom padding inside the card
- `onTap` (VoidCallback?, optional): Custom tap handler

### SearchGridView Properties
- `products` (List<SearchProductModel>, required): List of products to display
- `onLoadMore` (VoidCallback?, optional): Callback for loading more products
- `isLoadingMore` (bool, optional): Whether more products are being loaded

## Dependencies
- `flutter/material.dart`
- `sizer` - For responsive sizing
- `cached_network_image` - For image loading
- `flutter_bloc` - For state management
- `localize_and_translate` - For localization

## Example Integration

```dart
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchProductModel> products = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SearchGridView(
              products: products,
              onLoadMore: _loadMore,
              isLoadingMore: isLoading,
            ),
    );
  }

  void _loadMore() {
    // Implement pagination logic
  }
}
```

## Notes
- The widget automatically handles navigation to product details
- Image loading includes placeholder and error states
- The widget is optimized for performance in large lists
- Supports both light and dark themes
