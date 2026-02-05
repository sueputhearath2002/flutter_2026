import 'package:basic_flutter/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.iconImage = "",
    this.svgIcon = "",
    this.onPressed,
    this.bgColor = grey30Color,
    this.isShowBadg = false,
    this.width = 40,
    this.height = 40,
  });
  final String iconImage;
  final VoidCallback? onPressed;
  final Color bgColor;
  final bool isShowBadg;
  final double width;
  final double height;
  final String svgIcon;

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
            minimumSize: Size(width, height),
            padding: EdgeInsets.zero,
            backgroundColor: bgColor,
          ),
          child: svgIcon.isNotEmpty
              ? SvgPicture.asset(
                  svgIcon,
                  width: width * 0.4,
                  height: height * 0.4,
                  colorFilter: ColorFilter.mode(whiteColor, BlendMode.srcIn),
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  iconImage,
                  width: width * 0.4,
                  height: height * 0.4,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
