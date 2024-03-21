import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class Button extends StatelessWidget {
  final Function() onPress;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double buttonHeight;
  final double? buttonWidth;
  final Color? borderColor;

  const Button({
    Key? key,
    required this.onPress,
    required this.buttonText,
    this.backgroundColor = kPrimaryMain,
    this.borderColor,
    this.textColor = kWhite,
    this.borderRadius = 0,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.buttonHeight = 48,
    this.buttonWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: TextButton(
        onPressed: onPress,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null // check if border color exists
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
