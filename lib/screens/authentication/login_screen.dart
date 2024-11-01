import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/login_screen_controller.dart';
import 'package:gstark/screens/authentication/register_user_screen.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/invoice_pdf_generator.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_textfield.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_page';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  late final LoginScreenController loginScreenController;
  bool isSignInLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    loginScreenController = Get.isRegistered<LoginScreenController>()
        ? Get.find<LoginScreenController>()
        : Get.put(LoginScreenController());
    _phoneNumberController.text = '';
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const NormalText(
                    text: gStark,
                    textFontWeight: FontWeight.w600,
                    textSize: 38,
                    textColor: kWhite,
                  ),
                  Container(
                    decoration: curvedEdgeContainerDecoration,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const NormalText(
                            text: login,
                            textSize: 30,
                            textColor: kApplicationThemeColor,
                            textFontWeight: FontWeight.w600),
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
                          obscureText: _obscureText,
                          autofocus: false,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kApplicationThemeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(const ForgotPasswordScreen(),
                                    transition: Transition.leftToRight);
                              },
                              child: const NormalText(
                                text: forgotPassword,
                                textColor: kApplicationThemeColor,
                                textSize: 16,
                                textFontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Obx(
                          () => ButtonWidget(
                            onPress: () async {
                              if (!loginScreenController.isBusy) {
                                if (_phoneNumberController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  errorToast("Please fill in the credentials",
                                      context);
                                } else {
                                  loginScreenController.signCustomerIn(
                                    userId: _phoneNumberController.text,
                                    password: _passwordController.text,
                                    context: context,
                                  );
                                }
                              }
                            },
                            buttonText: "LOGIN",
                            fontSize: 18,
                            backgroundColor: loginScreenController.isBusy
                                ? kPrimary200
                                : kApplicationThemeColor,
                            borderColor: loginScreenController.isBusy
                                ? kPrimary200
                                : kApplicationThemeColor,
                            isLoading: loginScreenController.isBusy,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NormalText(
                    text: dontHaveAnAccount,
                    textColor: kWhite,
                    textFontWeight: FontWeight.w400,
                    textSize: 16,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(const ValidateUserScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(30)),
                      child: const NormalText(
                        text: signUp,
                        textSize: 16,
                        textFontWeight: FontWeight.w600,
                        textColor: kPrimaryMain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}
