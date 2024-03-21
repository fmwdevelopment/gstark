import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateY, x, y }

class SlideInToastMessageAnimation extends StatelessWidget {
  final Widget child;

  const SlideInToastMessageAnimation(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Animation tween
    final _tween = MultiTween<AniProps>()
      ..add(AniProps.translateY, (-100.0).tweenTo(0.0), 250.milliseconds,
          Curves.easeOut)
      ..add(AniProps.translateY, (0.0).tweenTo(0.0),
          const Duration(seconds: 5, milliseconds: 250))
      ..add(
          AniProps.translateY, (0.0).tweenTo(-100.0), 5.seconds, Curves.easeIn)
      ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
      ..add(AniProps.opacity, 1.0.tweenTo(1.0), 5.seconds)
      ..add(AniProps.opacity, 1.0.tweenTo(0.0), 500.milliseconds);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500).round()),
      duration: _tween.duration,
      tween: _tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.translateY)), child: child),
      ),
    );
  }
}
