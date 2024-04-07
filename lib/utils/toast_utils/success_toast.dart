import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../text_utils/normal_text.dart';
import 'toast_utils.dart';

successToast(
    {required String descriptionText,
    required BuildContext context,
    bool isShortDurationText = true}) {
  // ToastUtils.showSuccessToast(
  // context, descriptionText, isShortDurationText, true);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: NormalText(
      text: descriptionText,
      textSize: 14,
      textColor: kWhite,
    ),
  ));
}
