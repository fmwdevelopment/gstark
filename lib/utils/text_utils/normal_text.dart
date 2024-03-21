import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

class NormalText extends StatelessWidget {
  const NormalText(
      {Key? key,
      required this.text,
      this.textColor = kBlack,
      this.textSize = 16,
      this.textFontWeight = FontWeight.w400,
      this.maxLine = 2,
      this.isUnderlined = false,
      this.isCrossed = false,
      this.textAlign = TextAlign.start})
      : super(key: key);

  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight? textFontWeight;
  final int maxLine;
  final TextAlign? textAlign;
  final bool isUnderlined;
  final bool isCrossed;
  @override
  Widget build(BuildContext context) {
    final decoration = isUnderlined
        ? TextDecoration.underline
        : isCrossed
            ? TextDecoration.lineThrough
            : TextDecoration.none;
    return Text(text,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: textSize,
          fontWeight: textFontWeight,
          decoration: decoration,
        ),
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        textDirection: TextDirection.ltr);
  }
}
