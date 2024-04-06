import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/login_screen_controller.dart';
import 'package:gstark/utils/invoice_pdf_generator.dart';

import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
import '../../widgets/input_textfield.dart';
import 'login_screen_loader.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_page';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? errorMessage;
  late final LoginScreenController loginScreenController;

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
      body: Obx(() => loginScreenController.isBusy
          ? const Center(
              child: LoginScreenLoader(),
            )
          : LayoutBuilder(
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
                            const NormalText(
                              text: hiWelcomeBack,
                              textAlign: TextAlign.center,
                              textFontWeight: FontWeight.w700,
                              textSize: 24,
                            ),
                            const SizedBox(height: 24),
                            const NormalText(
                              text: email,
                              textSize: 14,
                              textColor: kNeutral400,
                            ),
                            const SizedBox(height: 8),
                            InputTextField(
                              controller: _emailController,
                              hintText: enterYourEmail,
                              obscureText: false,
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
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
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
                            Button(
                              onPress: () async {
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
                              backgroundColor: kPrimaryMain,
                              buttonText: signInCapitalized,
                              borderRadius: 0,
                              textColor: kWhite,
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
                                  onTap: () {},
                                  child: const NormalText(
                                    text: signUp,
                                    textSize: 16,
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
            )),
    );
  }
}
