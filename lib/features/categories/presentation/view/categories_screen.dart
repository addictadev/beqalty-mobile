import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample categories data
    final categories = [
      {
        'name': 'Electronics',
        'icon': Icons.phone_android,
        'color': Colors.blue,
      },
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': 'Home & Garden', 'icon': Icons.home, 'color': Colors.green},
      {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.orange},
      {'name': 'Books', 'icon': Icons.book, 'color': Colors.purple},
      {'name': 'Automotive', 'icon': Icons.directions_car, 'color': Colors.red},
      {'name': 'Health', 'icon': Icons.favorite, 'color': Colors.teal},
      {'name': 'Toys', 'icon': Icons.toys, 'color': Colors.amber},
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Categories",
                style: TextStyles.textViewBold24.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Categories grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: context.responsiveMargin,
                    mainAxisSpacing: context.responsiveMargin,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(
                      context,
                      name: category['name'] as String,
                      icon: category['icon'] as IconData,
                      color: category['color'] as Color,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: () {
            debugPrint('Category tapped: $name');
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsiveIconSize * 2,
                  height: context.responsiveIconSize * 2,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: context.responsiveIconSize,
                  ),
                ),
                SizedBox(height: context.responsiveMargin),
                Text(
                  name,
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
