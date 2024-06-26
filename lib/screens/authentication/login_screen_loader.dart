import 'package:flutter/material.dart';
import 'package:gstark/utils/shimmer_loader/shimmerLoader.dart';
import 'package:gstark/utils/shimmer_loader/shimmer_task_tile.dart';

class LoginScreenLoader extends StatelessWidget {
  const LoginScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(top: 15),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ShimmerLoader(
                  child: ShimmerHorizontalLoadingTile(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              );
            }));
  }
}
