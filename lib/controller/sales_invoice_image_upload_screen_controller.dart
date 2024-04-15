import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/string_constants.dart';
import 'package:gstark/helper/network/common_model.dart';
import 'package:gstark/screens/sales_invoice/sales_invoice_screen.dart';
import 'package:gstark/utils/internet_utils.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import 'package:gstark/utils/toast_utils/success_toast.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/network_helper.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_preference/custom_shared_preference.dart';

class SalesInvoiceImageUploadScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxBool _isImageCaptured = RxBool(false);

  bool get isImageCaptured => _isImageCaptured.value;

  setIsImageCaptured(bool value) {
    _isImageCaptured.value = value;
  }

  Timer? salesInvoiceUploadApiCallTimer;

  salesInvoiceUploadApi(
      BuildContext context, File file, String fileName, String imagePath) {
    salesInvoiceUploadApiCall(context, file, fileName, imagePath);

    salesInvoiceUploadApiCallTimer =
        Timer(const Duration(seconds: 30), () async {
      setBusy(false);

      debugPrint('api is success');

      errorToast(tryAgainAfterSomeTime, Get.overlayContext ?? context,
          isShortDurationText: false);
      salesInvoiceUploadApiCallTimer?.cancel();

      Get.to(const SalesInvoiceScreen(), transition: Transition.rightToLeft);
    });
  }

  salesInvoiceUploadApiCall(BuildContext context, File file, String fileName,
      String imagePath) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String url = 'https://dev-api.gstark.co/api/document';
        /*String token = '';
        Map<String, String> headers = {'authorization': 'Bearer $token'};

        var request = http.MultipartRequest('POST', Uri.parse(url));
        // request.headers.addAll(headers);

        String id = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clienId);

        request.files.add(await http.MultipartFile.fromPath("file", file.path));
        request.fields["userId"] = id;
        request.fields["type"] = "sales";
        request.fields["description"] = "sales";*/

        String token =
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJnc3RuIjoiQUJDREVGR0hFUzEyMzQ1IiwidXNlcklkIjoiYzg3ZmJjMjUtZjE2OC00NDg4LTlmODctZjBiMDhiNWNiMzNjIiwiZW1haWwiOiJjbGllbnRfNzIwNDYzMTcwNUBnc3RhcmsuY29tIiwicm9sZXMiOlt7InR5cGUiOiJjcmVhdGUiLCJ0YXJnZXQiOiJkb2N1bWVudCJ9LHsidHlwZSI6InVwZGF0ZSIsInRhcmdldCI6ImRvY3VtZW50In1dLCJ1c2VyVHlwZSI6ImNsaWVudCIsImlhdCI6MTcxMTU1NzcyMCwiZXhwIjoxNzQzMDkzNzIwfQ.bBN_Gus7JnJ_Om34Qawm4Fs3ui_umQhL3blBfBBWoWo';
        Map<String, String> headers = {'authorization': token};
        Map<String, String> headers1 = {
          'x-header-token': 'client_7204631705@gstark.com'
        };

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);
        request.headers.addAll(headers1);

        String id = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clienId);

        request.files.add(await http.MultipartFile.fromPath("file", imagePath));
        request.fields["userId"] = 'c87fbc25-f168-4488-9f87-f0b08b5cb33c';
        request.fields["type"] = "purchase";
        request.fields["description"] = "purchase";

        var response = await request.send();

        print('Status Code : ${response.statusCode}');
        print(response.stream.toString());

        response.stream.bytesToString().asStream().listen((event) async {
          var parsedJson = json.decode(event);

          if (response.statusCode == 200 || response.statusCode == 201) {
            salesInvoiceUploadApiCallTimer?.cancel();
            setBusy(false);
            successToast(
                descriptionText: 'Sales Invoice Uploaded Successfully',
                context: context);

            Get.to(const SalesInvoiceScreen(),
                transition: Transition.rightToLeft);
          } else if (response.statusCode == 400) {
            salesInvoiceUploadApiCallTimer?.cancel();

            CommonModel commonModel = CommonModel.fromJson(parsedJson);
            if (commonModel.response != null) {
              errorToast(commonModel.response!, Get.overlayContext ?? context);
            } else {
              salesInvoiceUploadApiCallTimer?.cancel();
              errorToast(somethingWentWrong, Get.overlayContext ?? context);
            }

            setBusy(false);
          } else if (response.statusCode == 401) {
            salesInvoiceUploadApiCallTimer?.cancel();
            await apiService.storeJwt(false);

            salesInvoiceUploadApiCall(
                Get.overlayContext ?? context, file, fileName, imagePath);
            setBusy(false);
          } else {
            salesInvoiceUploadApiCallTimer?.cancel();
            errorToast(somethingWentWrong, context);
            setBusy(false);
          }
        });
      } catch (e) {
        debugPrint(e.toString());
        salesInvoiceUploadApiCallTimer?.cancel();
        setBusy(false);
        rethrow;
      }
    } else {
      salesInvoiceUploadApiCallTimer?.cancel();
      setBusy(false);
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      return false;
    }
  }
}
