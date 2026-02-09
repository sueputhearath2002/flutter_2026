import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/chip_select.dart';
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
          childAspectRatio: 2 / 2.6,
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        padding: EdgeInsets.all(8.0),
        itemCount: 4,

        itemBuilder: (context, index) {
          return Container(
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
            child: Column(
              children: [
                Expanded(child: _buildImageGride()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Clothing",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Chip(
                      side: BorderSide(color: Colors.transparent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                      ),
                      label: Text("150"),
                      labelStyle: TextStyle(
                        color: mainColor,
                        wordSpacing: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: mainColor.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGride() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2 / 2.1,
        crossAxisSpacing: 8.0,
      ),
      padding: EdgeInsets.all(8.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEceGoR-lZVZO6GfFe9UoLJAb3OkgflZtaUQ&s",
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
