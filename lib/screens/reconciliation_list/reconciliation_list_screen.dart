import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/controller/reconciliation_list_screen_controller.dart';

import '../../constants/app_colors.dart';
import '../../utils/text_utils/normal_text.dart';

class ReconciliationListScreen extends StatefulWidget {
  const ReconciliationListScreen({Key? key}) : super(key: key);

  @override
  State<ReconciliationListScreen> createState() => _ReconciliationListScreenState();
}

class _ReconciliationListScreenState extends State<ReconciliationListScreen> {

  late final ReconciliationListScreenController reconciliationListScreenController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reconciliationListScreenController = Get.isRegistered<ReconciliationListScreenController>()
        ? Get.find<ReconciliationListScreenController>()
        : Get.put(ReconciliationListScreenController());
    reconciliationListScreenController.initCall(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kApplicationThemeColor,
        iconTheme: const IconThemeData(color: kWhite, size: 24),
        title: const NormalText(
          text: "Reconciliation List",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
          textColor: kWhite,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
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
                                child: Image.asset("assets/images/dummy.png"),
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NormalText(
                                    text: "gstr_reconciliation_2024_03_07-150014",
                                    textAlign: TextAlign.center,
                                    textFontWeight: FontWeight.w500,
                                    textSize: 14,
                                  ),
                                  NormalText(
                                    text: "01-01-2024",
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
          )
        ],
      ),
    );
  }
}
