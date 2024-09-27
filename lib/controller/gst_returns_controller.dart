import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../models/gst_returns_response_model.dart';
import '../utils/financial_year_and_months_utils.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class GSTReturnController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  // Observable for selected financial year and month
  var selectedFinancialYear = ''.obs;
  var selectedMonth = ''.obs;


  // Initialize the controller and call the API
  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Get the current financial year
      String currentFinancialYear = getCurrentFinancialYear();
      selectedFinancialYear.value = currentFinancialYear;

      // Set the current month and financial year as default
      selectedMonth.value =
          months[currentMonth < 4 ? currentMonth + 8 : currentMonth - 4];

      // Fetch GST returns for the default selections
      await getAllGSTReturns(context);
    });
  }


  final RxList<ReturnsDocuments> _returnsData = RxList();

  List<ReturnsDocuments> get returnsData => _returnsData;

  // Method to set the list of GST returns
  void setReturnsList(List<ReturnsDocuments> value) {
    _returnsData.clear();
    if (value.isNotEmpty) {
      _returnsData.addAll(value);
    }
  }

  // Method to update the selected financial year
  void setSelectedFinancialYear(String year) {
    selectedFinancialYear.value = year;
    selectedMonth.value =
        ''; // Reset the month selection when financial year changes
    getAllGSTReturns(
        Get.overlayContext ?? Get.context!); // Fetch data for the new year
  }

  // Method to update the selected month
  void setSelectedMonth(String month) {
    selectedMonth.value = month;
    getAllGSTReturns(
        Get.overlayContext ?? Get.context!); // Fetch data for the new month
  }

  // Method to fetch all GST returns based on selected month and financial year
  Future<void> getAllGSTReturns(BuildContext context) async {
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
          ApiEndPoint.baseUrl + ApiEndPoint.gstReturnsListApi,
          Get.overlayContext ?? context,
          body: {
            "userId": userId,
            "month": selectedMonth.value,
            "type": "gstfiled"
          },
          headers: {
            'x-header-token': email,
            'authorization': token,
            'Content-Type': "application/json",
          },
        );

        if (value.statusCode == 200 || value.statusCode == 201) {
          GSTReturnsResponseModel gstReturnsResponseModel =
              GSTReturnsResponseModel.fromJson(value.response);
          setReturnsList(gstReturnsResponseModel.response!.documents ?? []);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setBusy(false);
      }
    }
  }
}
