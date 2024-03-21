import 'package:flutter/material.dart';

import 'toast_utils.dart';

errorToast(String errorText, BuildContext context,
    {bool isShortDurationText = true}) {
  ToastUtils.showSuccessToast(context, errorText, isShortDurationText, false);
}
