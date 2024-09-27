
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/screens/reconciliation_list/reconciliation_tab_view.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../controller/reconciliation_screen_controller.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/login_screen_loader.dart';

class ReconciliationScreen extends StatefulWidget {
  const ReconciliationScreen({super.key});

  @override
  State<ReconciliationScreen> createState() => _ReconciliationScreenState();
}

class _ReconciliationScreenState extends State<ReconciliationScreen> {
  late final ReconciliationScreenController reconciliationScreenController;

  @override
  void initState() {
    super.initState();
    reconciliationScreenController =
        Get.isRegistered<ReconciliationScreenController>()
            ? Get.find<ReconciliationScreenController>()
            : Get.put(ReconciliationScreenController());
    reconciliationScreenController.initCall(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> financialYears = getLast8FinancialYears();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kApplicationThemeColor,
          iconTheme: const IconThemeData(color: kWhite, size: 24),
          title: const NormalText(
            text: "2A/2B Reconciliation",
            textAlign: TextAlign.center,
            textFontWeight: FontWeight.w500,
            textSize: 20,
            textColor: kWhite,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Financial Year",
                      labelStyle: const TextStyle(
                          fontSize: 16, color: kSecondaryGray900),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: kSecondaryGray900, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: kApplicationThemeColor,
                            width: 2), // Focused border color
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                    ),
                    value: reconciliationScreenController
                            .selectedFinancialYear.value.isEmpty
                        ? null
                        : reconciliationScreenController
                            .selectedFinancialYear.value,
                    onChanged: (String? newValue) {
                      reconciliationScreenController
                          .setSelectedFinancialYear(newValue!);
                    },
                    items: financialYears
                        .map<DropdownMenuItem<String>>((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(
                          year,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kSecondaryGray900,
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(
                height: 16,
              ),
              // Month Dropdown with styling
              Obx(() {
                if (reconciliationScreenController
                    .selectedFinancialYear.value.isNotEmpty) {
                  List<String> months = getMonthsForFinancialYear(reconciliationScreenController
                          .selectedFinancialYear.value);

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Month",
                      labelStyle: const TextStyle(
                          fontSize: 16, color: kSecondaryGray900),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: kApplicationThemeColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: kApplicationThemeColor,
                            width: 2), // Focused border color
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                    ),
                    value: reconciliationScreenController
                            .selectedMonth.value.isEmpty
                        ? null
                        : reconciliationScreenController.selectedMonth.value,
                    onChanged: (String? newValue) {
                      reconciliationScreenController
                          .setSelectedMonth(newValue!);
                    },
                    items: months.map<DropdownMenuItem<String>>((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(
                          month,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kSecondaryGray900,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const NormalText(
                      text: 'Select Financial Year to pick a Month');
                }
              }),
              const SizedBox(height: 16),
              const Divider(),
              Obx(() => reconciliationScreenController.isBusy
                  ? const LoginScreenLoader()
                  : reconciliationScreenController.reconciliationData.isEmpty
                      ? const Center(
                          child: NormalText(
                            text: 'No data available',
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Obx(() => Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              reconciliationScreenController
                                                  .reconciliationData.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                Get.to(
                                                    ReconciliationTabView(
                                                        name: reconciliationScreenController
                                                                .reconciliationData[
                                                                    index]
                                                                .name ??
                                                            "",
                                                        fileUrl:
                                                            reconciliationScreenController
                                                                    .reconciliationData[
                                                                        index]
                                                                    .file ??
                                                                ""),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                              child: Container(
                                                decoration: listItemDecoration,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 50,
                                                            width: 50,
                                                            child:
                                                                Image.network(
                                                              reconciliationScreenController
                                                                      .reconciliationData[
                                                                          index]
                                                                      .thumbnail ??
                                                                  "",
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                return const Icon(
                                                                    Icons
                                                                        .file_copy_outlined);
                                                              },
                                                            ),
                                                          ),
                                                          reconciliationScreenController
                                                                      .reconciliationData[
                                                                          index]
                                                                      .reviewed ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color: kWhite,
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 200,
                                                            child: NormalText(
                                                              text: reconciliationScreenController
                                                                      .reconciliationData[
                                                                          index]
                                                                      .name ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textFontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              textSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          NormalText(
                                                            text: getDateTime(
                                                                reconciliationScreenController
                                                                        .reconciliationData[
                                                                            index]
                                                                        .cratedAt ??
                                                                    ""),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textFontWeight:
                                                                FontWeight.w200,
                                                            textSize: 12,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ))
                              ],
                            ),
                          ),
                        )),
            ],
          ),
        ));
  }
}
