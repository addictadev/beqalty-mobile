import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';

/// Example usage of ProductDetailsScreen with proper BlocProvider setup
/// 
/// This file demonstrates how to properly navigate to ProductDetailsScreen
/// with the required ProductDetailsCubit provider.
class ProductDetailsExampleScreen extends StatelessWidget {
  const ProductDetailsExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Example 1: Navigate to product details for product ID 1
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ProductDetailsCubit(
                        ServiceLocator.get<ProductDetailsService>(),
                      ),
                      child: const ProductDetailsScreen(productId: 1),
                    ),
                  ),
                );
              },
              child: const Text('View Product Details for ID 1'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Example 2: Navigate to product details for product ID 2
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ProductDetailsCubit(
                        ServiceLocator.get<ProductDetailsService>(),
                      ),
                      child: const ProductDetailsScreen(productId: 2),
                    ),
                  ),
                );
              },
              child: const Text('View Product Details for ID 2'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Alternative approach using a helper method
/// 
/// This approach creates a reusable method for navigating to ProductDetailsScreen
/// with proper provider setup.
class ProductDetailsNavigationHelper {
  /// Navigates to ProductDetailsScreen with proper BlocProvider setup
  /// 
  /// [context] - The BuildContext to use for navigation
  /// [productId] - The ID of the product to display
  static void navigateToProductDetails(BuildContext context, int productId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProductDetailsCubit(
            ServiceLocator.get<ProductDetailsService>(),
          ),
          child: ProductDetailsScreen(productId: productId),
        ),
      ),
    );
  }
}
