import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/forgot_password_controller.dart';

import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../widgets/button.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';
import 'validate_user_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

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
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: containerBottomCurvedDecoration,
          ),
          Container(
            decoration: curvedEdgeContainerDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.only(left: 25, right: 25, top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NormalText(
                    text: "Forget Password?",
                    textSize: 20,
                    textColor: kApplicationThemeColor,
                    textFontWeight: FontWeight.w600),
                const SizedBox(height: 16),
                const NormalText(
                    text: phoneNumber,
                    textColor: kBlackColor,
                    textFontWeight: FontWeight.w600),
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
                    textColor: kBlackColor,
                    textFontWeight: FontWeight.w600),
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
                    textColor: kBlackColor,
                    textFontWeight: FontWeight.w600),
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
                    textColor: kBlackColor,
                    textFontWeight: FontWeight.w600),
                const SizedBox(height: 8),
                InputTextField(
                  controller: _passwordController,
                  hintText: enterYourPassword,
                  obscureText: false,
                  autofocus: false,
                ),
                const SizedBox(height: 46),
                isLoading
                    ? const Center(
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
                        fontSize: 18,
                        buttonText: resetPassword,
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
                  )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NormalText(
                text: dontHaveAnAccount,
                textFontWeight: FontWeight.w500,
                textSize: 16,
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.to(const ValidateUserScreen(),
                      transition: Transition.rightToLeft);
                },
                child: const NormalText(
                  text: signUp,
                  textSize: 18,
                  textFontWeight: FontWeight.w500,
                  textColor: kPrimaryMain,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
