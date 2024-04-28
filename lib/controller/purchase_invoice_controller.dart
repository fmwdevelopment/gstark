import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gstark/models/purchase_invoice_list_response_model.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../models/sales_inovice_list_response_model.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class PurchaseInvoiceController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getAllPurchaseInvoice(context);
    });
  }

  final RxList<PurchaseDocuments> _purchaseData = RxList();

  List<PurchaseDocuments> get purchaseData => _purchaseData.value;

  setPurchaseList(List<PurchaseDocuments> value) {
    _purchaseData.value = value;
  }

  getAllPurchaseInvoice(BuildContext context) async {
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
            ApiEndPoint.baseUrl + ApiEndPoint.purchaseInvoiceListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": userId,
              "month": null,
              "type": "purchase"
            },
            headers: {
              'x-header-token': email,
              'authorization': token,
              'Content-Type':"application/json",
            }
        );
        if (value.statusCode == 200 || value.statusCode == 201) {
          PurchaseInvoiceListResponseModel purchaseInvoiceListResponseModel =
          PurchaseInvoiceListResponseModel.fromJson(value.response);
          setPurchaseList(
              purchaseInvoiceListResponseModel.response!.documents ?? []);

          print(_purchaseData);
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
