import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gstark/models/purchase_invoice_list_response_model.dart';
import '../helper/network/api_end_point.dart';
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

        String token =
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJnc3RuIjoiQUJDREVGR0hFUzEyMzQ1IiwidXNlcklkIjoiYzg3ZmJjMjUtZjE2OC00NDg4LTlmODctZjBiMDhiNWNiMzNjIiwiZW1haWwiOiJjbGllbnRfNzIwNDYzMTcwNUBnc3RhcmsuY29tIiwicm9sZXMiOlt7InR5cGUiOiJjcmVhdGUiLCJ0YXJnZXQiOiJkb2N1bWVudCJ9LHsidHlwZSI6InVwZGF0ZSIsInRhcmdldCI6ImRvY3VtZW50In1dLCJ1c2VyVHlwZSI6ImNsaWVudCIsImlhdCI6MTcxMTU1NzcyMCwiZXhwIjoxNzQzMDkzNzIwfQ.bBN_Gus7JnJ_Om34Qawm4Fs3ui_umQhL3blBfBBWoWo';

        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.purchaseInvoiceListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": "c87fbc25-f168-4488-9f87-f0b08b5cb33c",
              "month": null,
              "type": "purchase"
            },
            headers: {
              'x-header-token': 'client_7204631705@gstark.com',
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
