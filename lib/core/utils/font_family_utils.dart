import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FontFamilyUtils {
  static String getCurrentFontFamily() {
    return _getFontFamily(LocalizeAndTranslate.getLanguageCode());
  }

  static String _getFontFamily(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return GoogleFonts.robotoFlex().fontFamily ?? 'Roboto Flex';
      case 'ar':
      default:
        return GoogleFonts.cairo().fontFamily ?? 'Cairo';
    }
  }

  static String getFontFamilyForLanguage(String languageCode) {
    return _getFontFamily(languageCode);
  }

  static bool isArabic() {
    return LocalizeAndTranslate.getLanguageCode().toLowerCase() == 'ar';
  }

  static bool isEnglish() {
    return LocalizeAndTranslate.getLanguageCode().toLowerCase() == 'en';
  }

  static TextDirection getTextDirection() {
    return isArabic() ? TextDirection.rtl : TextDirection.ltr;
  }

  static TextDirection getTextDirectionForLanguage(String languageCode) {
    return languageCode.toLowerCase() == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
