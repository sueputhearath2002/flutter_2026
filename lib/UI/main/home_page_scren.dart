import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/circle_button.dart';
import 'package:basic_flutter/widget/profile_widget.dart';
import 'package:flutter/material.dart';

class HomePageScren extends StatelessWidget {
  const HomePageScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        clipBehavior: Clip.none,
        automaticallyImplyLeading: false,
        title: Row(
          spacing: 16,
          children: [
            ProfileWidget(width: 50, heiht: 50),
            Chip(
              side: BorderSide(color: mainColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(32),
              ),
              label: Text("My Activity"),
              labelStyle: TextStyle(color: whiteColor),
              backgroundColor: mainColor,
            ),
          ],
        ),

        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          CircleButton(iconSvg: scanPng),
          CircleButton(iconSvg: filterPng, isShowBadg: true),
          CircleButton(iconSvg: settingPng),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [helloWidget(), SizedBox(height: 8), anounmentWidget()],
      ),
    );
  }

  Widget helloWidget() {
    return Text(
      "Hello, Romina!",
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
    );
  }

  Widget anounmentWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: grey30Color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Announcement",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas hendrerit luctus libero ac vulputate.",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ],
            ),
          ),
          CircleButton(iconSvg: arrowPng, bgColor: mainColor, onPressed: () {}),
        ],
      ),
    );
  }

  // Widget recentReviewWidget(){
  //   return
  // }
}
