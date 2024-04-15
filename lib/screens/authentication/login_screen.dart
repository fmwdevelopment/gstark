import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/login_screen_controller.dart';
import 'package:gstark/screens/authentication/register_user_screen.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/invoice_pdf_generator.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
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
  bool _obscureText = false;

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
            height: MediaQuery.of(context).size.height * 0.5,
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
                    textFontWeight: FontWeight.w700,
                    textSize: 38,
                    textColor: kWhite,
                  ),
                  Container(
                    decoration: curvedEdgeContainerDecoration,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const NormalText(
                            text: login,
                            textSize: 30,
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
                            text: password,
                            textColor: kBlackColor,
                            textFontWeight: FontWeight.w600),
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
                              color: kApplicationThemeColor,
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
                                textColor: kApplicationThemeColor,
                                textSize: 16,
                                textFontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 46),
                        Obx(
                          () => Button(
                            onPress: () async {
                              /*if (!loginScreenController.isBusy) {
                                print(
                                    "data: ${_phoneNumberController.text} ${_passwordController.text}");

                                if (_phoneNumberController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  errorToast(pleaseFillTheCredentials, context);
                                } else {
                                  loginScreenController.signCustomerIn(
                                      userId: _phoneNumberController.text,
                                      password: _passwordController.text,
                                      context: context);
                                }
                              }*/

                              // loginScreenController.signCustomerIn(
                              //     email: _emailController.text,
                              //     password: _passwordController.text,
                              //     context: context);
                              final invoiceData = {
                                'customer_name': 'John Doe',
                                'customer_address': '123 Main St',
                                'invoice_date': 'Mar 27, 2024',
                                'invoice_no': '6884876403',
                                'total_before_tax': 100.00,
                                'total_tax': 18.00,
                                'total_after_tax': 118.00,
                                'items': [
                                  {
                                    'name': 'Product A',
                                    'quantity': 2,
                                    'price': 25.00,
                                    'tax': 18
                                  },
                                  {
                                    'name': 'Product B',
                                    'quantity': 1,
                                    'price': 50.00,
                                    'tax': 18
                                  },
                                  {
                                    'name': 'Product C',
                                    'quantity': 3,
                                    'price': 15.00,
                                    'tax': 5
                                  },
                                ]
                              };

                              final generator = InvoicePdfGenerator();
                              final filePath = await generator.generateInvoicePdf(
                                  'Apollo Pharmaceutical Lab. LTD.',
                                  'Central Sales Depo: Plot # 11, Block # Ka, Main Road-1, Section # 6, Mirpur, Dhaka 1216, Bangladesh\nTel:- +88 02 9030747, 9001794, 9025719, Fax:- +88 02 900 713\nMobile:- 01711-697995',
                                  invoiceData);

                              print('Invoice PDF generated at: $filePath');
                            },
                            buttonText: loginScreenController.isBusy
                                ? "Signing In..."
                                : signIn,
                            fontSize: 18,
                            backgroundColor: loginScreenController.isBusy
                                ? kPrimary200
                                : kApplicationThemeColor,
                            borderColor: loginScreenController.isBusy
                                ? kPrimary200
                                : kApplicationThemeColor,
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
          )
        ],
      ),
    ));
  }
}
