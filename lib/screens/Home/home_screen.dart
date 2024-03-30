import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/screens/Home/generate_invoice_screen.dart';
import 'package:gstark/screens/Home/gst_return_screen.dart';
import 'package:gstark/screens/Home/profile_screen.dart';
import 'package:gstark/screens/Home/purchase_screen.dart';
import 'package:gstark/screens/Home/reconciliation_list_screen.dart';
import 'package:gstark/screens/Home/sales_screen.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kPrimaryMain,
        title: const NormalText(
          text: "gStark",
          textSize: 24,
          textColor: kWhite,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      child:  Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                      maxRadius: 60,
                    ),
                    onTap: () {
                      Get.to(SalesScreen(),transition: Transition.rightToLeft);
                    },
                  ),
                  SizedBox(height: 10),
                  NormalText(
                    text: "SALES INVOICES",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      maxRadius: 60,
                      child:  Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                    ),
                    onTap: () {
                      Get.to(const PurchaseScreen(),transition: Transition.rightToLeft);
                    },
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
                    text: "PURCHASE INVOICES",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(const GSTReturnScreen(),transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      child: Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                      radius: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  NormalText(
                    text: "RETURNS",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
              Column(
                children: [
              GestureDetector(
                    onTap: (){
                      Get.to(const ProfileScreen(), transition: Transition.rightToLeftWithFade);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      maxRadius: 60,
                      child:  Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                    ),
                  ),
                  SizedBox(height: 10),
                  NormalText(
                    text: "PROFILE",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(const ReconciliationListScreen(), transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      child:  Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                      maxRadius: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  NormalText(
                    text: "2A/2B RECONCILIATION",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(const GenerateInvoiceScreen(), transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      child:  Image.asset("assets/images/dummy.png",width: 60,height: 60,),
                      maxRadius: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  NormalText(
                    text: "GENERATE INVOICE",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 14,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
