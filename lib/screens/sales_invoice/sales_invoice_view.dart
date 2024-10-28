import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/constants/app_decorations.dart';
import 'package:gstark/controller/sales_invoice_controller.dart';
import 'package:gstark/utils/image_preview_screen.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/screen_loader.dart';

class SalesInvoiceView extends StatefulWidget {
  const SalesInvoiceView({super.key});

  @override
  State<SalesInvoiceView> createState() => _SalesInvoiceViewState();
}

class _SalesInvoiceViewState extends State<SalesInvoiceView> {
  late final SalesInvoiceController salesInvoiceController;

  @override
  void initState() {
    super.initState();
    salesInvoiceController = Get.isRegistered<SalesInvoiceController>()
        ? Get.find<SalesInvoiceController>()
        : Get.put(SalesInvoiceController());
  }

  @override
  Widget build(BuildContext context) {
    List<String> financialYears = getLast8FinancialYears();

    return RefreshIndicator(
      color: kApplicationThemeColor,
      onRefresh: () async {
        salesInvoiceController.initCall(context);
        return;
      },
      child: Container(
        color: kWhite,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: kApplicationThemeColor, width: 1),
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
                    value:
                        salesInvoiceController.selectedFinancialYear.value.isEmpty
                            ? null
                            : salesInvoiceController.selectedFinancialYear.value,
                    onChanged: (String? newValue) {
                      salesInvoiceController.setSelectedFinancialYear(newValue!);
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
                              fontFamily: "ProximaNova"
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
                if (salesInvoiceController
                    .selectedFinancialYear.value.isNotEmpty) {
                  List<String> months = getMonthsForFinancialYear(
                      salesInvoiceController.selectedFinancialYear.value);

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Month",
                      labelStyle: const TextStyle(
                          fontSize: 16,
                          color: kSecondaryGray900,
                          fontFamily: "ProximaNova"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: kApplicationThemeColor, width: 1),
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
                    value: salesInvoiceController.selectedMonth.value.isEmpty
                        ? null
                        : salesInvoiceController.selectedMonth.value,
                    onChanged: (String? newValue) {
                      salesInvoiceController.setSelectedMonth(newValue!);
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
                              fontFamily: "ProximaNova"
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
              const SizedBox(height: 10),
              Obx(() => salesInvoiceController.isBusy
                  ? const ScreenLoader()
                  : salesInvoiceController.salesData.isEmpty
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
                              salesInvoiceController.salesData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(ImagePreviewScreen(
                                        file: salesInvoiceController
                                            .salesData[index].file ??
                                            ""));
                                  },
                                  child: Container(
                                    decoration: listItemDecoration,
                                    padding: const EdgeInsets.all(8.0),
                                    // margin: const EdgeInsets.symmetric(
                                    //     vertical: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                                    BorderRadius.circular(
                                                        10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  child: Image.network(
                                                    salesInvoiceController
                                                        .salesData[index]
                                                        .thumbnail ??
                                                        "",
                                                    loadingBuilder: (BuildContext
                                                    context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child:
                                                          CircularProgressIndicator(
                                                            color:
                                                            kApplicationThemeColor,
                                                            value: loadingProgress
                                                                .expectedTotalBytes !=
                                                                null
                                                                ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                    .expectedTotalBytes ??
                                                                    1)
                                                                : null,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    errorBuilder:
                                                        (BuildContext context,
                                                        Object error,
                                                        StackTrace?
                                                        stackTrace) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.picture_as_pdf,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              salesInvoiceController
                                                  .salesData[index]
                                                  .reviewed ==
                                                  false
                                                  ? Positioned(
                                                top: -8,
                                                right: -5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: kWhite,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          20)),
                                                  child: const Icon(
                                                    Icons.check_circle,
                                                    color: kSuccess,
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
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:225,
                                                child: NormalText(
                                                  text: salesInvoiceController
                                                      .salesData[index]
                                                      .name ??
                                                      "",
                                                  textAlign: TextAlign.start,
                                                  textFontWeight: FontWeight.w600,
                                                  textSize: 14,
                                                ),
                                              ),
                                              NormalText(
                                                text: getDateTime(
                                                    salesInvoiceController
                                                        .salesData[index]
                                                        .cratedAt ??
                                                        ""),
                                                textAlign: TextAlign.start,
                                                textFontWeight: FontWeight.w200,
                                                textSize: 14,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
