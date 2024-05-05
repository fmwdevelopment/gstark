import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../constants/app_colors.dart';
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
      body: PDF().cachedFromUrl(
          'https://dev-api.gstark.co/api/document/b29e0b91-7aa2-4118-8623-d3fdb3e77e5f/preview?clientId=dcae8e4d-14bf-4c6c-93eb-b17922e41e43'),
    );
  }
}
