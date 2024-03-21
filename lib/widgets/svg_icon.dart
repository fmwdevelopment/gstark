import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class CustomSvgIcon extends StatelessWidget {
  const CustomSvgIcon({
    super.key,
    required this.icon,
    this.height = 32,
    this.width = 32,
    this.color = kBlack,
  });

  final String icon;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      height: height,
      width: width,
      color: color,
    );
  }
}
