import 'package:basic_flutter/UI/main/home/components/categories.dart'
    show Categories;
import 'package:basic_flutter/UI/main/home/components/flash_sales.dart';
import 'package:basic_flutter/UI/main/home/components/most_popular.dart';
import 'package:basic_flutter/UI/main/home/components/new_item.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/circle_button.dart';
import 'package:basic_flutter/widget/header_title.dart';
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
          CircleButton(iconImage: scanPng),
          CircleButton(iconImage: filterPng, isShowBadg: true),
          CircleButton(iconImage: settingPng),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          helloWidget(),
          SizedBox(height: 8),
          anounmentWidget(),
          Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              recentReviewWidget(),
              myOrderWidget(),
              storiesWidget(),
              NewItem(),
              MostPopular(),
              Categories(),
              FlashSales(),
            ],
          ),
        ],
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
          CircleButton(
            iconImage: arrowPng,
            bgColor: mainColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget storiesWidget() {
    return HeaderTitle(
      label: "Stories",
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (contexta, index) {
            return _buildStorieCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildStorieCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa5-o4S8u6hRuTCIPPTqswd9R0-KQv6FdrIA&s",
              fit: BoxFit.cover,
              width: 120,
              height: 200,
            ),
          ),
          if (index == 0)
            Positioned(
              left: 8,
              top: 16,
              child: Chip(
                side: BorderSide(color: Colors.transparent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                label: Text("Live"),
                labelPadding: EdgeInsets.symmetric(horizontal: 8),
                labelStyle: TextStyle(
                  color: whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: greenColor,
              ),
            ),

          CircleButton(
            svgIcon: playSvg,
            onPressed: () {},
            bgColor: grey30Color.withValues(alpha: .5),
            width: 36,
            height: 36,
            iconImage: '',
          ),
        ],
      ),
    );
  }

  Widget myOrderWidget() {
    List<String> myOrder = ["To Pay", "To Recieve", "To Review"];
    return HeaderTitle(
      label: "My Orders",
      child: Row(
        spacing: 12,
        children: List.generate(myOrder.length, (index) {
          bool isShowbage = myOrder[index] == "To Recieve";
          return Badge(
            smallSize: 13,
            backgroundColor: greenColor,
            isLabelVisible: isShowbage,
            child: Chip(
              side: BorderSide(color: Colors.transparent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(32),
              ),
              label: Text(myOrder[index].toString()),
              labelStyle: TextStyle(
                color: mainColor,
                wordSpacing: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: mainColor.withValues(alpha: 0.1),
            ),
          );
        }),
      ),
    );
  }

  Widget recentReviewWidget() {
    return HeaderTitle(
      label: "Recently viewed",
      child: Container(
        color: whiteColor,
        height: 100,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          // clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ProfileWidget(width: 65, heiht: 65);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 12);
          },
          itemCount: 12,
        ),
      ),
    );
  }
}
