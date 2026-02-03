import 'package:basic_flutter/constant/color.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    this.profileImage =
        "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
    this.width = 100,
    this.heiht = 100,
  });
  final String profileImage;
  final double width;
  final double heiht;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 10,
      height: heiht + 10,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 24,
            offset: Offset(0, 3),
          ),
          // BoxShadow(color: Colors.black12),
        ],
      ),
      child: Center(
        child: Container(
          width: width,
          height: heiht,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(profileImage, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
