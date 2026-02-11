import 'package:basic_flutter/UI/main/fech_api.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/profile_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FetchApiScreen extends StatelessWidget {
  const FetchApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fetching API")),
      body: FutureBuilder(
        future: FechApi.fetchProduct(1),
        builder: (context, snapshot) {
          final products = snapshot.data;
          print("=======================${products}");
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: products?.length,
            itemBuilder: (context, index) {
              final images = products?[index].images;
              return Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: images?.length,
                    itemBuilder:
                        (
                          BuildContext context,
                          int itemIndex,
                          int pageViewIndex,
                        ) => Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: Image.network(
                            fit: BoxFit.cover,
                            images?[itemIndex].toString() ?? "",
                          ),
                        ),
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      initialPage: 2,
                    ),
                  ),

                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (indexDot) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor,
                        ),
                        width: 12,
                        height: 12,
                      );
                    }),
                  ),

                  Text(
                    products?[index].title ?? "",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "\$${products?[index].price ?? ""}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  Text(
                    "Discover the perfect blend of style and comfort with our Classic Comfort Fit Joggers",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      ProfileWidget(width: 40, heiht: 40),
                      Column(
                        children: [
                          Text(
                            "clothes m",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "clothes m",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
