import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/constants/shared_preference_string.dart';
import 'package:gstark/controller/profile_screen_controller.dart';
import 'package:gstark/utils/shared_preference/custom_shared_preference.dart';
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

  @override
  void initState() {
    super.initState();
    profileScreenController = Get.isRegistered<ProfileScreenController>()
        ? Get.find<ProfileScreenController>()
        : Get.put(ProfileScreenController());

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
        await CustomSharedPref.getPref<String>(SharedPreferenceString.clienId);
    String name = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.clientName);

    profileScreenController.setReviewerId(reviewerId);
    profileScreenController.setPhoneNumber(phoneNumber);
    profileScreenController.setGSTN(gstn);
    profileScreenController.setEmail(email);
    profileScreenController.setClientId(id);
    profileScreenController.setClientName(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NormalText(
          text: "Profile",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const NormalText(
                  text: "Name",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.clientName,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                const NormalText(
                  text: "Phone Number",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.phoneNumber,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                const NormalText(
                  text: "GST Number",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.gstn,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                const NormalText(
                  text: "Email Address",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.email,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                const NormalText(
                  text: "ID",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.clientId,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 16),
                const NormalText(
                  text: "Reviewer Id",
                  textSize: 14,
                  textColor: kNeutral400,
                ),
                NormalText(
                  text: profileScreenController.reviewerId,
                  textAlign: TextAlign.center,
                  textSize: 16,
                ),
                const Divider(
                  thickness: 1,
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
                    backgroundColor: kPrimaryMain,
                    buttonText: "LOGOUT",
                    borderRadius: 0,
                    textColor: kWhite,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
