import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';

class FoodDoodlesBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const FoodDoodlesBackground({
    super.key,
    required this.child,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.scaffoldBackground,
        ),

        // Food doodles
        Positioned(
          top: 100,
          right: -30,
          child: _buildFoodDoodle(
            icon: Icons.lunch_dining,
            size: 60,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 200,
          left: -20,
          child: _buildFoodDoodle(
            icon: Icons.cake,
            size: 40,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 150,
          right: 100,
          child: _buildFoodDoodle(
            icon: Icons.eco,
            size: 35,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 300,
          left: 50,
          child: _buildFoodDoodle(
            icon: Icons.local_pizza,
            size: 45,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 400,
          right: 50,
          child: _buildFoodDoodle(
            icon: Icons.icecream,
            size: 50,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 500,
          left: 100,
          child: _buildFoodDoodle(
            icon: Icons.fastfood,
            size: 55,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 600,
          right: 150,
          child: _buildFoodDoodle(
            icon: Icons.local_bar,
            size: 40,
            color: AppColors.foodDoodleColor,
          ),
        ),

        Positioned(
          top: 700,
          left: 150,
          child: _buildFoodDoodle(
            icon: Icons.restaurant,
            size: 45,
            color: AppColors.foodDoodleColor,
          ),
        ),

        // Main content
        child,
      ],
    );
  }

  Widget _buildFoodDoodle({
    required IconData icon,
    required double size,
    required Color color,
  }) {
    return Opacity(
      opacity: opacity,
      child: Icon(icon, size: size, color: color),
    );
  }
}
