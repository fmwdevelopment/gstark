import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/screens/Profile/profile_screen.dart';
import 'package:gstark/screens/authentication/login_screen.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import 'package:gstark/utils/toast_utils/success_toast.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class UpdateUserController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  void updateUser(
      {required String phoneNumber,
      required String gstn,
      required String email,
      required String name,
      required String address,
      required BuildContext context}) async {
    setBusy(true);

    bool isConnectedToInternet = await checkIsConnectedToInternet();


    if (isConnectedToInternet) {
      try {
        String authToken = await CustomSharedPref.getPref(SharedPreferenceString.authToken);
        String email = await CustomSharedPref.getPref(SharedPreferenceString.email);
        String userId = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clientId);

        Map<String, dynamic> responseBody =  {
           "id": userId,
           "name": name,
           "email": email,
           "phone": phoneNumber,
           "address": address,
           "gstn": gstn
         };

        var value = await apiService.put(
            ApiEndPoint.updateUserDataApi,
            Get.overlayContext ?? context,
            body:responseBody,
            headers: {
              'x-header-token': email,
              'authorization': 'Bearer $authToken',
              'Content-Type':"application/json",
            });

        if (value.statusCode == 200 && value.response != null) {
          successToast(descriptionText: "Updated user data", context: context);

          CustomSharedPref.setPref<String>(
              SharedPreferenceString.phoneNumber, phoneNumber ?? "");

          CustomSharedPref.setPref<String>(
              SharedPreferenceString.gstNumber, gstn ?? "");

          CustomSharedPref.setPref<String>(
              SharedPreferenceString.clientName, name ?? "");

          CustomSharedPref.setPref<String>(
              SharedPreferenceString.email, email ?? "");

          CustomSharedPref.setPref<String>(
              SharedPreferenceString.clientAddress, address ?? "");

          setBusy(false);
          Get.off(const ProfileScreen(), transition: Transition.rightToLeft);

        } else {
          setBusy(false);
        }
      } catch (e) {
        print("Error: $e");
        setBusy(false);
      }
    } else {
      print("err");
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      setBusy(false);
    }
  }
}
