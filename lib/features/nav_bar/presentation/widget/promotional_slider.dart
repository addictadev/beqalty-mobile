import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'promotional_card.dart';

class PromotionalSlider extends StatefulWidget {
  final List<AdvertisementModel> cards;
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
        SizedBox(
          height: widget.height * 1.2,
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {},
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              final card = widget.cards[index];
              return PromotionalCard(
                title: card.advType,
                buttonText: "place_order".tr(),
                onPlaceOrderTap: widget.onCardTap,
                image: card.baseImage,
              );
            },
          ),
        ),

        SizedBox(height: 16),
      ],
    );
  }
}

class PromotionalCardData {
  final String title;
  final String buttonText;

  const PromotionalCardData({required this.title, required this.buttonText});
}
