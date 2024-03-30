import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/login_screen_controller.dart';
import 'package:gstark/screens/authentication/validate_user_screen.dart';
import 'package:gstark/utils/invoice_pdf_generator.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
import '../../widgets/input_textfield.dart';
import '../Home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'login_screen_loader.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_page';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  String? errorMessage;
  late final LoginScreenController loginScreenController;
  bool isSignInLoading = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    loginScreenController = Get.isRegistered<LoginScreenController>()
        ? Get.find<LoginScreenController>()
        : Get.put(LoginScreenController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      const NormalText(
                        text: welcomeNote,
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
                        text: password,
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
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
                            color: _obscureText ? kPrimaryMain : kPrimaryMain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                              textColor: kPrimaryMain,
                              textSize: 16,
                              textFontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 46),
                      Obx(
                        () => loginScreenController.isBusy
                            ? Button(
                                onPress: () {},
                                buttonText: "Signing In...",
                                backgroundColor: Colors.grey,
                                borderRadius: 0,
                                textColor: kPrimaryBlack,
                              )
                            : Button(
                                onPress: () async {
                                  // setState(() {
                                  //   isSignInLoading = !isSignInLoading;
                                  // });

                                  // loginScreenController.signCustomerIn(
                                  //     email: _emailController.text,
                                  //     password: _passwordController.text,
                                  //     context: context);
                                  // final invoiceData = [
                                  //   {
                                  //     'name': 'Product A',
                                  //     'quantity': 2,
                                  //     'price': 25.00
                                  //   },
                                  //   {
                                  //     'name': 'Product B',
                                  //     'quantity': 1,
                                  //     'price': 50.00
                                  //   },
                                  //   {
                                  //     'name': 'Product C',
                                  //     'quantity': 3,
                                  //     'price': 15.00
                                  //   },
                                  // ];
                                  //
                                  // final generator = InvoicePdfGenerator();
                                  // final filePath = await generator
                                  //     .generateInvoicePdf(invoiceData);
                                  //
                                  // print('Invoice PDF generated at: $filePath');

                                  // Get.to(const HomeScreen(), transition: Transition.rightToLeft);
                                  print(
                                      "data: ${_phoneNumberController.text} ${_passwordController.text}");

                                  if (_phoneNumberController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: NormalText(
                                        text: "Fill All the Fields",
                                        textSize: 14,
                                        textColor: kWhite,
                                      ),));
                                    // errorToast(
                                    //     "Please fill the credentials", context);
                                  } else {
                                    loginScreenController.signCustomerIn(
                                        userId: _phoneNumberController.text,
                                        password: _passwordController.text,
                                        context: context);
                                  }
                                },
                                backgroundColor: kPrimaryMain,
                                buttonText: signInCapitalized,
                                borderRadius: 0,
                                textColor: kWhite,
                              ),
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
                      //const SizedBox(height: 46),
                      const Expanded(child: SizedBox()),
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
