import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/features/auth/presentation/widgets/customed_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          CustomImageAppBar(
            backgroundImagePath: AppAssets.authBackground,
            expandedHeight: 200.0,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageAsset(
                        assetName: AppAssets.appIcon,
                        width: 50.w,
                        height: 50.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style:
                                  LocalizeAndTranslate.getLanguageCode() == 'ar'
                                  ? GoogleFonts.cairo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black,
                                      height: 1.2,
                                      fontStyle: FontStyle.italic,
                                    )
                                  : GoogleFonts.robotoFlex(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black,
                                      height: 1.2,
                                      fontStyle: FontStyle.italic,
                                    ),
                              children: [
                                TextSpan(text: "welcome_back".tr()),
                                const TextSpan(text: "\n"),
                                TextSpan(text: "glad_to_see_you".tr()),
                                const TextSpan(text: "\n"),
                                TextSpan(text: "again".tr()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
