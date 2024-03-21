import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../text_utils/normal_text.dart';

class TimerButton extends StatefulWidget {
  final Duration duration;
  final double buttonHeight;
  final double buttonWidth;
  final double fontSize;
  TimerButton({
    required this.duration,
    this.buttonHeight = 23,
    this.buttonWidth = 54,
    this.fontSize = 10,
  });

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  late Timer _timer;
  late Duration _duration;
  bool _lessThanOneHour = false;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    _lessThanOneHour = (_duration.inSeconds < 3600);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration - Duration(seconds: 1);
        _lessThanOneHour = (_duration.inSeconds < 3600);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String hours = (_duration.inHours < 10)
        ? '0${_duration.inHours}'
        : '${_duration.inHours}';
    String minutes = (_duration.inMinutes.remainder(60) < 10)
        ? '0${_duration.inMinutes.remainder(60)}'
        : '${_duration.inMinutes.remainder(60)}';
    String seconds = (_duration.inSeconds.remainder(60) < 10)
        ? '0${_duration.inSeconds.remainder(60)}'
        : '${_duration.inSeconds.remainder(60)}';
    String timerText = '$hours:$minutes:$seconds';
    Color backgroundColor = (_lessThanOneHour) ? kSecondaryMain : kSecondary200;
    Color textColor = (_lessThanOneHour) ? kWhite : kBlack;
    return Container(
      color: kSecondaryMain,
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      child: Center(
        child: NormalText(
          text: timerText,
          textColor: kWhite,
          textFontWeight: FontWeight.w600,
          textSize: widget.fontSize,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
