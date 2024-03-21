import 'package:flutter/material.dart';

import 'app_colors.dart';

var outlinedButtonStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
    ),
    side: const BorderSide(width: 1, color: kPrimaryMain));

ButtonStyle buttonDecoration(bool isButtonEnabled) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
        isButtonEnabled ? kPrimaryBlue : kTertiaryBlue300),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: isButtonEnabled ? kPrimaryMain : kPrimary300,
          width: 2.0,
        ),
      ),
    ),
  );
}
