import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/font_utils.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/widgets/bordered_button.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/auth/presentation/view/login_screen.dart';
import '../../../../core/images_preview/custom_svg_img.dart';
import '../widgets/glass_morphism_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "earn_rewards_title".tr(),
      description: "earn_rewards_description".tr(),
    ),
    OnboardingPage(
      title: "smart_shopping_title".tr(),
      description: "smart_shopping_description".tr(),
    ),
    OnboardingPage(
      title: "fast_delivery_title".tr(),
      description: "fast_delivery_description".tr(),
    ),
    OnboardingPage(
      title: "fresh_quality_title".tr(),
      description: "fresh_quality_description".tr(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() {
    NavigationManager.navigateToAndFinish(LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withOpacity(.9),
      body: Container(
        decoration: BoxDecoration(
          
          image: DecorationImage(image: AssetImage(AppAssets.onboardingPattern),fit: BoxFit.cover)),
        child: Stack(
          children: [
            // Background image layer
            Positioned.fill(
              child: Image.asset(
                AppAssets.onboardingPattern,
                fit: BoxFit.cover,
              ),
            ),

            // Main content layer
            SafeArea(
              child: Column(
                children: [
                  Expanded(child: _buildOnboardingPages()),

                  _buildBottomSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPages() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        children: [
          SizedBox(height: 8.h),

          Expanded(flex: 3, child: _buildCharacterIllustration()),

          Expanded(flex: 2, child: _buildPageView()),


        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        return _buildInformationCard(_pages[index]);
      },
    );
  }

  Widget _buildCharacterIllustration() {
    return Center(
      child: CustomSvgImage(
        assetName: AppAssets.splashIcon,
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationCard(OnboardingPage page) {
    return GlassMorphismCard(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      
      blur: 15,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.15),
      borderRadius: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            style: TextStyle(
              fontSize: FontSizes.s20,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            page.description,
            style: TextStyle(
              fontSize: FontSizes.s14,
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
                    _buildPageIndicators(),

        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          // Navigation buttons
     PrimaryButton(
                  text:  "get_started".tr() 
                      ,
                  onPressed: 
                       _onGetStartedPressed 
                      ,
                      margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
                  color: AppColors.white,
                  textStyle: TextStyle(
                    fontSize: FontSizes.s16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  borderRadius: 30,
                  height: 56,
                ),

          SizedBox(height: 3.h),
        ],
      ),
    );
  }


}

class OnboardingPage {
  final String title;
  final String description;

  OnboardingPage({required this.title, required this.description});
}
