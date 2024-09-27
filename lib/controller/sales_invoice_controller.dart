import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/helper/network/api_end_point.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/network_helper.dart';
import '../models/sales_invoice_list_response_model.dart';
import '../utils/financial_year_and_months_utils.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class SalesInvoiceController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxList<Documents> _salesData = RxList();

  List<Documents> get salesData => _salesData;

  setSalesList(List<Documents> value) {
    _salesData.clear(); // Clear the existing data before adding new
    if (value.isNotEmpty) {
      _salesData.addAll(value); // Add the new data
    }
  }

  // Observable for selected financial year and month
  var selectedFinancialYear = ''.obs;
  var selectedMonth = ''.obs;

  // Method to update the selected financial year
  void setSelectedFinancialYear(String year) {
    selectedFinancialYear.value = year;
    selectedMonth.value =
        ''; // Reset the month selection when financial year changes
  }

  // Method to update the selected month
  void setSelectedMonth(String month) {
    selectedMonth.value = month;
    String fromDate = getStartDateForMonth(selectedFinancialYear.value, month);
    String toDate = getEndDateForMonth(selectedFinancialYear.value, month);
    // Call the API after the month is selected
    getAllSalesInvoice(Get.context!, fromDate, toDate);
  }

  // initCall method to initialize the selected financial year and month
  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _salesData.clear();

      // Get the current financial year
      String currentFinancialYear = getCurrentFinancialYear();

      // Set the current month and financial year as default
      selectedFinancialYear.value = currentFinancialYear;
      selectedMonth.value =
          months[currentMonth < 4 ? currentMonth + 8 : currentMonth - 4];

      // Calculate the start and end dates based on the default selection
      String fromDate = getStartDateForMonth(
          selectedFinancialYear.value, selectedMonth.value);
      String toDate =
          getEndDateForMonth(selectedFinancialYear.value, selectedMonth.value);

      // Call the API with the current month and year
      await getAllSalesInvoice(context, fromDate, toDate);
    });
  }

  // Method to fetch all sales invoices based on selected month and financial year
  getAllSalesInvoice(
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
            ApiEndPoint.baseUrl + ApiEndPoint.salesInvoiceListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": userId,
              "filters": {
                "fromDate": fromDate,
                "toDate": toDate,
              },
              "type": "sale"
            },
            headers: {
              'x-header-token': email,
              'authorization': token,
              'Content-Type': "application/json",
            });

        if (value.statusCode == 200 || value.statusCode == 201) {
          SalesInvoiceListResponseModel salesInvoiceListResponseModel =
              SalesInvoiceListResponseModel.fromJson(value.response);
          setSalesList(salesInvoiceListResponseModel.response!.documents ?? []);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setBusy(false);
      }
    }
  }
}

//getAllReportInvoice(BuildContext context) async {
//     setBusy(true);
//     bool isConnectedToInternet = await checkIsConnectedToInternet();
//     if (isConnectedToInternet) {
//       try {
//         String authToken =
//             await CustomSharedPref.getPref(SharedPreferenceString.authToken);
//         String email =
//             await CustomSharedPref.getPref(SharedPreferenceString.email);
//         String userId = await CustomSharedPref.getPref<String>(
//             SharedPreferenceString.clientId);
//
//         String token = 'Bearer $authToken';
//
//         var value = await apiService.post(
//             ApiEndPoint.baseUrl + ApiEndPoint.salesInvoiceListApi,
//             Get.overlayContext ?? context,
//             body: {
//               "userId": userId,
//               "month": null,
//               "type": "report"
//             },
//             headers: {
//               'x-header-token': email,
//               'authorization': token,
//               'Content-Type': "application/json",
//             });
//
//         // var value = await apiService.get(
//         //     "https://run.mocky.io/v3/aa5b7167-eee2-40ce-aa18-6e734c8cf71e",
//         //     Get.overlayContext ?? context);
//
//         if (value.statusCode == 200 || value.statusCode == 201) {
//           SalesInvoiceListResponseModel salesInvoiceListResponseModel =
//               SalesInvoiceListResponseModel.fromJson(value.response);
//           setSalesList(salesInvoiceListResponseModel.response!.documents ?? []);
//
//           print(_salesData);
//           setBusy(false);
//         } else {
//           setBusy(false);
//         }
//       } catch (e) {
//         debugPrint(e.toString());
//         setBusy(false);
//         rethrow;
//       }
//     }
//   }
