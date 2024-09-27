import 'package:flutter/material.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';
import '../constants/app_colors.dart';
import '../constants/string_constants.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String file;
  const ImagePreviewScreen({required this.file,super.key});


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
            child: Image.network(widget.file,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      color: kApplicationThemeColor,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.red),
                      ),
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

