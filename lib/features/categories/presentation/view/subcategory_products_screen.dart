import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/search/presentation/widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../business/cubit/subcategory_products_cubit.dart';
import '../widgets/category_grid_view.dart';


class SubcategoryProductsScreen extends StatefulWidget {
  final String subcategoryName;
  final String categoryName;
  final String subcategoryId;
  final String? sharedCartId;

  const SubcategoryProductsScreen({
    super.key,
    required this.subcategoryName,
    required this.categoryName,
    required this.subcategoryId,
    this.sharedCartId,
  });

  @override
  State<SubcategoryProductsScreen> createState() =>
      _SubcategoryProductsScreenState();
}

class SubcategoryProductsScreenBody extends StatefulWidget {
  final String subcategoryName;
  final String categoryName;
  final String subcategoryId;
  final String? sharedCartId;

  const SubcategoryProductsScreenBody({
    super.key,
    required this.subcategoryName,
    required this.categoryName,
    required this.subcategoryId,
    this.sharedCartId,
  });

  @override
  State<SubcategoryProductsScreenBody> createState() =>
      _SubcategoryProductsScreenBodyState();
}

class _SubcategoryProductsScreenState extends State<SubcategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoryProductsCubit()
        ..loadSubcategoryProducts(widget.subcategoryId),
      child: SubcategoryProductsScreenBody(
        subcategoryName: widget.subcategoryName,
        categoryName: widget.categoryName,
        subcategoryId: widget.subcategoryId,
        sharedCartId: widget.sharedCartId,
      ),
    );
  }
}

class _SubcategoryProductsScreenBodyState extends State<SubcategoryProductsScreenBody>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startAnimations();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more products when near bottom
        context.read<SubcategoryProductsCubit>().loadMoreProducts();
      }
    });
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: widget.subcategoryName,
                onBackPressed: () {
                  NavigationManager.pop();
                },
              ),
              SizedBox(height: context.responsiveMargin),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: CustomTextFormField(
                  controller: _searchController,
                  hint: "search_products".tr(),
                  prefixIcon: Icon(
                    Iconsax.search_normal,
                    color: AppColors.textSecondary,
                  ),
                  onChanged: (value) {
                    context.read<SubcategoryProductsCubit>().searchProducts(value);
                  },
                ),
              ),

              Expanded(child: _buildProductsList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return BlocBuilder<SubcategoryProductsCubit, SubcategoryProductsState>(
      builder: (context, state) {
        if (state is SubcategoryProductsLoading) {
          return _buildLoadingState(context);
        } else if (state is SubcategoryProductsError) {
          return _buildErrorState(context, state.message);
        } else if (state is SubcategoryProductsLoaded) {
          if (state.products.isEmpty) {
            return BuildEmptyState(context,isSearchResult: state.searchQuery.isNotEmpty);
          }
          return _buildProductsListView(context, state);
        }
        return _buildLoadingState(context);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "loading_products".tr(),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: CustomErrorWidget(
        message: message,
        onRetry: () {
          context.read<SubcategoryProductsCubit>().refreshProducts();
        },
      ),
    );
  }

  Widget _buildProductsListView(BuildContext context, SubcategoryProductsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<SubcategoryProductsCubit>().refreshProducts();
      },
      child: CategoryGridView(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        // crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        products: state.products,
        onLoadMore: state.hasMoreProducts ? () {
          context.read<SubcategoryProductsCubit>().loadMoreProducts();
        } : null,
        isLoadingMore: false, // You might want to add this to the state
        sharedCartId: widget.sharedCartId,
        showHeader: true,
        headerText: widget.subcategoryName,
      ),
    );
  }


}
