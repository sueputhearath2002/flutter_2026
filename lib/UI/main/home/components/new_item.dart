import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/header_title.dart';
import 'package:flutter/material.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderTitle(
      label: "New Items",
      rightLabel: "See All",
      child: SizedBox(
        height: 200,
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
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 130,
              padding: EdgeInsets.all(4),
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
              child: Center(
                child: Container(
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
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Lorem ipsum dolor sit amet consectetur.",
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    "\$17,00",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
