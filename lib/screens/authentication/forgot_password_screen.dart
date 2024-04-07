import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/forgot_password_controller.dart';

import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/toast_utils/error_toast.dart';
import '../../widgets/button.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';
import 'register_user_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? errorMessage;
  late final ForgotPasswordController forgotPasswordController;

  final _phoneNumberController = TextEditingController();
  final _gstController = TextEditingController();
  final _birthplaceController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    forgotPasswordController = Get.isRegistered<ForgotPasswordController>()
        ? Get.find<ForgotPasswordController>()
        : Get.put(ForgotPasswordController());
    _phoneNumberController.text = '';

    _gstController.text = '';
    _birthplaceController.text = '';
    _passwordController.text = '';
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
                Obx(() => Button(
                      onPress: () async {
                        if (!forgotPasswordController.isBusy) {
                          print(
                              "data: ${_phoneNumberController.text} ${_passwordController.text}");

                          if (_phoneNumberController.text.isEmpty ||
                              _gstController.text.isEmpty ||
                              _birthplaceController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            errorToast(pleaseFillAllTheDetails, context);
                          } else {
                            forgotPasswordController.resetPassword(
                                phoneNumber: _phoneNumberController.text,
                                gstn: _gstController.text,
                                securityAnswer: _birthplaceController.text,
                                password: _passwordController.text,
                                context: context);
                          }
                        }
                      },
                      buttonText: forgotPasswordController.isBusy
                          ? verifiying
                          : resetPassword,
                      fontSize: 18,
                      backgroundColor: forgotPasswordController.isBusy
                          ? kPrimary200
                          : kApplicationThemeColor,
                      borderColor: forgotPasswordController.isBusy
                          ? kPrimary200
                          : kApplicationThemeColor,
                    )),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const NormalText(
                    textColor: kPrimaryMain,
                    text: 'Back',

                    /// Todo: Back Button is side clickable
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
