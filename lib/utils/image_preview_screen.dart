import 'package:flutter/material.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';

import '../constants/app_colors.dart';
import '../constants/string_constants.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String id;
  final String userId;
  const ImagePreviewScreen({required this.id,super.key, required this.userId});


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
            child: Image.network(
             "https://dev-api.gstark.co/api/document/${widget.id}/preview?clientId=${widget.userId}",
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

