import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_decorations.dart';
import 'package:gstark/controller/purchase_invoice_controller.dart';
import 'package:gstark/utils/image_preview_screen.dart';
import '../../constants/app_colors.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/financial_year_and_months_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/login_screen_loader.dart';

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
        child: Padding(
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
                if (purchaseInvoiceController
                    .selectedFinancialYear.value.isNotEmpty) {
                  List<String> months = getMonthsForFinancialYear(purchaseInvoiceController
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
              Obx(() => purchaseInvoiceController.isBusy
                  ? const LoginScreenLoader()
                  : purchaseInvoiceController.purchaseData.isEmpty
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
                                                padding: const EdgeInsets.all(8.0),
                                                margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                (loadingProgress.expectedTotalBytes ?? 1)
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
                                                                    child: Icon(
                                                                      Icons
                                                                          .picture_as_pdf,
                                                                    ),
                                                                  );
                                                                },
                                                              )),
                                                          purchaseInvoiceController
                                                                      .purchaseData[
                                                                          index]
                                                                      .reviewed ==
                                                                  true
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color:
                                                                      kSuccess,
                                                                  size: 24,
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
                                                          NormalText(
                                                            text: purchaseInvoiceController
                                                                    .purchaseData[
                                                                        index]
                                                                    .name ??
                                                                "",
                                                            textAlign: TextAlign
                                                                .center,
                                                            textFontWeight:
                                                                FontWeight.w500,
                                                            textSize: 14,
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
