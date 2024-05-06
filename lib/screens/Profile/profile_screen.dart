import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/constants/shared_preference_string.dart';
import 'package:gstark/controller/profile_screen_controller.dart';
import 'package:gstark/utils/shared_preference/custom_shared_preference.dart';
import 'package:gstark/widgets/input_textfield.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../controller/update_user_controller.dart';
import '../../widgets/button.dart';
import '../../constants/app_colors.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileScreenController profileScreenController;
  late final UpdateUserController updateUserController;

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _gstController = TextEditingController();
  final _emailController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _reviewerIdController = TextEditingController();
  final _addressIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileScreenController = Get.isRegistered<ProfileScreenController>()
        ? Get.find<ProfileScreenController>()
        : Get.put(ProfileScreenController());
    updateUserController = Get.isRegistered<UpdateUserController>()
        ? Get.find<UpdateUserController>()
        : Get.put(UpdateUserController());

    initCall();
  }

  initCall() async {
    String reviewerId = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.reviewerId);
    String phoneNumber = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.phoneNumber);
    String gstn = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.gstNumber);
    String email =
        await CustomSharedPref.getPref<String>(SharedPreferenceString.email);
    String id =
        await CustomSharedPref.getPref<String>(SharedPreferenceString.clientId);
    String name = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.clientName);
    String address = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.clientAddress);

    profileScreenController.setReviewerId(reviewerId);
    profileScreenController.setPhoneNumber(phoneNumber);
    profileScreenController.setGSTN(gstn);
    profileScreenController.setEmail(email);
    profileScreenController.setClientId(id);
    profileScreenController.setClientName(name);
    profileScreenController.setClientAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: kWhite, size: 24 //change your color here
                ),
        backgroundColor: kApplicationThemeColor,
        title: const NormalText(
          text: "Profile",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w700,
          textSize: 24,
          textColor: kWhite,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: kWhite)),
            child: TextButton(
                onPressed: () {
                    updateUserController.updateUser(phoneNumber: _phoneNumberController.text,
                        gstn: _gstController.text, email: _emailController.text,
                        name: _nameController.text, address: _addressIdController.text,
                        context: context);

                },
                child: const NormalText(
                    text: "Save",
                    textColor: kWhite,
                    textSize: 20,
                    textFontWeight: FontWeight.w600)),
          )
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: containerBottomCurvedDecoration,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NormalText(
                        text: "Name",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 5),
                      InputTextField(
                        controller: _nameController
                          ..text = profileScreenController.clientName,
                        hintText: "Name",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Phone Number",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 5),
                      InputTextField(
                        controller: _phoneNumberController
                          ..text = profileScreenController.phoneNumber,
                        hintText: "Phone Number",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "GST Number",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 5),
                      InputTextField(
                        controller: _gstController
                          ..text = profileScreenController.gstn,
                        hintText: "GST Number",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Email Address",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 5),
                      InputTextField(
                        controller: _emailController
                          ..text = profileScreenController.email,
                        hintText: "Email",
                        obscureText: false,
                        autofocus: false,
                      ),
                      // const SizedBox(height: 16),
                      // const NormalText(
                      //   text: "ID",
                      //   textSize: 14,
                      //   textColor: kNeutral400,
                      // ),
                      // const SizedBox(height: 5),
                      // InputTextField(
                      //   controller: _clientIdController
                      //     ..text = profileScreenController.clientId,
                      //   hintText: "Client ID",
                      //   obscureText: false,
                      //   autofocus: false,
                      // ),
                      const SizedBox(height: 16),
                      const NormalText(
                        text: "Address",
                        textSize: 14,
                        textColor: kNeutral400,
                      ),
                      const SizedBox(height: 5),
                      InputTextField(
                        controller: _addressIdController
                          ..text = profileScreenController.clientAddress,
                        hintText: "Address",
                        obscureText: false,
                        autofocus: false,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Button(
                          onPress: () async {
                            CustomSharedPref.setPref<bool>(
                                SharedPreferenceString.isLoggedIn, false);
                            Get.off(const SplashScreen(),
                                transition: Transition.leftToRight);
                          },
                          backgroundColor: kApplicationThemeColor,
                          buttonText: logOut,
                          borderRadius: 18,
                          textColor: kWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
