import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/constants/shared_preference_string.dart';
import 'package:gstark/screens/generate_invoice/generate_invoice_screen.dart';
import 'package:gstark/screens/GST_Returns/gst_return_screen.dart';
import 'package:gstark/screens/Profile/profile_screen.dart';
import 'package:gstark/screens/purchase_inovice/purchase_invoice_screen.dart';
import 'package:gstark/screens/reconciliation_list/excel_list_view.dart';
import 'package:gstark/screens/reconciliation_list/reconciliation_screen.dart';
import 'package:gstark/utils/shared_preference/custom_shared_preference.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';
import '../sales_invoice/sales_invoice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kApplicationThemeColor,
          title: const NormalText(
            text: "gStark",
            textSize: 24,
            textFontWeight: FontWeight.w600,
            textColor: kWhite,
          ),
        ),
        body: Container(
          color: kWhite,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/sale.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                        onTap: () {
                          Get.to(const GenerateInvoiceScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/invoice.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String clientId = await CustomSharedPref.getPref(
                              SharedPreferenceString.clientId);
                          String reviewerId = await CustomSharedPref.getPref(
                              SharedPreferenceString.reviewerId);
                          print("clientId: $clientId");
                          print("reviewerIdId: $reviewerId");
                          Get.to(const GSTReturnScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/gst_returns.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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

                ],
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/purchase.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {

                          // Get.to(ExcelDownloader(),
                          //     transition: Transition.rightToLeft);

                          Get.to(const ReconciliationScreen(),
                              transition: Transition.rightToLeft);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/reconciliation.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                          Get.to(const ProfileScreen(),
                              transition: Transition.rightToLeftWithFade);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kApplicationThemeColor, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            maxRadius: 60,
                            child: SizedBox(
                              width: 85, // Diameter of the CircleAvatar
                              height: 85,
                              child: Image.asset(
                                "assets/images/profile.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
