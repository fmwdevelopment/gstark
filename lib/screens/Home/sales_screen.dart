import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/controller/sales_invoice_controller.dart';

import '../../utils/text_utils/normal_text.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  late final SalesInvoiceController salesInvoiceController;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    salesInvoiceController = Get.isRegistered<SalesInvoiceController>()
        ? Get.find<SalesInvoiceController>()
        : Get.put(SalesInvoiceController());
    
    WidgetsBinding.instance
        .addPostFrameCallback((_) => salesInvoiceController.getAllSalesInvoice(context));
    //initCall();
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
        title: NormalText(
          text: "Sales",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: salesInvoiceController.salesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Image.network(salesInvoiceController.salesData[index].thumbnail ?? ""),
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text: salesInvoiceController.salesData[index].name ?? "",
                                    textAlign: TextAlign.center,
                                    textFontWeight: FontWeight.w500,
                                    textSize: 14,
                                  ),
                                  NormalText(
                                    text: salesInvoiceController.salesData[index].cratedAt ?? "",
                                    textAlign: TextAlign.center,
                                    textFontWeight: FontWeight.w200,
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
            ),
          ))
        ],
      ),
    );
  }
}
