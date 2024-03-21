import 'package:flutter/material.dart';
import 'package:gstark/constants/app_colors.dart';

class InputTextFormField extends StatelessWidget {
  final String hintText;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final Color fillColor;
  final Function(String) onValidate;
  final Function(String) onChange;
  final String initialValue;

  // onValidate(String value) {
  //   if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
  //     return 'Please enter correct value';
  //   } else {
  //     return null;
  //   }
  // }

  const InputTextFormField({
    super.key,
    required this.hintText,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    this.fillColor = kBlack,
    required this.onValidate,
    this.initialValue = '',
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) => onChange(value),
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
      ),
      validator: (value) => onValidate(value ?? ''),
    );
  }
}
