import 'package:flutter/material.dart';

import 'toast_utils.dart';

successToast(
    {required String descriptionText,
      required BuildContext context,
      bool isShortDurationText = true}) {
  ToastUtils.showSuccessToast(
      context, descriptionText, isShortDurationText, true);
}
