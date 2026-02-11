import 'package:basic_flutter/UI/main/home/home_page_scren.dart';
import 'package:basic_flutter/UI/main/main_screen.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/card_dashboard.dart';
import 'package:flutter/material.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;
  final bool isShowButton;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
    this.isShowButton = false,
  });
}

class HelloCardScreen extends StatefulWidget {
  const HelloCardScreen({super.key});

  @override
  State<HelloCardScreen> createState() => _HelloCardScreenState();
}

class _HelloCardScreenState extends State<HelloCardScreen> {
  final PageController pageController = PageController();
  int indexScroll = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: helloCard1,
      title: 'Hello',
      description:
          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.\nSed non consectetur turpis.\nMorbi eu eleifend lacus.,Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.\nSed non consectetur turpis.\nMorbi eu eleifend lacus.Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.\nSed non consectetur turpis.\nMorbi eu eleifend lacus.',
      isShowButton: false,
    ),
    OnboardingItem(
      image: helloCard1,
      title: 'Hello world!',
      description:
          'Lorem ipsum dolor sit amet,\nSed non consectetur turpis.\nMorbi eu eleifend lacus.',
      isShowButton: false,
    ),
    OnboardingItem(
      image: helloCard1,
      title: 'Ready?',
      description: 'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.',
      isShowButton: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 200,
              left: 0,
              child: Image.asset(greyBackground4, width: 160),
            ),
            Positioned(top: 0, left: 0, child: Image.asset(blueBackground5)),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 3,
                    child: PageView.builder(
                      controller: pageController,
                      clipBehavior: Clip.none,
                      itemCount: _items.length,
                      onPageChanged: (value) => setState(() {
                        indexScroll = value;
                      }),

                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return CardDashboard(
                          image: item.image,
                          title: item.title,
                          description: item.description,
                          isShowButton: item.isShowButton,
                          onClick: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30),
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_items.length, (index) {
                      bool isSelected = indexScroll == index;
                      return _dot(dotColor: isSelected ? mainColor : greyColor);
                    }),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot({required Color dotColor}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
    );
  }
}
