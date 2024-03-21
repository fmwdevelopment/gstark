import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widgets/svg_icon.dart';
import '../text_utils/normal_text.dart';

class CustomizedCard extends StatelessWidget {
  final String? icon;
  final String text;
  final double textSize;
  final int maxLines;
  final TextAlign textAlign;

  const CustomizedCard({
    Key? key,
    required this.text,
    this.icon,
    this.textSize = 15,
    this.maxLines = 2,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 65.0,
      color: kSecondary200,
      child: Row(
        children: [
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6,
              ),
              child: icon != null ? CustomSvgIcon(icon: icon!) : null,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 11.0,
              ),
              child: NormalText(
                text: text,
                maxLine: maxLines,
                textSize: textSize,
                textAlign: textAlign,
                textFontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
