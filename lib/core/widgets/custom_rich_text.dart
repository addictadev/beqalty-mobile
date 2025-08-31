import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.startSubTextStyle,
    this.centerSubTextStyle,
    this.endSubTextStyle,
    this.startSubText,
    this.centerSubText,
    this.endSubText,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.useNewLine = false,
  });

  final TextStyle? startSubTextStyle;
  final TextStyle? centerSubTextStyle;
  final TextStyle? endSubTextStyle;
  final String? startSubText;
  final String? centerSubText;
  final String? endSubText;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool useNewLine;

  @override
  Widget build(BuildContext context) {
    // Default style for welcome text
    final defaultStyle = GoogleFonts.robotoFlex(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF1A1A1A),
      height: 1.2,
    );

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      text: TextSpan(
        style: TextStyles.textViewRegular14.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        children: [
          if (startSubText != null)
            TextSpan(
              text: startSubText,
              style: startSubTextStyle ?? defaultStyle,
            ),
          if (useNewLine && centerSubText != null) const TextSpan(text: "\n"),
          if (centerSubText != null)
            TextSpan(
              text: useNewLine ? centerSubText : " $centerSubText",
              style: centerSubTextStyle ?? defaultStyle,
            ),
          if (useNewLine && endSubText != null) const TextSpan(text: "\n"),
          if (endSubText != null)
            TextSpan(
              text: useNewLine ? endSubText : " $endSubText",
              style: endSubTextStyle ?? defaultStyle,
            ),
        ],
      ),
    );
  }
}

// Alternative simpler approach for the welcome message specifically
class WelcomeText extends StatelessWidget {
  final String welcomeBack;
  final String gladToSeeYou;
  final String again;
  final TextStyle? textStyle;

  const WelcomeText({
    super.key,
    required this.welcomeBack,
    required this.gladToSeeYou,
    required this.again,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ??
        GoogleFonts.robotoFlex(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
          height: 1.2,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(welcomeBack, style: style),
        Text(gladToSeeYou, style: style),
        Text(again, style: style),
      ],
    );
  }
}
