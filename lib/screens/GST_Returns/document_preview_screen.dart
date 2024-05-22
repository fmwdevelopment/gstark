import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../constants/app_colors.dart';
import '../../utils/text_utils/normal_text.dart';

class DocumentPreviewScreen extends StatelessWidget {
  final String file;
  final String name;
  const DocumentPreviewScreen({super.key, required this.file, required this.name});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kApplicationThemeColor,
        iconTheme: const IconThemeData(color: kWhite, size: 24),
        title: NormalText(
          text: name,
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 16,
          textColor: kWhite,
        ),
        centerTitle: true,
      ),
         body: const PDF().cachedFromUrl(file),
    );
  }
}
