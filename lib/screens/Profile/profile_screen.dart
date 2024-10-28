import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/constants/shared_preference_string.dart';
import 'package:gstark/controller/profile_screen_controller.dart';
import 'package:gstark/screens/Profile/update_profile_screen_loader.dart';
import 'package:gstark/utils/shared_preference/custom_shared_preference.dart';
import 'package:gstark/utils/validation_utils/upper_case_text_formatter.dart';
import 'package:gstark/widgets/input_textfield.dart';
import '../../constants/app_decorations.dart';
import '../../constants/string_constants.dart';
import '../../controller/update_user_controller.dart';
import '../../widgets/button_widget.dart';
import '../../constants/app_colors.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _addressController = TextEditingController();

  bool enableName = false;
  bool enablePhoneNumber = false;
  bool enableGST = false;
  bool enableEmail = false;
  bool enableAddress = false;

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
    profileScreenController.setIsChanged(false);
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

    _nameController.text = name;
    _phoneNumberController.text = phoneNumber;
    _gstController.text = gstn;
    _emailController.text = email;
    _addressController.text = address;
  }

  Future<void> _makingPhoneCall() async {
    var url = Uri.parse("tel:7676940879");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: kWhite, size: 24 //change your color here
                ),
        backgroundColor: kPrimary300,
        title: const NormalText(
          text: "Profile",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
          textColor: kWhite,
        ),
        centerTitle: true,
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         color: kWhite, borderRadius: BorderRadius.circular(8)),
        //     child: profileScreenController.isChanged == true
        //         ? IconButton(
        //             onPressed: () {
        //               updateUserController.updateUser(
        //                   phoneNumber: _phoneNumberController.text,
        //                   gstn: _gstController.text,
        //                   email: _emailController.text,
        //                   name: _nameController.text,
        //                   address: _addressController.text,
        //                   context: context);
        //             },
        //             icon: const NormalText(
        //               text: "Save",
        //               textAlign: TextAlign.center,
        //               textFontWeight: FontWeight.w500,
        //               textSize: 16,
        //               textColor: kApplicationThemeColor,
        //             ))
        //         : TextButton(
        //             onPressed: () {},
        //             child: const NormalText(
        //               text: "Save",
        //               textAlign: TextAlign.center,
        //               textFontWeight: FontWeight.w500,
        //               textSize: 16,
        //               textColor: kPrimary100,
        //             )),
        //   )
        // ],
      ),
      body: Obx(() => updateUserController.isBusy
          ? const UpdateProfileScreenLoader()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: containerBottomCurvedDecoration,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                enableName = true;
                                enablePhoneNumber = true;
                                enableGST = true;
                                enableEmail =true;
                                enableAddress = true;
                                profileScreenController.setIsChanged(true);
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left:2.0),
                                  child: NormalText(text: "Edit"),
                                )
                              ],
                            ),
                          ),
                          const NormalText(
                            text: "Name",
                            textSize: 14,
                            textColor: kNeutral400,
                          ),
                          const SizedBox(height: 5),
                          InputTextField(
                            controller: _nameController,
                            hintText: "Name",
                            obscureText: false,
                            autofocus: false,
                            onChanged: (_) {
                              profileScreenController.setIsChanged(true);
                            },
                            enable: enableName,
                          ),
                          const SizedBox(height: 16),
                          const NormalText(
                            text: "Phone Number",
                            textSize: 14,
                            textColor: kNeutral400,
                          ),
                          const SizedBox(height: 5),
                          InputTextField(
                            controller: _phoneNumberController,
                            hintText: "Phone Number",
                            obscureText: false,
                            autofocus: false,
                            onChanged: (_) {
                              profileScreenController.setIsChanged(true);
                            },
                            enable: enablePhoneNumber,
                          ),
                          const SizedBox(height: 16),
                          const NormalText(
                            text: "GST Number",
                            textSize: 14,
                            textColor: kNeutral400,
                          ),
                          const SizedBox(height: 5),
                          InputTextField(
                            controller: _gstController,
                            hintText: "GST Number",
                            obscureText: false,
                            autofocus: false,
                            onChanged: (_) {
                              profileScreenController.setIsChanged(true);
                            },
                            enable: enableGST,
                            inputParamter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[A-Za-z0-9]")),
                              // Only allow uppercase letters and digits
                              LengthLimitingTextInputFormatter(15),
                              UpperCaseTextFormatter()
                            ],
                          ),
                          const SizedBox(height: 16),
                          const NormalText(
                            text: "Email Address",
                            textSize: 14,
                            textColor: kNeutral400,
                          ),
                          const SizedBox(height: 5),
                          InputTextField(
                            controller: _emailController,
                            hintText: "Email",
                            obscureText: false,
                            autofocus: false,
                            onChanged: (_) {
                              profileScreenController.setIsChanged(true);
                            },
                            enable: enableEmail,
                          ),
                          const SizedBox(height: 16),
                          const NormalText(
                            text: "Address",
                            textSize: 14,
                            textColor: kNeutral400,
                          ),
                          const SizedBox(height: 5),
                          InputTextField(
                            controller: _addressController,
                            hintText: "Address",
                            obscureText: false,
                            autofocus: false,
                            onChanged: (_) {
                              profileScreenController.setIsChanged(true);
                            },
                            enable: enableAddress,
                          ),
                          Center(
                            child: Row(
                              children: [
                                const NormalText(
                                  text: "CUSTOMER CONTACT:",
                                  textSize: 14,
                                ),
                                TextButton(
                                    onPressed: _makingPhoneCall,
                                    child: const NormalText(
                                      text: "7676940879",
                                      textSize: 16,
                                      textColor: kApplicationThemeColor,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          profileScreenController.isChanged == true
                              ? Center(
                                  child: ButtonWidget(
                                      onPress: () async {
                                        updateUserController.updateUser(
                                            phoneNumber:
                                                _phoneNumberController.text,
                                            gstn: _gstController.text,
                                            email: _emailController.text,
                                            name: _nameController.text,
                                            address: _addressController.text,
                                            context: context);

                                        enableName = false;
                                        enablePhoneNumber = false;
                                        enableGST = false;
                                        enableEmail = false;
                                        enableAddress = false;
                                        profileScreenController
                                            .setIsChanged(false);
                                      },
                                      backgroundColor: kApplicationThemeColor,
                                      buttonText: "Save",
                                      borderRadius: 10,
                                      textColor: kWhite,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width),
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ButtonWidget(
                                onPress: () async {
                                  CustomSharedPref.setPref<bool>(
                                      SharedPreferenceString.isLoggedIn, false);
                                  profileScreenController.setIsChanged(false);
                                  Get.offAll(const SplashScreen(),
                                      transition: Transition.leftToRight);
                                },
                                backgroundColor: kApplicationThemeColor,
                                buttonText: logOut,
                                borderRadius: 10,
                                textColor: kWhite,
                                buttonWidth: MediaQuery.of(context).size.width),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _gstController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
