import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/register_screen_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../utils/toast_utils/error_toast.dart';
import '../../widgets/input_textfield.dart';
import '../../widgets/button.dart';

class ValidateUserScreen extends StatefulWidget {
  const ValidateUserScreen({super.key});

  @override
  State<ValidateUserScreen> createState() => _ValidateUserScreenState();
}

class _ValidateUserScreenState extends State<ValidateUserScreen> {
  final _phoneNumberController = TextEditingController();
  final _gstController = TextEditingController();
  final _birthplaceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  String? errorMessage;
  late final RegisterScreenController registerScreenController;

  @override
  void initState() {
    super.initState();
    registerScreenController = Get.isRegistered<RegisterScreenController>()
        ? Get.find<RegisterScreenController>()
        : Get.put(RegisterScreenController());
    registerScreenController.setIsValidated(false);
    _phoneNumberController.text = '';
    _gstController.text = '';
    _birthplaceController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _confirmPasswordController.text = '';
    _addressController.text = '';
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
          Obx(() => Container(
                decoration: curvedEdgeContainerDecoration,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.only(left: 25, right: 25, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const NormalText(
                        text: validateUser,
                        textSize: 20,
                        textColor: kApplicationThemeColor,
                        textFontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        NormalText(
                            text: "Phone Number",
                            textColor: kBlackColor,
                            textFontWeight: FontWeight.w600),
                        NormalText(
                            text: "*",
                            textColor: kError,
                            textFontWeight: FontWeight.w600,textSize: 24,),
                      ],
                    ),
                    InputTextField(
                      controller: _phoneNumberController,
                      hintText: enterYourNumber,
                      obscureText: false,
                      autofocus: false,
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        NormalText(
                            text: "GST Number",
                            textColor: kBlackColor,
                            textFontWeight: FontWeight.w600),
                        NormalText(
                          text: "*",
                          textColor: kError,
                          textFontWeight: FontWeight.w600,textSize: 24,),
                      ],
                    ),
                    InputTextField(
                      controller: _gstController,
                      hintText: "Enter GST Number",
                      obscureText: false,
                      autofocus: false,
                    ),
                    Visibility(
                      visible: registerScreenController.isValidated,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              NormalText(
                                  text: "Your birth place",
                                  textColor: kBlackColor,
                                  textFontWeight: FontWeight.w600),
                              NormalText(
                                text: "*",
                                textColor: kError,
                                textFontWeight: FontWeight.w600,textSize: 24,),
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
                                  text: "Password",
                                  textColor: kBlackColor,
                                  textFontWeight: FontWeight.w600),
                              NormalText(
                                text: "*",
                                textColor: kError,
                                textFontWeight: FontWeight.w600,textSize: 24,),
                            ],
                          ),
                          InputTextField(
                            controller: _passwordController,
                            hintText: "Enter Password",
                            obscureText: false,
                            autofocus: false,
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              NormalText(
                                  text: "Confirm Password",
                                  textColor: kBlackColor,
                                  textFontWeight: FontWeight.w600),
                              NormalText(
                                text: "*",
                                textColor: kError,
                                textFontWeight: FontWeight.w600,textSize: 24,),
                            ],
                          ),
                          InputTextField(
                            controller: _confirmPasswordController,
                            hintText: "Confirm Password",
                            obscureText: false,
                            autofocus: false,
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              NormalText(
                                  text: "Address",
                                  textColor: kBlackColor,
                                  textFontWeight: FontWeight.w600),
                              NormalText(
                                text: "*",
                                textColor: kError,
                                textFontWeight: FontWeight.w600,textSize: 24,),
                            ],
                          ),
                          InputTextField(
                            controller: _addressController,
                            hintText: "Enter Address",
                            obscureText: false,
                            autofocus: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Button(
                      onPress: () async {
                        if (!registerScreenController.isBusy) {
                          if (registerScreenController.isValidated) {
                            /// If Phone no and GST no is validated...
                            if (_phoneNumberController.text.isEmpty ||
                                _gstController.text.isEmpty ||
                                _birthplaceController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty) {
                              errorToast(pleaseFillTheCredentials, context);
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              errorToast(
                                  "Password and confirm password must be same",
                                  context);
                            } else {
                              registerScreenController.activateUser(
                                  phone: _phoneNumberController.text,
                                  gstn: _gstController.text,
                                  securityAnswer: _birthplaceController.text,
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                  address: _addressController.text,
                                  context: context);
                            }
                          } else {
                            /// If phone no and GST no is not validated...
                            if (_phoneNumberController.text.isEmpty ||
                                _gstController.text.isEmpty) {
                              errorToast(pleaseFillTheCredentials, context);
                            } else {
                              registerScreenController.validateUser(
                                  phone: _phoneNumberController.text,
                                  gstn: _gstController.text,
                                  context: context);
                            }
                          }
                        }
                      },
                      buttonText: registerScreenController.isBusy
                          ? "Validating..."
                          : registerScreenController.isValidated
                              ? register

                              /// Todo: need to verify this text...
                              : validate,
                      fontSize: 18,
                      backgroundColor: registerScreenController.isBusy
                          ? kPrimary200
                          : kApplicationThemeColor,
                      borderColor: registerScreenController.isBusy
                          ? kPrimary200
                          : kApplicationThemeColor,
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const NormalText(
                        textColor: kPrimaryMain,
                        text: 'Back',
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
