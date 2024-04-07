import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../text_utils/normal_text.dart';
import 'toast_utils.dart';

errorToast(String errorText, BuildContext context,
    {bool isShortDurationText = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: NormalText(
      text: errorText,
      textSize: 14,
      textColor: kWhite,
    ),
  ));

  // ToastUtils.showSuccessToast(context, errorText, isShortDurationText, false);
}
