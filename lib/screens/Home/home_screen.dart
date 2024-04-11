import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/screens/generate_invoice/generate_invoice_screen.dart';
import 'package:gstark/screens/GST_Returns/gst_return_screen.dart';
import 'package:gstark/screens/Profile/profile_screen.dart';
import 'package:gstark/screens/purchase_inovice/purchase_invoice_screen.dart';
import 'package:gstark/screens/reconciliation_list/reconciliation_list_screen.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';

import '../sales_invoice/sales_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: kApplicationThemeColor,
        title: const NormalText(
          text: "gStark",
          textSize: 24,
          textFontWeight:FontWeight.w700,
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
                      maxRadius: 60,
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                    onTap: () {
                      Get.to(const SalesInvoiceScreen(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
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
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                    onTap: () {
                      Get.to(const PurchaseInvoiceScreen(),
                          transition: Transition.rightToLeft);
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
                    onTap: () {
                      Get.to(const GSTReturnScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      radius: 60,
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
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
                    onTap: () {
                      Get.to(const ProfileScreen(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      maxRadius: 60,
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
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
                    onTap: () {
                      Get.to(const ReconciliationListScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      maxRadius: 60,
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
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
                    onTap: () {
                      Get.to(const GenerateInvoiceScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: CircleAvatar(
                      backgroundColor: kNeutral100,
                      maxRadius: 60,
                      child: Image.asset(
                        "assets/images/dummy.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const NormalText(
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
