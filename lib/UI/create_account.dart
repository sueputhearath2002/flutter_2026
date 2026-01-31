import 'package:basic_flutter/UI/login_screen.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/button_cus.dart';
import 'package:basic_flutter/widget/text_form_cus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: Image.asset(greyBackground)),
            Positioned(top: 30, right: 0, child: Image.asset(blueBackground)),
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 100),
                Text(
                  'Create \nAccount',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 30),
                _buildCameraImage(),
                SizedBox(height: 30),
                TextFormCus(hintText: "Email"),
                SizedBox(height: 12),
                TextFormCus(
                  hintText: "Password",
                  suffixIcon: Icon(Icons.visibility),
                ),
                SizedBox(height: 12),
                TextFormCus(
                  preffixIcon: _buildPrefixNumberPhone(),
                  hintText: "Your Number",
                ),
                SizedBox(height: 60),
                ButtonCus(
                  buttonName: "Done",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrefixNumberPhone() {
    return GestureDetector(
      onTap: () {
        print("==================123");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(englandFlage, width: 24),
            const Icon(Icons.keyboard_arrow_down_outlined, size: 18),
            Container(height: 24, color: Colors.black45, width: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraImage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: DottedBorder(
        options: CircularDottedBorderOptions(
          dashPattern: [24, 8],
          strokeWidth: 2,
          color: mainColor,
          padding: EdgeInsets.all(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Icon(Icons.camera_alt_outlined, size: 45, color: mainColor),
        ),
      ),
    );
  }
}
