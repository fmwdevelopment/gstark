import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/register_screen_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../utils/text_utils/normal_text.dart';
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
                    text: "Validate User",
                    textSize: 20,
                    textColor: kApplicationThemeColor,
                    textFontWeight: FontWeight.w600),
                const SizedBox(height: 16),
                const NormalText(
                    text: "Phone Number",
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: NormalText(
                                  text: "Fill All the Fields",
                                  textSize: 14,
                                  textColor: kWhite,
                                ),
                              ));
                            }
                            registerScreenController.validateUser(
                                phone: _phoneNumberController.text,
                                gstn: _gstController.text,
                                context: context);

                            //Get.to(ActivateUserScreen(),transition: Transition.rightToLeft);
                          },
                          buttonText: "VALIDATE",
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
        ],
      ),
    ));
  }
}
