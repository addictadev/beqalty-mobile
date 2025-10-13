import 'dart:async';
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'promotional_card.dart';

class PromotionalSlider extends StatefulWidget {
  final List<AdvertisementModel> cards;
  final double height;
  final VoidCallback? onCardTap;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showIndicators;

  const PromotionalSlider({
    super.key,
    required this.cards,
    this.height = 120,
    this.onCardTap,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicators = true,
  });

  @override
  State<PromotionalSlider> createState() => _PromotionalSliderState();
}

class _PromotionalSliderState extends State<PromotionalSlider> {
  late PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.autoPlay && widget.cards.length > 1) {
      _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
        if (mounted) {
          _nextPage();
        }
      });
    }
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _nextPage() {
    if (widget.cards.isEmpty) return;

    final nextIndex = (_currentIndex + 1) % widget.cards.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPageTap() {
    _stopAutoPlay();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _startAutoPlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height * 1.2,
          child: GestureDetector(
            onTap: _onPageTap,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: _onPageChanged,
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
        ),
      ],
    );
  }
}

class PromotionalCardData {
  final String title;
  final String buttonText;

  const PromotionalCardData({required this.title, required this.buttonText});
}
