import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstark/utils/shimmer_loader/shimmerLoader.dart';
import 'package:gstark/utils/shimmer_loader/shimmer_task_tile.dart';

class UpdateProfileScreenLoader extends StatelessWidget {
  const UpdateProfileScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(top: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ShimmerLoader(
                child: ShimmerHorizontalLoadingTile(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ShimmerLoader(
                  child: ShimmerHorizontalLoadingTile(
                    height: 48,
                    width: MediaQuery.of(context).size.width/2,
                  ),
                ),
              ),

            ],
          ),
        ));
  }
}
