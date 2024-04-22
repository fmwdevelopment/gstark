import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/models/login_response_model.dart';
import 'package:gstark/screens/authentication/login_screen.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import 'package:gstark/utils/toast_utils/success_toast.dart';

import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/internet_utils.dart';

class ForgotPasswordController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  void resetPassword(
      {required String phoneNumber,
      required String gstn,
      required String securityAnswer,
      required String password,
      required BuildContext context}) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();

    if (isConnectedToInternet) {
      try {
        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.resetPasswordApi,
            Get.overlayContext ?? context,
            body: {
              "phone": phoneNumber,
              "udin": gstn,
              "security_answer": securityAnswer,
              "password": password
            });

        if (value.statusCode == 200 && value.response != null) {
          LoginResponseModel loginResponseModel =
              LoginResponseModel.fromJson(value.response);
          if (loginResponseModel.response != null) {
            /// LoginResponseModel need to be change
            successToast(descriptionText: "Password reset successful", context: context);
            Get.to(const LoginScreen(), transition: Transition.rightToLeft);
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
