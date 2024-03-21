import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.isButtonEnabled,
    this.buttonHeight = 48,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback? onPressed;
  final bool isButtonEnabled;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonDecoration(isButtonEnabled),
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(
              color: kWhite, fontSize: 14.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
