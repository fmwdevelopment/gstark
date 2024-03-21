import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/models/login_response_model.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';

import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';

class LoginScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  void signCustomerIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    setBusy(true);
    // bool isConnectedToInternet = await checkIsConnectedToInternet();

    if (true) {
      try {
        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.loginApi,
            Get.overlayContext ?? context,
            body: {"userid": email, "password": password});

        if (value.statusCode == 200 && value.response != null) {
          LoginResponseModel loginResponseModel =
              LoginResponseModel.fromJson(value.response);
          if (loginResponseModel.response != null) {
            print('hello ${loginResponseModel.response!.email}');
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
