import 'package:basic_flutter/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.iconSvg,
    this.onPressed,
    this.bgColor = grey30Color,
    this.isShowBadg = false,
  });
  final String iconSvg;
  final VoidCallback? onPressed;
  final Color bgColor;
  final bool isShowBadg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Badge(
        smallSize: 13,
        backgroundColor: mainColor,
        isLabelVisible: isShowBadg,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            minimumSize: Size(45, 45),
            padding: EdgeInsets.zero,
            backgroundColor: bgColor,
          ),
          child: Image.asset(iconSvg),
        ),
      ),
    );
  }
}
