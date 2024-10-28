import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_decorations.dart';
import 'package:gstark/controller/purchase_invoice_controller.dart';
import 'package:gstark/utils/image_preview_screen.dart';
import '../../constants/app_colors.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/screen_loader.dart';

class PurchaseInvoiceView extends StatefulWidget {
  const PurchaseInvoiceView({super.key});

  @override
  State<PurchaseInvoiceView> createState() => _PurchaseInvoiceViewState();
}

class _PurchaseInvoiceViewState extends State<PurchaseInvoiceView> {
  late final PurchaseInvoiceController purchaseInvoiceController;

  @override
  void initState() {
    super.initState();
    purchaseInvoiceController = Get.isRegistered<PurchaseInvoiceController>()
        ? Get.find<PurchaseInvoiceController>()
        : Get.put(PurchaseInvoiceController());
  }

  @override
  Widget build(BuildContext context) {
    List<String> financialYears = getLast8FinancialYears();

    return RefreshIndicator(
        color: kApplicationThemeColor,
        onRefresh: () async {
          purchaseInvoiceController.initCall(context);
          return;
        },
        child: Container(
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
                      value: purchaseInvoiceController
                              .selectedFinancialYear.value.isEmpty
                          ? null
                          : purchaseInvoiceController.selectedFinancialYear.value,
                      onChanged: (String? newValue) {
                        purchaseInvoiceController
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
                                fontFamily: "ProximaNova"),
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(
                  height: 16,
                ),
                // Month Dropdown with styling
                Obx(() {
                  if (purchaseInvoiceController
                      .selectedFinancialYear.value.isNotEmpty) {
                    List<String> months = getMonthsForFinancialYear(
                        purchaseInvoiceController.selectedFinancialYear.value);

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
                      value: purchaseInvoiceController.selectedMonth.value.isEmpty
                          ? null
                          : purchaseInvoiceController.selectedMonth.value,
                      onChanged: (String? newValue) {
                        purchaseInvoiceController.setSelectedMonth(newValue!);
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
                                fontFamily: "ProximaNova"),
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
                Obx(() => purchaseInvoiceController.isBusy
                    ? const ScreenLoader()
                    : purchaseInvoiceController.purchaseData.isEmpty
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
                                  itemCount: purchaseInvoiceController
                                      .purchaseData.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(ImagePreviewScreen(
                                            file:
                                            purchaseInvoiceController
                                                .purchaseData[
                                            index]
                                                .file ??
                                                ""));
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
                                                        child: Image
                                                            .network(
                                                          purchaseInvoiceController
                                                              .purchaseData[
                                                          index]
                                                              .thumbnail ??
                                                              "",
                                                          loadingBuilder: (BuildContext
                                                          context,
                                                              Widget
                                                              child,
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
                                                                  value: loadingProgress.expectedTotalBytes != null
                                                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                                      : null,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          errorBuilder: (BuildContext
                                                          context,
                                                              Object
                                                              error,
                                                              StackTrace?
                                                              stackTrace) {
                                                            return const Center(
                                                              child:
                                                              Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )),
                                                  purchaseInvoiceController
                                                      .purchaseData[
                                                  index]
                                                      .reviewed ==
                                                      false
                                                      ? Positioned(
                                                      top: -8,
                                                      right: -5,
                                                      child: Container(
                                                          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(20)),
                                                          child: const Icon(
                                                            Icons
                                                                .check_circle,
                                                            color:
                                                            kSuccess,
                                                            size:
                                                            18,
                                                          )))
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
                                                    width:225,
                                                    child: NormalText(
                                                      text: purchaseInvoiceController
                                                          .purchaseData[
                                                      index]
                                                          .name ??
                                                          "",
                                                      textAlign: TextAlign
                                                          .start,
                                                      textFontWeight:
                                                      FontWeight.w600,
                                                      textSize: 14,
                                                    ),
                                                  ),
                                                  NormalText(
                                                    text: getDateTime(
                                                        purchaseInvoiceController
                                                            .purchaseData[
                                                        index]
                                                            .cratedAt ??
                                                            ""),
                                                    textAlign: TextAlign
                                                        .center,
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
