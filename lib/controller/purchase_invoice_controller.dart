
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../helper/network/network_helper.dart';
import '../models/sales_inovice_list_response_model.dart';

class PurchaseInvoiceController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxList<Documents>  _purchaseData = RxList();
  List<Documents> get purchaseData => _purchaseData.value;
  setPurchaseList(List<Documents> value){
    _purchaseData.value = value;
  }


  getAllPurchaseInvoice(BuildContext context) async {
    setBusy(true);
    // bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (true) {
      try {
        var value = await apiService.get("https://run.mocky.io/v3/aa5b7167-eee2-40ce-aa18-6e734c8cf71e", Get.overlayContext ?? context);
        if (value.statusCode == 200 || value.statusCode == 201) {
          SalesInvoiceListResponseModel salesInvoiceListResponseModel =
          SalesInvoiceListResponseModel.fromJson(value.response);
          setPurchaseList(salesInvoiceListResponseModel.response!.documents ?? []);

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
