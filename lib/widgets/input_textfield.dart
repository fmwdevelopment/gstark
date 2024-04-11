import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final Color hintTextColor;
  final bool autofocus;
  final Widget? suffixIcon;

  const InputTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.horizontalPadding = 16,
      this.verticalPadding = 13.5,
      this.fontSize = 16,
      this.hintTextColor = kSecondaryGray700,
      this.autofocus = true,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kNeutral400),
          borderRadius: BorderRadius.circular(18),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kBlack),
          borderRadius: BorderRadius.circular(18),
        ),
        // label: Text(
        //   hintText,
        //   style: const TextStyle(
        //       color: Colors.black54, fontWeight: FontWeight.w500),
        // ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),

      ),
      style: TextStyle(
        color: kBlack,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
