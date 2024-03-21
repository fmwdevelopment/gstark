import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../text_utils/normal_text.dart';
import 'toast_animation.dart';

class ToastUtils {
  static Timer? toastTimer;
  static OverlayEntry? _overlayEntry;

  static void showSuccessToast(BuildContext context, String message,
      bool isShortDurationText, bool isSuccess) {
    if (toastTimer == null || !toastTimer!.isActive) {
      _overlayEntry = createOverlayEntrySuccess(context, message, isSuccess);
      Overlay.of(context).insert(_overlayEntry!);
      toastTimer = Timer(Duration(seconds: isShortDurationText ? 3 : 5), () {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntrySuccess(
      BuildContext? context, String message, bool isSuccess) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        width: MediaQuery.of(context).size.width * 0.4,
        left: MediaQuery.of(context).size.width * 0.3,
        child: SlideInToastMessageAnimation(
          Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 14, right: 14, top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: isSuccess ? kSecondarySuccess50 : kLightRedColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      isSuccess ? successToastIcon : failureToastIcon,
                      height: 22,
                      width: 22,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: NormalText(
                          text: message,
                          textSize: 14,
                          maxLine: 5,
                          textColor: isSuccess
                              ? kSecondarySuccess500
                              : kSecondaryError500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
