import 'package:flutter/material.dart';
import 'package:gstark/utils/shimmer_loader/shimmerLoader.dart';
import 'package:gstark/utils/shimmer_loader/shimmer_task_tile.dart';

class LoginScreenLoader extends StatelessWidget {
  const LoginScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top: 150,left: 35,right: 35),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            child: ShimmerLoader(
              child: ShimmerHorizontalLoadingTile(
                height: 60,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            child: ShimmerLoader(
              child: ShimmerHorizontalLoadingTile(
                height: 60,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          )
        ],
      ),
    );
  }
}
