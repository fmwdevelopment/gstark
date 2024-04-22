import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gstark/helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../models/sales_inovice_list_response_model.dart';
import '../utils/internet_utils.dart';

class SalesInvoiceController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getAllSalesInvoice(context);
    });
  }

  final RxList<Documents> _salesData = RxList();
  List<Documents> get salesData => _salesData.value;
  setSalesList(List<Documents> value) {
    _salesData.value = value;
  }

  getAllSalesInvoice(BuildContext context) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {

        String token =
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJnc3RuIjoiQUJDREVGR0hFUzEyMzQ1IiwidXNlcklkIjoiYzg3ZmJjMjUtZjE2OC00NDg4LTlmODctZjBiMDhiNWNiMzNjIiwiZW1haWwiOiJjbGllbnRfNzIwNDYzMTcwNUBnc3RhcmsuY29tIiwicm9sZXMiOlt7InR5cGUiOiJjcmVhdGUiLCJ0YXJnZXQiOiJkb2N1bWVudCJ9LHsidHlwZSI6InVwZGF0ZSIsInRhcmdldCI6ImRvY3VtZW50In1dLCJ1c2VyVHlwZSI6ImNsaWVudCIsImlhdCI6MTcxMTU1NzcyMCwiZXhwIjoxNzQzMDkzNzIwfQ.bBN_Gus7JnJ_Om34Qawm4Fs3ui_umQhL3blBfBBWoWo';

        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.salesInvoiceListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": "c87fbc25-f168-4488-9f87-f0b08b5cb33c",
              "month": null,
              "type": "sale"
            },
          headers: {
            'x-header-token': 'client_7204631705@gstark.com',
            'authorization': token,
            'Content-Type':"application/json",
          }

        );

        // var value = await apiService.get(
        //     "https://run.mocky.io/v3/aa5b7167-eee2-40ce-aa18-6e734c8cf71e",
        //     Get.overlayContext ?? context);

        if (value.statusCode == 200 || value.statusCode == 201) {
          SalesInvoiceListResponseModel salesInvoiceListResponseModel =
              SalesInvoiceListResponseModel.fromJson(value.response);
          setSalesList(salesInvoiceListResponseModel.response!.documents ?? []);

          print(_salesData);
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
