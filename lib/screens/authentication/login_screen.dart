import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/login_screen_controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
import '../../widgets/input_textfield.dart';

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
              child: NormalText(
                text: 'Loading...',
              ),
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
                              onPress: () {
                                loginScreenController.signCustomerIn(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
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
