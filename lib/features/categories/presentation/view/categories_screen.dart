import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/categories/business/cubit/category_cubit.dart';
import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/features/categories/presentation/widgets/no_categories_widget.dart';
import 'package:baqalty/features/categories/presentation/widgets/debounced_search_field.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'subcategory_screen.dart';
import 'categories_shimmer_view.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(),
      child: const CategoriesScreenBody(),
    );
  }
}

class CategoriesScreenBody extends StatefulWidget {
  const CategoriesScreenBody({super.key});

  @override
  State<CategoriesScreenBody> createState() => _CategoriesScreenBodyState();
}

class _CategoriesScreenBodyState extends State<CategoriesScreenBody>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getParentCategories();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _itemAnimationControllers = List.generate(
      12,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();
  }

  void _startAnimations() {
    _animationController.forward();

    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          _itemAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _itemAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading || state is CategoryInitial) {
            return const CategoriesShimmerView();
          }

          if (state is CategoryError) {
            return _buildErrorState(context, state.message);
          }

          if (state is CategoryLoaded) {
            return _buildLoadedState(context, state);
          }

          return const CategoriesShimmerView();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.responsiveMargin * 2),
              Text(
                "categories".tr(),
                style: TextStyles.textViewBold18.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.responsiveMargin),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: DebouncedSearchField(
                  hint: "search_categories".tr(),
                  onSearch: (query) {},
                  debounceDuration: const Duration(milliseconds: 300),
                  showClearButton: false,
                ),
              ),
              SizedBox(height: context.responsiveMargin * 2),
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16.w,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomErrorWidget(
                        message: message,
                        onRetry: () {
                          context.read<CategoryCubit>().getParentCategories();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, CategoryLoaded state) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.responsiveMargin * 2),
            Text(
              "categories".tr(),
              style: TextStyles.textViewBold18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.responsiveMargin),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: DebouncedSearchField(
                hint: "search_categories".tr(),
                onSearch: (query) {
                  context.read<CategoryCubit>().searchCategories(query);
                },
                debounceDuration: const Duration(milliseconds: 300),
                showClearButton: true,
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryCubit>().getParentCategories();
                },
                child: _buildCategoriesGrid(
                  context,
                  state.filteredCategories,
                  state.searchQuery,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    List<CategoryModel> categories,
    String searchQuery,
  ) {
    if (categories.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: NoCategoriesWidget(
          isSearchResult: searchQuery.isNotEmpty,
          onRetry: searchQuery.isEmpty
              ? () {
                  context.read<CategoryCubit>().getParentCategories();
                }
              : null,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.responsiveMargin,
          mainAxisSpacing: context.responsiveMargin,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final backgroundColor = _getRandomBackgroundColor(category.catId);

          return AnimatedBuilder(
            
            animation: index < _itemAnimations.length
                ? _itemAnimations[index]
                : _itemAnimations[0],
            builder: (context, child) {
              final animation = index < _itemAnimations.length
                  ? _itemAnimations[index]
                  : _itemAnimations[0];
              return Transform.scale(
                scale: animation.value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - animation.value)),
                  child: Opacity(
                    opacity: animation.value.clamp(0.0, 1.0),
                    child: _buildCategoryCard(
                      context,
                      category: category,
                      backgroundColor: backgroundColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required CategoryModel category,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: () {
            NavigationManager.navigateTo(
              SubcategoryScreen(
                categoryName: category.catName,
                categoryId: category.catId.toString(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsiveIconSize * 2,
                  height: context.responsiveIconSize * 2,
                  padding: EdgeInsets.all(context.responsivePadding / 2.5),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                    child: CustomCachedImage(
                      imageUrl: category.catImage,
                      width: context.responsiveIconSize * 2,
                      height: context.responsiveIconSize * 2,
                      fit: BoxFit.cover,
                      errorWidget: _buildErrorPlaceholder(backgroundColor),
                      placeholderWidget: _buildLoadingPlaceholder(
                        backgroundColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.responsiveMargin),
                Text(
                  category.catName,
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

  Widget _buildLoadingPlaceholder(Color backgroundColor) {
    return Container(
      width: context.responsiveIconSize * 2,
      height: context.responsiveIconSize * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              backgroundColor.computeLuminance() > 0.5
                  ? Colors.black26
                  : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(Color backgroundColor) {
    return Container(
      width: context.responsiveIconSize * 2,
      height: context.responsiveIconSize * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
      ),
      child: Icon(
        Icons.category_outlined,
        size: 28,
        color: backgroundColor.computeLuminance() > 0.5
            ? Colors.black38
            : Colors.white70,
      ),
    );
  }

  Color _getRandomBackgroundColor(int categoryId) {
    final pastelColors = [
      const Color(0xFFFFE5E5),
      const Color(0xFFFFF8E1),
      const Color(0xFFE8F5E8),
      const Color(0xFFE3F2FD),
      const Color(0xFFFFF3E0),
      const Color(0xFFF3E5F5),
      const Color(0xFFE0F7FA),
      const Color(0xFFFCE4EC),
      const Color(0xFFF1F8E9),
      const Color(0xFFFFF9C4),
      const Color(0xFFE1BEE7),
      const Color(0xFFFFCCBC),
    ];

    final random = math.Random(categoryId);
    return pastelColors[random.nextInt(pastelColors.length)];
  }
}
