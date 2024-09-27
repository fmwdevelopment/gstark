import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/models/purchase_invoice_list_response_model.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/financial_year_and_months_utils.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class PurchaseInvoiceController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxList<PurchaseDocuments> _purchaseData = RxList();

  List<PurchaseDocuments> get purchaseData => _purchaseData;

  void setPurchaseList(List<PurchaseDocuments> value) {
    _purchaseData.clear();
    if (value.isNotEmpty) {
      _purchaseData.addAll(value);
    }
  }

  // Observable for selected financial year and month
  var selectedFinancialYear = ''.obs;
  var selectedMonth = ''.obs;


  // InitCall to set the financial year and month defaults
  void initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _purchaseData.clear();

      // Get the current financial year
      String currentFinancialYear = getCurrentFinancialYear();
      selectedFinancialYear.value = currentFinancialYear;

      // Set the current month and financial year as default
      selectedMonth.value =
          months[currentMonth < 4 ? currentMonth + 8 : currentMonth - 4];

      // Calculate the start and end dates based on the default selection
      String fromDate = getStartDateForMonth(
          selectedFinancialYear.value, selectedMonth.value);
      String toDate =
          getEndDateForMonth(selectedFinancialYear.value, selectedMonth.value);

      // Call the API with the current month and year
      await getAllPurchaseInvoice(context, fromDate, toDate);
    });
  }

  // Method to update the selected financial year
  void setSelectedFinancialYear(String year) {
    selectedFinancialYear.value = year;
    selectedMonth.value =
        ''; // Reset the month selection when financial year changes
  }

  // Method to update the selected month
  void setSelectedMonth(String month) {
    selectedMonth.value = month;

    // Calculate the start and end dates based on the new selection
    String fromDate =
        getStartDateForMonth(selectedFinancialYear.value, selectedMonth.value);
    String toDate =
        getEndDateForMonth(selectedFinancialYear.value, selectedMonth.value);

    // Fetch data based on the new month selection
    getAllPurchaseInvoice(Get.overlayContext ?? Get.context!, fromDate, toDate);
  }

  // Method to fetch all purchase invoices based on selected month and financial year
  Future<void> getAllPurchaseInvoice(
      BuildContext context, String fromDate, String toDate) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String authToken =
            await CustomSharedPref.getPref(SharedPreferenceString.authToken);
        String email =
            await CustomSharedPref.getPref(SharedPreferenceString.email);
        String userId = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clientId);
        String token = 'Bearer $authToken';

        var value = await apiService.post(
          ApiEndPoint.baseUrl + ApiEndPoint.purchaseInvoiceListApi,
          Get.overlayContext ?? context,
          body: {
            "userId": userId,
            "filters": {
              "fromDate": fromDate,
              "toDate": toDate,
            },
            "type": "purchase",
          },
          headers: {
            'x-header-token': email,
            'authorization': token,
            'Content-Type': "application/json",
          },
        );

        if (value.statusCode == 200 || value.statusCode == 201) {
          PurchaseInvoiceListResponseModel purchaseInvoiceListResponseModel =
              PurchaseInvoiceListResponseModel.fromJson(value.response);
          setPurchaseList(
              purchaseInvoiceListResponseModel.response!.documents ?? []);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setBusy(false);
      }
    }
  }
}
