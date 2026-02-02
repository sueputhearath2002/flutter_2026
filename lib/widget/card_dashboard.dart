import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/button_cus.dart';
import 'package:flutter/material.dart';

class CardDashboard extends StatelessWidget {
  const CardDashboard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.isShowButton = false,
  });
  final String image;
  final String title;
  final String description;
  final bool isShowButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 56),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2, 2),
            blurRadius: 24,
          ),
        ],
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Image.asset(image),
          ),
          SizedBox(height: 45),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w300,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          if (isShowButton) ...[
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: ButtonCus(buttonName: "Let's Start", onPressed: () {}),
            ),
          ],
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
