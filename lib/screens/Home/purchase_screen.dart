
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../utils/text_utils/normal_text.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
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
          text: "Purchase",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
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
                                    text: "purchase-150014",
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
