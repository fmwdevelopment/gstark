import 'package:flutter/material.dart';

import 'shimmerLoader.dart';

class ShimmerHorizontalLoadingTile extends StatelessWidget {
  const ShimmerHorizontalLoadingTile(
      {super.key, required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
        child: Container(
      height: height,
      width: width ?? MediaQuery.of(context).size.width,
      color: Colors.grey,
    ));
  }
}
