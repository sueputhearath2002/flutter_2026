import 'package:basic_flutter/constant/color.dart';
import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    super.key,
    required this.title,
    this.bgColor = mainColor,
    this.round = 16,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });
  final String title;
  final Color bgColor;
  final double round;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Chip(
      side: BorderSide(color: Colors.transparent),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(round),
      ),
      label: Text(title, style: TextStyle(fontSize: 14)),
      labelStyle: TextStyle(
        color: bgColor,
        wordSpacing: 1.5,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      backgroundColor: bgColor.withValues(alpha: 0.1),
    );
  }
}
