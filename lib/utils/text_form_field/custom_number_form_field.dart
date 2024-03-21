import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../text_utils/normal_text.dart';

class CustomNumberFormField extends StatelessWidget {
  const CustomNumberFormField(
      {Key? key,
        required this.onSave,
        required this.onValidate,
        required this.controller,
        required this.textFormFieldText})
      : super(key: key);

  final Function(String) onSave;
  final Function(String) onValidate;
  final TextEditingController controller;
  final String textFormFieldText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (_) {},
      controller: controller,
      decoration: InputDecoration(
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: errorTextFieldBorderColor)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor)),
        label: NormalText(
          text: textFormFieldText,
          textColor: kSecondaryGray900,
          textSize: 14,
          textFontWeight: FontWeight.w600,
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofocus: true,
      maxLength: 2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) {
        if (value != null) {
          onSave(value);
        }
      },
      validator: (value) => onValidate(value ?? ''),
    );
  }
}
