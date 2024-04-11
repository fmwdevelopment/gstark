import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gstark/models/purchase_invoice_list_response_model.dart';
import '../helper/network/network_helper.dart';
import '../models/sales_inovice_list_response_model.dart';
import '../utils/internet_utils.dart';

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
        var value = await apiService.get(
            "https://run.mocky.io/v3/ebead191-e28c-4df7-98fb-a45f23432f6c",
            Get.overlayContext ?? context);
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
