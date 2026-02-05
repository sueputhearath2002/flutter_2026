import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/header_title.dart';
import 'package:flutter/material.dart';

class MostPopular extends StatelessWidget {
  const MostPopular({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderTitle(
      label: "Most Popular",
      rightLabel: "See All",
      child: SizedBox(
        height: 190,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (contexta, index) {
            return _buildNewItemWidget();
          },
        ),
      ),
    );
  }

  Widget _buildNewItemWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 130,
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
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEceGoR-lZVZO6GfFe9UoLJAb3OkgflZtaUQ&s",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "1780",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(Icons.favorite, color: mainColor, size: 20),
                      ],
                    ),
                    Text(
                      "New",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
