import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/forgot_password_controller.dart';

import '../../constants/string_constants.dart';
import '../../controller/login_screen_controller.dart';
import '../../widgets/button.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';
import 'login_screen_loader.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? errorMessage;
  late final ForgotPasswordController forgotPasswordController;
  bool isLoading = false;

  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gstController = TextEditingController();
  final _birthplaceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    forgotPasswordController = Get.isRegistered<ForgotPasswordController>()
        ? Get.find<ForgotPasswordController>()
        : Get.put(ForgotPasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      const NormalText(
                        text: "Forget Password?",
                        textAlign: TextAlign.center,
                        textFontWeight: FontWeight.w700,
                        textSize: 24,
                      ),
                      const SizedBox(height: 96),
                      const NormalText(
                        text: phoneNumber,
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _phoneNumberController,
                        hintText: enterYourNumber,
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "GST Number",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _gstController,
                        hintText: "Enter GST Number",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Birth Place",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _birthplaceController,
                        hintText: "Enter your birth place",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: password,
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _passwordController,
                        hintText: enterYourPassword,
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 46),
                      isLoading
                          ? Center(
                        child: NormalText(
                          text: "Resetting...",
                        ),
                      )
                          : Button(
                        onPress: () async {
                          print("reset tapped");
                          setState(() {
                            isLoading = !isLoading;
                          });
                        },
                        backgroundColor: kPrimaryMain,
                        buttonText: "RESET PASSWORD",
                        borderRadius: 0,
                        textColor: kWhite,
                      ),
                      const SizedBox(height: 25),
                      Button(
                        onPress: () async {
                          Get.back();
                        },
                        backgroundColor: kWhite,
                        buttonText: "Back",
                        borderRadius: 0,
                        textColor: kPrimaryMain,
                      ),
                      const SizedBox(height: 10),
                      if (errorMessage != null)
                        Center(
                          child: NormalText(
                            text: errorMessage!,
                            textColor: kError,
                            textSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
