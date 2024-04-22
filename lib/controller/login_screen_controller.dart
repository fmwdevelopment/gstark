import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/shared_preference_string.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/models/login_response_model.dart';
import 'package:gstark/utils/shared_preference/custom_shared_preference.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';

import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../screens/Home/home_screen.dart';
import '../utils/internet_utils.dart';

class LoginScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  void signCustomerIn(
      {required String userId,
      required String password,
      required BuildContext context}) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();

    if (isConnectedToInternet) {
      try {
        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.loginApi,
            Get.overlayContext ?? context,
            body: {"userid": userId, "password": password});

        if (value.statusCode == 200 && value.response != null) {
          LoginResponseModel loginResponseModel =
              LoginResponseModel.fromJson(value.response);
          if (loginResponseModel.response != null) {
            CustomSharedPref.setPref<bool>(
                SharedPreferenceString.isLoggedIn, true);

            CustomSharedPref.setPref<String>(SharedPreferenceString.reviewerId,
                loginResponseModel.response?.reviewerId ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.phoneNumber,
                loginResponseModel.response?.phone ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.gstNumber,
                loginResponseModel.response?.gstn ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.clientName,
                loginResponseModel.response?.name ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.clientId,
                loginResponseModel.response?.id ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.email,
                loginResponseModel.response?.email ?? "");

            CustomSharedPref.setPref<String>(SharedPreferenceString.authToken,
                loginResponseModel.response?.jwt ?? "");

            CustomSharedPref.setPref<String>(
                SharedPreferenceString.securityAnswer,
                loginResponseModel.response?.securityAnswer ?? "");

            CustomSharedPref.setPref<String>(
                SharedPreferenceString.clientAddress,
                "GStark, Plot # 11, 2nd cross rd, Munireddy Layout,GB Palya, Bengaluru, India" ?? "");

            Get.to(const HomeScreen(), transition: Transition.rightToLeft);
          }
          setBusy(false);
        } else {
          setBusy(false);
        }
      } catch (e) {
        setBusy(false);
      }
    } else {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      setBusy(false);
    }
  }
}
