import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputParamter;
  final ValueChanged<String>? onChanged;
  final String? helperText;
  final bool enable;

  const InputTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.horizontalPadding = 10,
      this.verticalPadding = 10,
      this.fontSize = 14,
      this.hintTextColor = kSecondaryGray700,
      this.autofocus = true,
      this.suffixIcon,
      this.onChanged,
      this.inputParamter,
      this.keyboardType,
      this.helperText,  this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: enable?null:kNeutral100,
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        onChanged: onChanged ?? _defaultOnChanged,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofocus: autofocus,
        enabled: enable,
        autocorrect: false,
        inputFormatters: inputParamter,
        decoration: InputDecoration(
          helperText: helperText,
          contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kNeutral300),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kNeutral100),
            borderRadius: BorderRadius.circular(10), // Same border when disabled
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kNeutral500),
            borderRadius: BorderRadius.circular(10),
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
              fontSize: 14,
              fontFamily: 'ProximaNova'),
        ),
        style: TextStyle(
            color: kBlack,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            fontFamily: 'ProximaNova'),
      ),
    );
  }

  // Default no-op function
  void _defaultOnChanged(String value) {
    // Do nothing
  }
}
