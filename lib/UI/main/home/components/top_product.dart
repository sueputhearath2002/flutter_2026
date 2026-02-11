import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/header_title.dart';
import 'package:basic_flutter/widget/profile_widget.dart';
import 'package:flutter/material.dart';

class TopProduct extends StatelessWidget {
  const TopProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderTitle(
      label: "Top Product",
      // rightLabel: "See All",
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (contexta, index) {
            return _buildRoundImageWidget();
          },
        ),
      ),
    );
  }

  Widget _buildRoundImageWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ProfileWidget(width: 60, heiht: 60),
    );
  }
}
