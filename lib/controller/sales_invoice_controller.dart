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
        var value = await apiService.get(
            "https://run.mocky.io/v3/aa5b7167-eee2-40ce-aa18-6e734c8cf71e",
            Get.overlayContext ?? context);
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
