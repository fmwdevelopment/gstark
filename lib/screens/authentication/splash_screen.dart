import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/screens/Home/home_screen.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';
import '../../constants/shared_preference_string.dart';
import '../../constants/string_constants.dart';

import '../../utils/shared_preference/custom_shared_preference.dart';
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
      Timer(const Duration(seconds: 3), () async {
        bool isLoggedIn = await CustomSharedPref.getPref<bool>(
                SharedPreferenceString.isLoggedIn) ??
            false;
        if (isLoggedIn) {
          Get.to(const HomeScreen(), transition: Transition.rightToLeft);
        } else {
          Get.off(const LoginScreen(), transition: Transition.leftToRight);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kPrimary200,kPrimary900])
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NormalText(
                text: gStark,
                textSize: 52,
                textColor: kWhite,
                textFontWeight: FontWeight.w600,
              ),
               NormalText(
                text: "Solution for your accounts",
                textSize: 14,
                textColor: kWhite,
                textFontWeight: FontWeight.w400
              ),
            ],
          ),
        ),
      ),
    );
  }
}
