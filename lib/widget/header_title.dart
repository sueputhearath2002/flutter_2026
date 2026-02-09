import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/circle_button.dart';
import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.label,
    this.child,
    this.rightLabel = "",
    this.rightChild,
  });
  final String label;
  final Widget? child;
  final String rightLabel;
  final Widget? rightChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            if (rightLabel.isNotEmpty) ...[
              Row(
                spacing: 4,
                children: [
                  Text(
                    rightLabel,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  CircleButton(
                    onPressed: () {},
                    iconImage: arrowPng,
                    bgColor: mainColor,
                  ),
                ],
              ),
            ] else ...[
              rightChild ?? SizedBox.shrink(),
            ],
          ],
        ),
        child ?? SizedBox.shrink(),
      ],
    );
  }
}
