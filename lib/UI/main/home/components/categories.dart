import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/header_title.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderTitle(
      rightLabel: "See All",
      label: 'Categories',
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
        ),
        padding: EdgeInsets.all(8.0), // padding around the grid
        itemCount: 4, // total number of items
        itemBuilder: (context, index) {
          return Container(
            // width: 130,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text("123456789"),
          );
        },
      ),
    );
  }

  Widget _buildNewItemWidget() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
        ),
        padding: EdgeInsets.all(8.0), // padding around the grid
        itemCount: 4, // total number of items
        itemBuilder: (context, index) {
          return Container(
            // width: 130,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text("123456789"),
          );
        },
      ),
    );
  }
}
