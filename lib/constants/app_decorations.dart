import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

TextStyle textFormFieldTextInterStyle = GoogleFonts.inter(
    color: kPrimaryBlack,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal);

TextStyle textFormFieldTextGreyInterStyle = GoogleFonts.inter(
    color: kSecondaryGray700,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal);

InputDecoration textFormFieldDecoration(
    {required String hintText,
    required TextStyle textFormFieldHintStyle,
    required String labelText,
    required TextStyle textFormFieldLabelStyle,
    required bool isEnable}) {
  return InputDecoration(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    counterText: '',
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: errorTextFieldBorderColor),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: textFieldBorderColor),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: textFieldBorderColor),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: textFieldBorderColor),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    hintText: hintText,
    hintStyle: textFormFieldHintStyle,
    labelText: labelText,
    labelStyle: textFormFieldLabelStyle,
    contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
  );
}

TextStyle textFormFieldHintInterStyle = GoogleFonts.inter(
    color: kSecondaryGray700,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal);

TextStyle textFormFieldLabelInterStyle = GoogleFonts.inter(
    color: kSecondaryGray900,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal);

BoxDecoration containerBottomCurvedDecoration = BoxDecoration(
  color: kApplicationThemeColor,
  borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
  ),
  border: Border.all(
    color: kApplicationThemeColor,
    width: 3.0,
  ),
);

BoxDecoration curvedEdgeContainerDecoration = BoxDecoration(
  color: kWhite,
  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
  boxShadow: [
    BoxShadow(
      color: kSecondaryGray900.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);
