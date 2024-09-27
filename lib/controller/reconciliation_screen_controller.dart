import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:gstark/models/excel_data_model.dart';
import 'package:gstark/models/reconciliation_response_model.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/financial_year_and_months_utils.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReconciliationScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  // Observable lists for data management
  final RxList<ExcelData> _data = RxList();

  List<ExcelData> get data => _data;

  final RxList<ExcelData> _filteredData = RxList();

  List<ExcelData> get filteredData => _filteredData;

  // Set filtered data based on criteria
  void setFilteredData(List<ExcelData> value) {
    _filteredData.clear();
    _filteredData.addAll(value);
  }

  //// Observable lists for reconciliation data
  final RxList<ReconciliationDocuments> _reconciliationData = RxList();

  List<ReconciliationDocuments> get reconciliationData =>
      _reconciliationData;

  // Set reconciliation data
  void setReconciliationList(List<ReconciliationDocuments> value) {
    _reconciliationData.clear();
    if (value.isNotEmpty) {
      _reconciliationData.addAll(value);
    }
  }

  // Selected financial year and month observables
  var selectedFinancialYear = ''.obs;
  var selectedMonth = ''.obs;


  // Initialize the controller and fetch initial data
  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _reconciliationData.clear();
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
      await getReconciliationData(context, fromDate, toDate);
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
    String fromDate = getStartDateForMonth(selectedFinancialYear.value, month);
    String toDate = getEndDateForMonth(selectedFinancialYear.value, month);
    // Call the API after the month is selected
    getReconciliationData(Get.context!, fromDate, toDate);
  }

  // Fetch reconciliation data based on selected year and month
  getReconciliationData(
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
            ApiEndPoint.baseUrl + ApiEndPoint.gstReturnsListApi,
            Get.overlayContext ?? context,
            body: {
              "userId": userId,
              "filters": {
                "fromDate": fromDate,
                "toDate": toDate,
              },
              "type": "gstr_reconciliation"
            },
            headers: {
              'x-header-token': email,
              'authorization': token,
              'Content-Type': "application/json",
            });

        if (value.statusCode == 200 || value.statusCode == 201) {
          ReconciliationResponseModel reconciliationResponseModel =
              ReconciliationResponseModel.fromJson(value.response);
          setReconciliationList(
              reconciliationResponseModel.response!.documents ?? []);

        } else {
          setReconciliationList([]);
        }
      } catch (e) {
        debugPrint(e.toString());
        setReconciliationList([]);
      } finally {
        setBusy(false);
      }
    }
  }


  Future<void> fetchDataFromAPI(String url) async {
    setBusy(true);

    try {
      _data.clear();
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        var excel = Excel.decodeBytes(bytes);
        var table = excel[
            'B2B']; // Replace 'Sheet1' with the name of your desired sheet

        // List of column names you want to extract data from
        var columnNames = [
          'GSTIN of supplier',
          'Trade/Legal name',
          'Invoice number',
          'Invoice Date',
          'Invoice Value(₹)',
          'Rate(%)',
          'Taxable Value (₹)',
          'Integrated Tax(₹)',
          'Central Tax(₹)',
          'State/UT Tax(₹)'
        ]; // Add more column names if needed

        // Extract data from each column
        var columnData = <List<dynamic>>[];
        for (var columnName in columnNames) {
          var columnIdx = -1;
          for (var row in table.rows) {
            for (var cell in row) {
              String newValue = cell?.value?.toString() ?? '';
              if (newValue.contains(columnName)) {
                columnIdx = row.indexOf(cell);
                break;
              }
            }
            if (columnIdx != -1) {
              break;
            }
          }
          if (columnIdx != -1) {
            var data = table.rows.map((row) => row[columnIdx]?.value).toList();
            columnData.add(data);
          } else {
            throw Exception('Column "$columnName" not found');
          }
        }

        List.generate(table.maxRows - 1, (index) {
          if (index > 4) {
            debugPrint(
                'hello $index : ${columnData[0][index + 1]} : ${columnData[1][index + 1]} : ${columnData[2][index + 1]} : ${columnData[3][index + 1]} ');
            data.add(ExcelData(
                gstinOfSupplier: columnData[0][index + 1]?.toString() ?? '',
                tradeLegalName: columnData[1][index + 1]?.toString() ?? '',
                invoiceNumber: columnData[2][index + 1]?.toString() ?? '',
                invoiceDate: columnData[3][index + 1]?.toString() ?? '',
                invoiceValue: columnData[4][index + 1]?.toString() ?? '',
                rate: columnData[5][index + 1]?.toString() ?? '',
                taxableValue: columnData[6][index + 1]?.toString() ?? '',
                integratedTax: columnData[7][index + 1]?.toString() ?? '',
                centralTax: columnData[8][index + 1]?.toString() ?? '',
                stateUtTax: columnData[9][index + 1]?.toString() ?? ''));
          }

          // print('hello ${columnData[1][index + 1]}');
          // print('hello ${columnData[2][index + 1]}');
        });

        // Transpose the column data to rows and create instances of ExcelData class
        /*_data = List.generate(table.maxRows - 1, (index) {
          return ExcelData(
            column1: columnData[0][index + 1], // Skip header row
            column2: columnData[1][index + 1], // Skip header row
            column3: columnData[2][index + 1], // Skip header row
          );
        });*/

        setFilteredData(data);
        // for(var value in data){
        //  print(value.taxableValue);
        // }
        setBusy(false);
      } else {
        setBusy(false);
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      setBusy(false);

    }
  }
}

//// Fetch data from external API and populate _data list
//   Future<void> fetchDataFromAPI(String url) async {
//     setBusy(true);
//     try {
//       _data.clear();
//       var response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         var bytes = response.bodyBytes;
//         var excel = Excel.decodeBytes(bytes);
//         var table = excel['B2B']; // Change 'B2B' to your sheet name
//
//         // Column names to extract data from
//         var columnNames = [
//           'GSTIN of supplier', 'Trade/Legal name', 'Invoice number',
//           'Invoice Date', 'Invoice Value(₹)', 'Rate(%)',
//           'Taxable Value (₹)', 'Integrated Tax(₹)',
//           'Central Tax(₹)', 'State/UT Tax(₹)'
//         ];
//
//         // Extract column data
//         var columnData = <List<dynamic>>[];
//         for (var columnName in columnNames) {
//           var columnIdx = -1;
//           for (var row in table.rows) {
//             for (var cell in row) {
//               String newValue = cell?.value?.toString() ?? '';
//               if (newValue.contains(columnName)) {
//                 columnIdx = row.indexOf(cell);
//                 break;
//               }
//             }
//             if (columnIdx != -1) {
//               break;
//             }
//           }
//           if (columnIdx != -1) {
//             var data = table.rows.map((row) => row[columnIdx]?.value).toList();
//             columnData.add(data);
//           } else {
//             throw Exception('Column "$columnName" not found');
//           }
//         }
//
//         // Populate data into the _data list
//         List.generate(table.maxRows - 1, (index) {
//           if (index > 4) {
//             data.add(ExcelData(
//                 gstinOfSupplier: columnData[0][index + 1]?.toString() ?? '',
//                 tradeLegalName: columnData[1][index + 1]?.toString() ?? '',
//                 invoiceNumber: columnData[2][index + 1]?.toString() ?? '',
//                 invoiceDate: columnData[3][index + 1]?.toString() ?? '',
//                 invoiceValue: columnData[4][index + 1]?.toString() ?? '',
//                 rate: columnData[5][index + 1]?.toString() ?? '',
//                 taxableValue: columnData[6][index + 1]?.toString() ?? '',
//                 integratedTax: columnData[7][index + 1]?.toString() ?? '',
//                 centralTax: columnData[8][index + 1]?.toString() ?? '',
//                 stateUtTax: columnData[9][index + 1]?.toString() ?? ''
//             ));
//           }
//         });
//
//         setFilteredData(data);
//         setBusy(false);
//       } else {
//         throw Exception('Failed to load data from API');
//       }
//     } catch (e) {
//       setBusy(false);
//       print('Error: $e');
//     }
//   }
