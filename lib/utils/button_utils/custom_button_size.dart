import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../text_utils/normal_text.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final String size;
  final IconData icon;
  final Color borderColor;
  final double height;
  final double width;
  final double borderRadius;
  final Function()? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
    this.size = '',
    this.borderColor = Colors.grey,
    this.height = 40,
    this.width = 150,
    this.borderRadius = 20,
    this.onPressed,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isIcon1 = true;
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isIcon1 = !_isIcon1;
          _isExpanded = true;
        });
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      child: Container(
        height: _isExpanded ? widget.height + 13 : widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: NormalText(
                    text: widget.text,
                    textSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    _isIcon1 ? widget.icon : Icons.keyboard_arrow_up,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isExpanded,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: NormalText(
                      text: widget.size,
                      textSize: 12,
                      textColor: kPrimaryMain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
