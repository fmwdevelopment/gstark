import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_decorations.dart';
import 'package:gstark/controller/purchase_invoice_controller.dart';
import 'package:gstark/controller/sales_invoice_controller.dart';

import '../../utils/date_time_utils.dart';
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
    return Obx(() => purchaseInvoiceController.isBusy
        ? const LoginScreenLoader()
        : purchaseInvoiceController.purchaseData.isEmpty
        ? const Center(
      child: NormalText(
        text: 'No data available',
      ),
    )
        : Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Obx(() => Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount:
                purchaseInvoiceController.purchaseData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: listItemDecoration,
                    padding: const EdgeInsets.all(4.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                                purchaseInvoiceController
                                    .purchaseData[index]
                                    .thumbnail ??
                                    ""),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              NormalText(
                                text:purchaseInvoiceController
                                    .purchaseData[index].name ??
                                    "",
                                textAlign: TextAlign.center,
                                textFontWeight: FontWeight.w500,
                                textSize: 14,
                              ),
                              NormalText(
                                text: getDateTime(
                                    purchaseInvoiceController
                                        .purchaseData[index]
                                        .cratedAt ??
                                        ""),
                                textAlign: TextAlign.center,
                                textFontWeight: FontWeight.w200,
                                textSize: 12,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ))
        ],
      ),
    ));
  }
}
