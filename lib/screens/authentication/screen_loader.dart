import 'package:flutter/material.dart';
import 'package:gstark/utils/shimmer_loader/shimmerLoader.dart';
import 'package:gstark/utils/shimmer_loader/shimmer_task_tile.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 300,
        margin: const EdgeInsets.only(top: 15),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
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
