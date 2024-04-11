import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/sales_invoice_controller.dart';
import 'package:gstark/screens/purchase_inovice/purchase_invoice_view.dart';
import '../../controller/purchase_invoice_controller.dart';
import '../../utils/text_utils/normal_text.dart';


class PurchaseInvoiceScreen extends StatefulWidget {
  const PurchaseInvoiceScreen({super.key});

  @override
  State<PurchaseInvoiceScreen> createState() => _PurchaseInvoiceScreenState();
}

class _PurchaseInvoiceScreenState extends State<PurchaseInvoiceScreen> {
  late final PurchaseInvoiceController purchaseInvoiceController;
  @override
  void initState() {
    super.initState();
    purchaseInvoiceController = Get.isRegistered<PurchaseInvoiceController>()
        ? Get.find<PurchaseInvoiceController>()
        : Get.put(PurchaseInvoiceController());

    purchaseInvoiceController.initCall(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          // isExtended: true,
          backgroundColor: kPrimaryMain,
          onPressed: () {},
          // isExtended: true,
          child: const Icon(
            Icons.photo_camera,
            color: kWhite,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: kApplicationThemeColor,
        iconTheme: const IconThemeData(color: kWhite, size: 24),
        title: const NormalText(
          text: "Purchase",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
          textColor: kWhite,
        ),
        centerTitle: true,
      ),
      body: const PurchaseInvoiceView(),
    );
  }
}