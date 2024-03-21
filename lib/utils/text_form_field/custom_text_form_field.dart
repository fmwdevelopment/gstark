import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      this.horizontalPadding = 8,
      this.verticalPadding = 13.5,
      required this.onSave,
      required this.onValidate,
      required this.controller,
      required this.textFormFieldText})
      : super(key: key);

  final Function(String) onSave;
  final Function(String) onValidate;
  final TextEditingController controller;
  final String textFormFieldText;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (_) {},
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        /*focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),*/
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide(color: kError)),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: kBlack),
        ),
        /*label: NormalText(
          text: textFormFieldText,
          textColor: kSecondaryGray900,
          textSize: 17,
          textFontWeight: FontWeight.w600,
        ),*/
        hintText: textFormFieldText,
        hintStyle: const TextStyle(
          color: kBlack,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
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
