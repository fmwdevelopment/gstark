import 'package:get/get.dart';

import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import 'package:flutter/material.dart';

import '../models/gst_returns_response_model.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class GSTReturnController extends GetxController{
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getAllGSTReturns(context);
    });
  }

  final RxList<ReturnsDocuments> _returnsData = RxList();
  List<ReturnsDocuments> get returnsData => _returnsData.value;
  setSalesList(List<ReturnsDocuments> value) {
    _returnsData.value = value;
  }

  getAllGSTReturns(BuildContext context) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String authToken = await CustomSharedPref.getPref(SharedPreferenceString.authToken);
        String email = await CustomSharedPref.getPref(SharedPreferenceString.email);
        String userId = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clientId);

        String token =
            'Bearer $authToken';

        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.gstReturnsListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": userId,
              "month": null,
              "type": "gstfiled"
            },
            headers: {
              'x-header-token': email,
              'authorization': token,
              'Content-Type':"application/json",
            }

        );

        if (value.statusCode == 200 || value.statusCode == 201) {
          GSTReturnsResponseModel gstReturnsResponseModel =
          GSTReturnsResponseModel.fromJson(value.response);
          setSalesList(gstReturnsResponseModel.response!.documents ?? []);

          print(_returnsData);
          setBusy(false);
        } else {
          setBusy(false);
        }
      } catch (e) {
        debugPrint(e.toString());
        setBusy(false);
        rethrow;
      }
    }
  }
}