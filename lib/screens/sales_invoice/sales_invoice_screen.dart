import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/sales_invoice_controller.dart';
import 'package:gstark/screens/Home/home_screen.dart';

import '../../utils/text_utils/normal_text.dart';
import 'sales_invoice_image_upload_screen.dart';
import 'sales_invoice_view.dart';

class SalesInvoiceScreen extends StatefulWidget {
  const SalesInvoiceScreen({super.key});

  @override
  State<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends State<SalesInvoiceScreen> {
  late final SalesInvoiceController salesInvoiceController;

  @override
  void initState() {
    super.initState();
    salesInvoiceController = Get.isRegistered<SalesInvoiceController>()
        ? Get.find<SalesInvoiceController>()
        : Get.put(SalesInvoiceController());

    salesInvoiceController.initCall(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () {

        Get.off(const HomeScreen(),
            transition: Transition.rightToLeft);
         return Future.value(false);
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            // isExtended: true,
            backgroundColor: kPrimaryMain,
            onPressed: () {
              Get.to(const SalesInvoiceImageUploadScreen(),
                  transition: Transition.rightToLeft);
            },
            // isExtended: true,
            child: const Icon(
              Icons.photo_camera,
              color: kWhite,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: kApplicationThemeColor,
          iconTheme: const IconThemeData(color: kWhite),
          title: const NormalText(
            text: "Sales",
            textAlign: TextAlign.center,
            textFontWeight: FontWeight.w500,
            textSize: 20,
            textColor: kWhite,
          ),
          centerTitle: true,
        ),
        body: const SalesInvoiceView(),
      ),
    );
  }
}
