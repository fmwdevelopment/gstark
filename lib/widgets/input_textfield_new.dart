import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_decorations.dart';

class HomerTextInputFielEmailMedium extends StatelessWidget {
  final bool isEnable;
  final String hintText;
  final String labelText;
  final TextEditingController textController;
  final Function(String text) validationCallBack;
  final Function(String text) onSaveCallBack;
  final Function(String text) onChangedCallBack;

  const HomerTextInputFielEmailMedium({
    Key? key,
    this.isEnable = true,
    required this.hintText,
    required this.labelText,
    required this.textController,
    required this.validationCallBack,
    required this.onSaveCallBack,
    required this.onChangedCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextFormField(
      controller: textController,
      enabled: isEnable,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: 1,
      onChanged: (value) {
        onChangedCallBack(value);
      },
      onSaved: (value) => onSaveCallBack,
      style: isEnable == true
          ? textFormFieldTextInterStyle
          : textFormFieldTextGreyInterStyle,
      decoration: textFormFieldDecoration(
          hintText: hintText,
          textFormFieldHintStyle: textFormFieldHintInterStyle,
          labelText: labelText,
          isEnable: isEnable,
          textFormFieldLabelStyle: textFormFieldLabelInterStyle),
      validator: (value) => validationCallBack(value!),
    ));
  }
}
