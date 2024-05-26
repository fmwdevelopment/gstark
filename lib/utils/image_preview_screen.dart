import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';

import '../constants/app_colors.dart';
import '../constants/string_constants.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String file;
  final bool isPdf;
  const ImagePreviewScreen({required this.file,super.key, required this.isPdf});


  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kApplicationThemeColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: const NormalText(
          text: imagePreview,
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
          textColor: kWhite,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        child: Center(
          child: InteractiveViewer(
            scaleEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: widget.isPdf ?  const PDF().cachedFromUrl(widget.file):Image.network(widget.file,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(color: kApplicationThemeColor,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48.0,
                      ),
                      NormalText(text: "Image error")
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

