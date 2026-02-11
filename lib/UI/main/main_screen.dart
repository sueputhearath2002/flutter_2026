import 'package:basic_flutter/UI/main/home/home_page_scren.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectPage = 0;

  final List<Widget> _pages = [
    HomePageScren(),
    Center(child: Text("Favorite")),
    Center(child: Text("History")),
    Center(child: Text("Cart")),
    Text("Profile"),
  ];

  final List<String> _outlineIcon = [
    homeSvg,
    favoriteSvg,
    historySvg,
    cartSvg,
    profileSvg,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectPage],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Row(
              children: List.generate(_outlineIcon.length, (index) {
                bool isSelected = _selectPage == index;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _selectPage = index;
                      });
                    },
                    child: Column(
                      spacing: 6,
                      children: [
                        SvgPicture.asset(
                          _outlineIcon[index],
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            isSelected ? Colors.black : mainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        AnimatedContainer(
                          height: 3,
                          width: isSelected ? 16 : 0,
                          duration: Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : mainColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
