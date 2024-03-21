import 'package:flutter/material.dart';

class IconImage extends StatelessWidget {
  const IconImage({
    super.key,
    required this.image,
    this.height,
    this.color,
    this.width,
  });

  final String image;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      color: color,
      height: height,
      width: width,
    );
  }
}
