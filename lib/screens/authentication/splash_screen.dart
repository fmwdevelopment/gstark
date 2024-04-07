import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';
import '../../constants/string_constants.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initCall(context);
  }

  void initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(seconds: 3), () {
        Get.off(const LoginScreen(), transition: Transition.leftToRight);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kApplicationThemeColor,
        child: const Center(
          child: NormalText(
            text: gStark,
            textSize: 52,
            textColor: kWhite,
            textFontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
