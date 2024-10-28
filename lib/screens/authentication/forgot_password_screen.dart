import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/forgot_password_controller.dart';
import 'package:gstark/screens/generate_invoice/generate_invoice_screen.dart';
import 'package:gstark/utils/validation_utils/upper_case_text_formatter.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../utils/toast_utils/error_toast.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_textfield.dart';

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
            height: MediaQuery.of(context).size.height,
            decoration: containerBottomCurvedDecoration,
          ),
          Container(
            decoration: curvedEdgeContainerDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.only(left: 16, right: 16, top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NormalText(
                    text: "Forgot Password?",
                    textSize: 20,
                    textColor: kApplicationThemeColor,
                    textFontWeight: FontWeight.w400),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    NormalText(
                        text: phoneNumber,
                        textColor: kBlackColor,
                        textFontWeight: FontWeight.w400),
                    NormalText(
                      text: "*",
                      textColor: kError,
                      textFontWeight: FontWeight.w400,
                      textSize: 24,
                    ),
                  ],
                ),
                InputTextField(
                  controller: _phoneNumberController,
                  hintText: enterYourNumber,
                  obscureText: false,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  inputParamter: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    NormalText(
                        text: "GST Number",
                        textColor: kBlackColor,
                        textFontWeight: FontWeight.w400),
                    NormalText(
                      text: "*",
                      textColor: kError,
                      textFontWeight: FontWeight.w400,
                      textSize: 24,
                    ),
                  ],
                ),
                InputTextField(
                  controller: _gstController,
                  hintText: "Enter GST Number",
                  obscureText: false,
                  autofocus: false,
                  inputParamter: [
                    FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9]")),  // Only allow uppercase letters and digits
                    LengthLimitingTextInputFormatter(15),
                    UpperCaseTextFormatter()
                  ],

                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    NormalText(
                        text: "Birth Place",
                        textColor: kBlackColor,
                        textFontWeight: FontWeight.w400),
                    NormalText(
                      text: "*",
                      textColor: kError,
                      textFontWeight: FontWeight.w400,
                      textSize: 24,
                    ),
                  ],
                ),
                InputTextField(
                  controller: _birthplaceController,
                  hintText: "Enter your birth place",
                  obscureText: false,
                  autofocus: false,
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    NormalText(
                        text: password,
                        textColor: kBlackColor,
                        textFontWeight: FontWeight.w400),
                    NormalText(
                      text: "*",
                      textColor: kError,
                      textFontWeight: FontWeight.w400,
                      textSize: 24,
                    ),
                  ],
                ),
                InputTextField(
                  controller: _passwordController,
                  hintText: enterYourPassword,
                  obscureText: false,
                  autofocus: false,
                ),
                const SizedBox(height: 46),
                Obx(() => ButtonWidget(
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
