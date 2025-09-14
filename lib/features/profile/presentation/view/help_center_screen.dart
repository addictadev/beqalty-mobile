import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax/iconsax.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<FAQItem> _faqItems = [];
  List<FAQItem> _filteredItems = [];
  bool _isSearching = false;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _loadFAQItems();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadFAQItems() {
    _faqItems = [
      FAQItem(
        question: "how_place_order".tr(),
        answer: "how_place_order_answer".tr(),
        isExpanded: true,
      ),
      FAQItem(
        question: "payment_methods_accepted".tr(),
        answer: "payment_methods_accepted_answer".tr(),
        isExpanded: true,
      ),
      FAQItem(
        question: "track_order".tr(),
        answer: "track_order_answer".tr(),
        isExpanded: true,
      ),
      FAQItem(
        question: "delivery_time".tr(),
        answer: "delivery_time_answer".tr(),
        isExpanded: true,
      ),
      FAQItem(
        question: "cancel_order".tr(),
        answer: "cancel_order_answer".tr(),
        isExpanded: true,
      ),
      FAQItem(
        question: "return_policy".tr(),
        answer: "return_policy_answer".tr(),
        isExpanded: true,
      ),
    ];
    _filteredItems = List.from(_faqItems);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _filteredItems = _faqItems
            .where(
              (item) =>
                  item.question.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) ||
                  item.answer.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
            )
            .toList();
      } else {
        _filteredItems = List.from(_faqItems);
      }
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Dark Purple Header
          _buildHeader(context),

          // White Content Area
          Expanded(child: _buildContentArea(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 2.h,
        left: context.responsivePadding,
        right: context.responsivePadding,
        bottom: 3.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
      ),
      child: Column(
        children: [
          // Top Row with Back Button and Decorative Cube
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: context.responsiveIconSize * 1.2,
                  height: context.responsiveIconSize * 1.2,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.white,
                    size: context.responsiveIconSize * 0.8,
                  ),
                ),
              ),

              // Decorative Cube
              // Container(
              //   width: context.responsiveIconSize * 0.8,
              //   height: context.responsiveIconSize * 0.8,
              //   decoration: BoxDecoration(
              //     color: AppColors.primaryLight,
              //     borderRadius: BorderRadius.circular(8),
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.primaryLight.withValues(alpha: 0.3),
              //         blurRadius: 8,
              //         offset: const Offset(2, 2),
              //       ),
              //     ],
              //   ),
              //   child: Icon(
              //     Icons.help_outline,
              //     color: AppColors.white,
              //     size: context.responsiveIconSize * 0.5,
              //   ),
              // ),
            ],
          ),

          SizedBox(height: 2.h),

          // Title
          Text(
            "have_burning_question".tr(),
            style: TextStyles.textViewBold24.copyWith(
              color: AppColors.white,
              fontSize: FontSizes.s20,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Search Bar
          _buildSearchBar(context),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _isSearchFocused ? AppColors.primary : AppColors.borderLight,
          width: _isSearchFocused ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isSearchFocused
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.shadowLight,
            blurRadius: _isSearchFocused ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: "search_faqs".tr(),
          hintStyle: TextStyles.textViewRegular14.copyWith(
            color: AppColors.textLight,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal,
            color: _isSearchFocused ? AppColors.primary : AppColors.textLight,
            size: context.responsiveIconSize * 0.8,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
        style: TextStyles.textViewRegular14.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveBorderRadius * 2),
          topRight: Radius.circular(context.responsiveBorderRadius * 2),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 14.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Topics Header
          _buildTopicsHeader(context),

          // FAQ List
          Expanded(child: _buildFAQList(context)),
        ],
      ),
    );
  }

  Widget _buildTopicsHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "topics".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
              fontSize: FontSizes.s18,
            ),
          ),
          // GestureDetector(
          //   onTap: _viewAllTopics,
          //   child: Text(
          //     "view_all".tr(),
          //     style: TextStyles.textViewMedium16.copyWith(
          //       color: AppColors.primary,
          //       fontSize: FontSizes.s16,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFAQList(BuildContext context) {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: context.responsiveIconSize * 2,
              color: AppColors.textLight,
            ),
            SizedBox(height: 2.h),
            Text(
              "no_results_found".tr(),
              style: TextStyles.textViewRegular16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return _buildFAQCard(context, _filteredItems[index], index);
      },
    );
  }

  Widget _buildFAQCard(BuildContext context, FAQItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin * 2),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.responsivePadding),
          // Question Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsivePadding,
            ),
            child: Text(
              item.question,
              style: TextStyles.textViewBold16.copyWith(
                color: AppColors.textPrimary,
                fontSize: FontSizes.s16,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.answer,
                  style: TextStyles.textViewRegular14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () => _viewTopic(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 3.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgProfile,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "view_topic".tr(),
                      style: TextStyles.textViewMedium14.copyWith(
                        color: AppColors.primary,
                        fontSize: FontSizes.s14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewTopic(FAQItem item) {
    // TODO: Implement view topic functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing topic: ${item.question}'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
