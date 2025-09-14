import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/styles/styles.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../../../core/utils/font_family_utils.dart';
import '../../../../core/widgets/custom_radio_tile.dart';

class LanguageSelectionBottomSheet extends StatefulWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  State<LanguageSelectionBottomSheet> createState() =>
      _LanguageSelectionBottomSheetState();
}

class _LanguageSelectionBottomSheetState
    extends State<LanguageSelectionBottomSheet> {
  String _selectedLanguage = 'en';
  bool _isChangingLanguage = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  void _loadCurrentLanguage() {
    setState(() {
      _selectedLanguage = SharedPrefsHelper.getLanguage();
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode || _isChangingLanguage) return;

    if (!mounted) return;

    setState(() {
      _selectedLanguage = languageCode;
      _isChangingLanguage = true;
    });

    try {
      await SharedPrefsHelper.setLanguage(languageCode);

      await LocalizeAndTranslate.setLanguageCode(languageCode);

      if (!mounted) return;

      Navigator.of(context).pop();

      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        Phoenix.rebirth(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedLanguage = SharedPrefsHelper.getLanguage();
          _isChangingLanguage = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isChangingLanguage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveBorderRadius * 2),
          topRight: Radius.circular(context.responsiveBorderRadius * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: context.responsiveMargin),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Text(
              "select_language".tr(),
              style: TextStyles.textViewBold18.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontFamily: FontFamilyUtils.getCurrentFontFamily(),
              ),
            ),
          ),

          CustomRadioTile(
            title: "english".tr(),
            subtitle: "English",
            value: _selectedLanguage == 'en',
            onChanged: _isChangingLanguage
                ? (value) {}
                : (value) => _changeLanguage('en'),
            titleFontFamily: FontFamilyUtils.getFontFamilyForLanguage('en'),
            subtitleFontFamily: FontFamilyUtils.getFontFamilyForLanguage('en'),
          ),

          CustomRadioTile(
            title: "arabic".tr(),
            subtitle: "العربية",
            value: _selectedLanguage == 'ar',
            onChanged: _isChangingLanguage
                ? (value) {}
                : (value) => _changeLanguage('ar'),
            showDivider: false,
            titleFontFamily: FontFamilyUtils.getFontFamilyForLanguage('ar'),
            subtitleFontFamily: FontFamilyUtils.getFontFamilyForLanguage('ar'),
          ),

          SizedBox(
            height:
                MediaQuery.of(context).padding.bottom +
                context.responsiveMargin,
          ),
        ],
      ),
    );
  }
}
