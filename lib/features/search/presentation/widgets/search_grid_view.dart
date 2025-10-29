import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/product_card.dart';
import '../../data/models/search_response_model.dart';

class SearchGridView extends StatelessWidget {
  final List<SearchProductModel> products;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const SearchGridView({
    super.key,
    required this.products,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9, // Adjust this ratio as needed
        crossAxisSpacing: 0.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: products.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          // Loading indicator for pagination
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final product = products[index];
        return ProductCard(
          product: product,
          width: double.infinity,
 
        );
      },
    );
  }
}
