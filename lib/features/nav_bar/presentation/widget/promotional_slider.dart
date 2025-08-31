import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'promotional_card.dart';

class PromotionalSlider extends StatefulWidget {
  final List<PromotionalCardData> cards;
  final double height;
  final VoidCallback? onCardTap;

  const PromotionalSlider({
    super.key,
    required this.cards,
    this.height = 120,
    this.onCardTap,
  });

  @override
  State<PromotionalSlider> createState() => _PromotionalSliderState();
}

class _PromotionalSliderState extends State<PromotionalSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              return PromotionalCard(
                title: card.title,
                buttonText: card.buttonText,
                onPlaceOrderTap: () {
                  widget.onCardTap?.call();
                },
              );
            },
          ),
        ),

        SizedBox(height: 16),

        // Page indicators
        if (widget.cards.length > 1) _buildPageIndicators(),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.cards.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.borderLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class PromotionalCardData {
  final String title;
  final String buttonText;

  const PromotionalCardData({required this.title, required this.buttonText});
}
