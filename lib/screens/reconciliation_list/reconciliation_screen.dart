import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/screens/reconciliation_list/reconciliation_tab_view.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../controller/reconciliation_screen_controller.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/screen_loader.dart';

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
        body: Container(
          color: kWhite,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Financial Year",
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            color: kSecondaryGray900,
                            fontFamily: "ProximaNova"),
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
                                fontFamily: 'ProximaNova'),
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
                    List<String> months = getMonthsForFinancialYear(
                        reconciliationScreenController
                            .selectedFinancialYear.value);

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Month",
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            color: kSecondaryGray900,
                            fontFamily: 'ProximaNova'),
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
                                fontFamily: 'ProximaNova'),
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
                    ? const ScreenLoader()
                    : reconciliationScreenController.reconciliationData.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Column(children: [
                              SizedBox(height: 150),
                              NormalText(
                                text: 'No data available',
                              ),
                            ]),
                          )
                        : Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10),
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
                                                  ),
                                                  reconciliationScreenController
                                                      .reconciliationData[
                                                  index]
                                                      .reviewed ==
                                                      false
                                                      ? Positioned(
                                                    top: -8,
                                                    right: -5,
                                                    child:
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(20)),
                                                      child:
                                                      const Icon(
                                                        Icons
                                                            .check_circle,
                                                        color:
                                                        kSuccess,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  )
                                                      : Container()
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                    width: 225,
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
                                                          .w600,
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
                                                        .start,
                                                    textFontWeight:
                                                    FontWeight.w200,
                                                    textSize: 14,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            ),
                          )),
              ],
            ),
          ),
        ));
  }
}
