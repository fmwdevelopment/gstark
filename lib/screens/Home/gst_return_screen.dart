import 'package:flutter/material.dart';

import '../../utils/text_utils/normal_text.dart';

class GSTReturnScreen extends StatefulWidget {
  const GSTReturnScreen({Key? key}) : super(key: key);

  @override
  State<GSTReturnScreen> createState() => _GSTReturnScreenState();
}

class _GSTReturnScreenState extends State<GSTReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: NormalText(
          text: "GST Returns",
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    text: "report-2024_03_06-155714",
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
                              ),
                              const Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Icons.share))
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
