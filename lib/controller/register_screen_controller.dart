import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import 'package:gstark/utils/toast_utils/success_toast.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../models/activate_user_request_model.dart';
import '../models/activate_user_success_response_model.dart';
import '../models/validate_user_response_model.dart';
import '../screens/authentication/login_screen.dart';
import '../utils/internet_utils.dart';

class RegisterScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxBool _isValidated = RxBool(false);

  bool get isValidated => _isValidated.value;

  setIsValidated(bool value) {
    _isValidated.value = value;
  }

  void activateUser(
      {required String confirmPassword,
      required String gstn,
      required String phone,
      required String password,
      required String securityAnswer,
      required String address,

      required BuildContext context}) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();

    ActivateUserRequestModel registerRequestModel = ActivateUserRequestModel(
      confirmPassword: confirmPassword,
      gstn: gstn,
      phone: phone,
      password: password,
      securityAnswer: securityAnswer,
      address: address
    );

    if (isConnectedToInternet) {
      try {
        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.activateApi,
            Get.overlayContext ?? context,
            body: registerRequestModel.toJson());

        if (value.statusCode == 200 && value.response != null) {
          ActivateUserSuccessResponseModel activateUserSuccessResponseModel =
          ActivateUserSuccessResponseModel.fromJson(value.response);
          if (activateUserSuccessResponseModel.response != null && activateUserSuccessResponseModel.status == true) {
            // print('hello ${activateUserResponseModel.response!.activate}');
            successToast(
                descriptionText: activateUserSuccessResponseModel.response?.activate ??
                    'Activated Successfully',
                context: Get.overlayContext ?? context);
            Get.off(const LoginScreen(), transition: Transition.leftToRight);
          }
          setBusy(false);
        } else {
          errorToast(value.response, Get.overlayContext ?? context);
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

  void validateUser(
      {required String phone,
      required String gstn,
      required BuildContext context}) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();

    if (isConnectedToInternet) {
      try {
        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.validateApi,
            Get.overlayContext ?? context,
            body: {"phone": phone, "gstn": gstn});

        if (value.statusCode == 200 && value.response != null) {
          ValidateUserResponseModel validateUserResponseModel =
              ValidateUserResponseModel.fromJson(value.response);

          if (validateUserResponseModel.response != null) {
            if(validateUserResponseModel.status != null && validateUserResponseModel.status! == true){
              setIsValidated(true);
            }else{
              setIsValidated(false);
              errorToast(value.response, context);
            }
          }
          setBusy(false);
        } else {
          setIsValidated(false);
          errorToast(value.response, Get.overlayContext ?? context);
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
