import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ButtonWidget extends StatelessWidget {
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
  final bool isLoading;

  const ButtonWidget({
    super.key,
    required this.onPress,
    required this.buttonText,
    this.backgroundColor = kApplicationThemeColor,
    this.borderColor,
    this.textColor = kWhite,
    this.borderRadius = 10,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.buttonHeight = 48,
    this.buttonWidth,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: TextButton(
        onPressed: isLoading ? null : onPress, // Disable button when loading
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null // Check if border color exists
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      strokeWidth: 2.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Please Wait...",
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      fontFamily: 'ProximaNova'
                    ),
                  ),
                ],
              )
            : Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: 'ProximaNova'
                ),
              ),
      ),
    );
  }
}
