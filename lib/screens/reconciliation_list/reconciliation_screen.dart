import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/screens/reconciliation_list/reconciliation_tab_view.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../controller/reconciliation_screen_controller.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/login_screen_loader.dart';
import 'excel_list_view.dart';

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
    reconciliationScreenController = Get.isRegistered<ReconciliationScreenController>()
        ? Get.find<ReconciliationScreenController>()
        : Get.put(ReconciliationScreenController());
    reconciliationScreenController.initCall(context);
  }
  @override
  Widget build(BuildContext context) {
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
      body: Obx(() => reconciliationScreenController.isBusy
          ? const LoginScreenLoader()
          : reconciliationScreenController.reconciliationData.isEmpty
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
                  reconciliationScreenController.reconciliationData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        // TODO: implement doc preview screen
                        print("url: ${ reconciliationScreenController.reconciliationData[index].file } at index: $index");
                        // Get.to( ExcelListView( name:reconciliationScreenController.reconciliationData[index].name ?? "" ,
                        //     fileUrl: reconciliationScreenController.reconciliationData[index].file ?? ""),transition: Transition.rightToLeft);
                        Get.to(ReconciliationTabView(name:reconciliationScreenController.reconciliationData[index].name ?? "",
                            fileUrl: reconciliationScreenController.reconciliationData[index].file ?? ""),transition: Transition.rightToLeft);
                      },
                      child: Container(
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
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(
                                      reconciliationScreenController.reconciliationData[index]
                                          .thumbnail ??
                                          "",
                                      errorBuilder: (BuildContext
                                      context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(
                                            Icons.file_copy_outlined);
                                      },
                                    ),
                                  ),
                                  reconciliationScreenController.reconciliationData[index]
                                      .reviewed ==
                                      true
                                      ? const Icon(
                                    Icons.check,
                                    color: kWhite,
                                  )
                                      : Container()
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: NormalText(
                                      text: reconciliationScreenController.reconciliationData[index]
                                          .name ??
                                          "",
                                      textAlign: TextAlign.start,
                                      textFontWeight: FontWeight.w500,
                                      textSize: 14,
                                    
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  NormalText(
                                    text: getDateTime(
                                        reconciliationScreenController.reconciliationData[index]
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
                      ),
                    );
                  }),
            ))
          ],
        ),
      )),
    );
  }
}

