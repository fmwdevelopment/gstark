import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gstark/helper/network/api_end_point.dart';
import 'package:gstark/screens/purchase_inovice/purchase_invoice_screen.dart';
import 'package:http_parser/http_parser.dart';
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

import '../utils/image_type_getter.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class PurchaseInvoiceImageUploadScreenController extends GetxController {
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

  Timer? purchaseInvoiceUploadApiCallTimer;

  salesInvoiceUploadApi(
      BuildContext context, File file, String fileName, String imagePath) {
    purchaseInvoiceUploadApiCall(context, file, fileName, imagePath);

   purchaseInvoiceUploadApiCallTimer =
        Timer(const Duration(seconds: 30), () async {
          setBusy(false);

          debugPrint('api is success');

          errorToast(tryAgainAfterSomeTime, Get.overlayContext ?? context,
              isShortDurationText: false);
          purchaseInvoiceUploadApiCallTimer?.cancel();

          Get.to(const PurchaseInvoiceScreen(), transition: Transition.rightToLeft);
        });
  }

  purchaseInvoiceUploadApiCall(BuildContext context, File file, String fileName,
      String imagePath) async {
    setBusy(true);

    String authToken = await CustomSharedPref.getPref(SharedPreferenceString.authToken);
    String email = await CustomSharedPref.getPref(SharedPreferenceString.email);
    String userId = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.clientId);

    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String url = ApiEndPoint.baseUrl + ApiEndPoint.purchaseInvoiceImageUploadApi;
        String token =
            'Bearer $authToken';
        Map<String, String> headers = {'authorization': token};
        Map<String, String> headers1 = {
          'x-header-token': email
        };

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);
        request.headers.addAll(headers1);



        //request.files.add(await http.MultipartFile.fromPath("file", imagePath));
        String imageType = getImageType(fileName);
        request.files.add(http.MultipartFile.fromBytes(
            'file', File(imagePath).readAsBytesSync(),
            contentType: MediaType('image', imageType), filename: fileName));

        request.fields["userId"] = userId ; //'c87fbc25-f168-4488-9f87-f0b08b5cb33c';
        request.fields["type"] = "purchase";
        request.fields["description"] = "purchase";

        var response = await request.send();

        print('Status Code : ${response.statusCode}');
        print(response.stream.toString());

        response.stream.bytesToString().asStream().listen((event) async {
          var parsedJson = json.decode(event);

          if (response.statusCode == 200 || response.statusCode == 201) {
            purchaseInvoiceUploadApiCallTimer?.cancel();
            setBusy(false);
            successToast(
                descriptionText: 'Purchase Invoice Uploaded Successfully',
                context: context);

            Get.off(const PurchaseInvoiceScreen(),
                transition: Transition.rightToLeft);

          } else if (response.statusCode == 400) {
            purchaseInvoiceUploadApiCallTimer?.cancel();

            CommonModel commonModel = CommonModel.fromJson(parsedJson);
            if (commonModel.response != null) {
              errorToast(commonModel.response!, Get.overlayContext ?? context);
            } else {
              purchaseInvoiceUploadApiCallTimer?.cancel();
              errorToast(somethingWentWrong, Get.overlayContext ?? context);
            }

            setBusy(false);
          } else if (response.statusCode == 401) {
            purchaseInvoiceUploadApiCallTimer?.cancel();
            await apiService.storeJwt(false);

            purchaseInvoiceUploadApiCall(
                Get.overlayContext ?? context, file, fileName, imagePath);
            setBusy(false);
          } else {
            purchaseInvoiceUploadApiCallTimer?.cancel();
            errorToast(somethingWentWrong, context);
            setBusy(false);
          }
        });
      } catch (e) {
        debugPrint(e.toString());
        purchaseInvoiceUploadApiCallTimer?.cancel();
        setBusy(false);
        rethrow;
      }
    } else {
      purchaseInvoiceUploadApiCallTimer?.cancel();
      setBusy(false);
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      return false;
    }
  }
}
