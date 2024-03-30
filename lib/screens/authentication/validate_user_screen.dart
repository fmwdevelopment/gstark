import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/controller/register_screen_controller.dart';
import 'package:gstark/screens/authentication/activate_user_screen.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../controller/login_screen_controller.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';
import 'login_screen_loader.dart';
import '../../widgets/button.dart';

class ValidateUserScreen extends StatefulWidget {
  const ValidateUserScreen({Key? key}) : super(key: key);

  @override
  State<ValidateUserScreen> createState() => _ValidateUserScreenState();
}

class _ValidateUserScreenState extends State<ValidateUserScreen> {
  final _phoneNumberController = TextEditingController();
  final _gstController = TextEditingController();

  String? errorMessage;
  late final RegisterScreenController registerScreenController;

  @override
  void initState() {
    super.initState();
    registerScreenController = Get.isRegistered<RegisterScreenController>()
        ? Get.find<RegisterScreenController>()
        : Get.put(RegisterScreenController());
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
                      const SizedBox(height: 96),
                      const NormalText(
                        text: "Validate User",
                        textAlign: TextAlign.center,
                        textFontWeight: FontWeight.w700,
                        textSize: 24,
                      ),
                      const SizedBox(height: 32),
                      const NormalText(
                        text: "Phone Number",
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
                      const SizedBox(height: 24),
                      Obx(
                        () => registerScreenController.isBusy
                            ? Button(
                                onPress: () {},
                                backgroundColor: Colors.grey,
                                buttonText: "Validating...",
                                borderRadius: 0,
                                textColor: kPrimaryBlack,
                              )
                            : Button(
                                onPress: () async {
                                  if (_phoneNumberController.text.isEmpty ||
                                      _gstController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: NormalText(
                                        text: "Fill All the Fields",
                                        textSize: 14,
                                        textColor: kWhite,
                                      ),));
                                  }
                                  registerScreenController.validateUser(
                                      phone: _phoneNumberController.text,
                                      gstn: _gstController.text,
                                      context: context);

                                  //Get.to(ActivateUserScreen(),transition: Transition.rightToLeft);
                                },
                                backgroundColor: kPrimaryMain,
                                buttonText: "VALIDATE",
                                borderRadius: 0,
                                textColor: kWhite,
                              ),
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
