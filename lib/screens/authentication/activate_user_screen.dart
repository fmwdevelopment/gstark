import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../controller/register_screen_controller.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';
import 'login_screen_loader.dart';
import '../../widgets/button.dart';

class ActivateUserScreen extends StatefulWidget {
  const ActivateUserScreen({Key? key}) : super(key: key);

  @override
  State<ActivateUserScreen> createState() => _ActivateUserScreenState();
}

class _ActivateUserScreenState extends State<ActivateUserScreen> {
  final _phoneNumberController = TextEditingController();
  final _gstController = TextEditingController();
  final _birthplaceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
              constraints:
              BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      const NormalText(
                        text: "Register User",
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
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Your birth place",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _birthplaceController,
                        hintText: "Enter your birth place",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Password",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _passwordController,
                        hintText: "Enter Password",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Confirm Password",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 8),
                      InputTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 24),

                      Obx(() => registerScreenController.isBusy ?Button(
                        onPress: () {},
                        backgroundColor: Colors.grey,
                        buttonText: "Activating...",
                        borderRadius: 0,
                        textColor: kPrimaryBlack,
                      )
                          :Button(
                        onPress: () async {
                             if(_phoneNumberController.text.isEmpty || _gstController.text.isEmpty || _birthplaceController.text.isEmpty
                             || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty){
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                 backgroundColor: Colors.red,
                                 content: NormalText(
                                 text: "Fill All the Fields",
                                 textSize: 14,
                                 textColor: kWhite,
                               ),));
                             }else{
                               registerScreenController.activateUser(confirmPassword: _confirmPasswordController.text,
                                   gstn: _gstController.text,
                                   phone: _phoneNumberController.text ,
                                   password: _passwordController.text ,
                                   securityAnswer: _birthplaceController.text,
                                   context: context);
                             }

                        },
                        backgroundColor: kPrimaryMain,
                        buttonText: "REGISTER",
                        borderRadius: 0,
                        textColor: kWhite,
                      ),),


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
