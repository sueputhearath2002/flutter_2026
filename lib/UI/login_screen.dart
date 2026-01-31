import 'package:basic_flutter/UI/password_screen.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/button_cus.dart';
import 'package:basic_flutter/widget/text_form_cus.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(top: 0, left: 0, child: Image.asset(greyBackground)),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(blueBackground3, width: 160),
                ),
              ],
            ),
            Positioned(top: 300, right: 0, child: Image.asset(blueBackground2)),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(greyBackground2),
            ),
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 500),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Good to see you back!',
                      style: TextStyle(fontSize: 19),
                    ),
                    Icon(Icons.favorite),
                  ],
                ),
                SizedBox(height: 24),
                TextFormCus(hintText: "Email"),
                SizedBox(height: 36),
                ButtonCus(
                  buttonName: "Next",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordScreen()),
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
}
