import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../text_utils/normal_text.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.buttonHeight = 48,
    this.textSize = 17.5,
    this.textFontWeight = FontWeight.w500,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double textSize;
  final FontWeight textFontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: outlinedButtonStyle,
        child: NormalText(
          textColor: kPrimaryMain,
          textSize: textSize,
          textFontWeight: textFontWeight,
          text: buttonText,
        ),
      ),
    );
  }
}
