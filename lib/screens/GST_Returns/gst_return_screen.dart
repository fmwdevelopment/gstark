import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/controller/gst_returns_controller.dart';
import 'package:gstark/screens/GST_Returns/document_preview_screen.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/screen_loader.dart';

class GSTReturnScreen extends StatefulWidget {
  const GSTReturnScreen({super.key});

  @override
  State<GSTReturnScreen> createState() => _GSTReturnScreenState();
}

class _GSTReturnScreenState extends State<GSTReturnScreen> {
  late final GSTReturnController gstReturnController;

  @override
  void initState() {
    super.initState();
    gstReturnController = Get.isRegistered<GSTReturnController>()
        ? Get.find<GSTReturnController>()
        : Get.put(GSTReturnController());
    gstReturnController.initCall(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> financialYears = getLast8FinancialYears();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kApplicationThemeColor,
          iconTheme: const IconThemeData(color: kWhite, size: 24),
          title: const NormalText(
            text: "GST Return",
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
                            fontFamily: 'ProximaNova'),
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
                      value: gstReturnController
                              .selectedFinancialYear.value.isEmpty
                          ? null
                          : gstReturnController.selectedFinancialYear.value,
                      onChanged: (String? newValue) {
                        gstReturnController.setSelectedFinancialYear(newValue!);
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
                  if (gstReturnController
                      .selectedFinancialYear.value.isNotEmpty) {
                    List<String> months = getMonthsForFinancialYear(
                        gstReturnController.selectedFinancialYear.value);

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
                      value: gstReturnController.selectedMonth.value.isEmpty
                          ? null
                          : gstReturnController.selectedMonth.value,
                      onChanged: (String? newValue) {
                        gstReturnController.setSelectedMonth(newValue!);
                      },
                      items:
                          months.map<DropdownMenuItem<String>>((String month) {
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
                Obx(() => gstReturnController.isBusy
                    ? const ScreenLoader()
                    : gstReturnController.returnsData.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Column(children: [
                              SizedBox(height: 150),
                              NormalText(
                                text: 'No data available',
                              ),
                            ]),
                          )
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: gstReturnController
                                      .returnsData.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return InkWell(
                                      onTap: () {
                                        // TODO: implement doc preview screen
                                        Get.to(DocumentPreviewScreen(
                                          file: gstReturnController
                                              .returnsData[index]
                                              .file ??
                                              "",
                                          name: gstReturnController
                                              .returnsData[index]
                                              .name ??
                                              "",
                                        ));
                                      },
                                      child: Container(
                                        decoration:
                                        listItemDecoration,
                                        padding:
                                        const EdgeInsets.all(4.0),
                                        margin: const EdgeInsets
                                            .symmetric(
                                            horizontal: 15,
                                            vertical: 10),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Stack(
                                                clipBehavior:
                                                Clip.none,
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
                                                      child: Image
                                                          .network(
                                                        gstReturnController
                                                            .returnsData[
                                                        index]
                                                            .thumbnail ??
                                                            "",
                                                        errorBuilder: (BuildContext
                                                        context,
                                                            Object
                                                            exception,
                                                            StackTrace?
                                                            stackTrace) {
                                                          return (gstReturnController.returnsData[index].mimetype !=
                                                              null &&
                                                              gstReturnController.returnsData[index].mimetype!.contains(
                                                                  "pdf"))
                                                              ? const Icon(Icons
                                                              .picture_as_pdf)
                                                              : const Icon(
                                                              Icons.error);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  gstReturnController
                                                      .returnsData[
                                                  index]
                                                      .reviewed ==
                                                      false
                                                      ? Positioned(
                                                    top: -8,
                                                    right: -5,
                                                    child:
                                                    Container(
                                                      decoration:
                                                      BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child:
                                                      const Icon(
                                                        Icons
                                                            .check_circle,
                                                        color:
                                                        kSuccess,
                                                        size:
                                                        18,
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
                                                      text: gstReturnController
                                                          .returnsData[
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
                                                  NormalText(
                                                    text: getDateTime(
                                                        gstReturnController
                                                            .returnsData[
                                                        index]
                                                            .cratedAt ??
                                                            ""),
                                                    textAlign:
                                                    TextAlign
                                                        .start,
                                                    textFontWeight:
                                                    FontWeight
                                                        .w200,
                                                    textSize: 12,
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
