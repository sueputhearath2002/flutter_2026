import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/chip_widget.dart';
import 'package:basic_flutter/widget/header_title.dart';
import 'package:flutter/material.dart';

class FlashSales extends StatelessWidget {
  const FlashSales({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderTitle(
      label: "Flash Sales",
      rightChild: rightChild(),
      child: SizedBox(
        height: 170,
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

  Widget rightChild() {
    return Row(
      spacing: 8,
      children: [
        Icon(Icons.timer, color: mainColor),
        ChipWidget(
          title: '00',
          round: 8,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        ChipWidget(
          title: '00',
          round: 8,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),

        ChipWidget(
          title: '00',
          round: 8,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildNewItemWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 180,
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
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEceGoR-lZVZO6GfFe9UoLJAb3OkgflZtaUQ&s",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [pink100Color, pink30Color]),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                ),
                child: Text(
                  "-20%",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
