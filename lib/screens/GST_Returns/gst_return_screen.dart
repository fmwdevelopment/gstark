import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gstark/controller/gst_returns_controller.dart';
import 'package:gstark/screens/GST_Returns/document_preview_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/text_utils/normal_text.dart';
import '../authentication/login_screen_loader.dart';

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
       body: Obx(() => gstReturnController.isBusy
           ? const LoginScreenLoader()
           : gstReturnController.returnsData.isEmpty
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
                   gstReturnController.returnsData.length,
                   itemBuilder: (BuildContext context, int index) {
                     return InkWell(
                       onTap: () {
                          // TODO: implement doc preview screen
                         Get.to(DocumentPreviewScreen(file: gstReturnController.returnsData[index].file ?? "",
                           name: gstReturnController.returnsData[index].name ?? "",));
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
                                       gstReturnController
                                           .returnsData[index]
                                           .thumbnail ??
                                           "",
                                       errorBuilder: (BuildContext
                                       context,
                                           Object exception,
                                           StackTrace? stackTrace) {
                                         return (gstReturnController
                                             .returnsData[index].mimetype != null && gstReturnController
                                             .returnsData[index].mimetype!.contains("pdf"))?
                                         const Icon(Icons.picture_as_pdf):
                                         const Icon(Icons.error);
                                       },
                                     ),
                                   ),
                                   gstReturnController
                                       .returnsData[index]
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
                                   NormalText(
                                     text: gstReturnController
                                         .returnsData[index]
                                         .name ??
                                         "",
                                     textAlign: TextAlign.center,
                                     textFontWeight: FontWeight.w500,
                                     textSize: 14,
                                   ),
                                   NormalText(
                                     text: getDateTime(
                                         gstReturnController
                                             .returnsData[index]
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

