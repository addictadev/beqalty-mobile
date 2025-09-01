import 'package:flutter/material.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'product_card.dart';

class SpecialOffersSection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final VoidCallback? onProductTap;

  const SpecialOffersSection({super.key, this.onViewAllTap, this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return _buildProductsList(context);
  }

  Widget _buildProductsList(BuildContext context) {
    final products = [
      ProductData(
        name: "Juhayna Yogurt Plain",
        image: "assets/images/small_patern.png", // Using existing placeholder
        currentPrice: 12.25,
        originalPrice: 14.0,
      ),
      ProductData(
        name: "Juhayna Yogurt Strawberry",
        image: "assets/images/small_patern.png", // Using existing placeholder
        currentPrice: 13.50,
        originalPrice: 15.0,
      ),
      ProductData(
        name: "Juhayna Yogurt Vanilla",
        image: "assets/images/small_patern.png", // Using existing placeholder
        currentPrice: 11.75,
        originalPrice: 13.5,
      ),
      ProductData(
        name: "Juhayna Yogurt Mango",
        image: "assets/images/small_patern.png", // Using existing placeholder
        currentPrice: 12.00,
        originalPrice: 14.0,
      ),
    ];

    return SizedBox(
      height: context.responsiveContainerHeight * 0.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            productName: product.name,
            productImage: product.image,
            currentPrice: product.currentPrice,
            originalPrice: product.originalPrice,
            onTap: () {
              onProductTap?.call();
            },
          );
        },
      ),
    );
  }
}

class ProductData {
  final String name;
  final String image;
  final double currentPrice;
  final double? originalPrice;

  const ProductData({
    required this.name,
    required this.image,
    required this.currentPrice,
    this.originalPrice,
  });
}
