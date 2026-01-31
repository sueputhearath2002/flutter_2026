import 'package:basic_flutter/UI/password_type_screen.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/constant/image.dart';
import 'package:basic_flutter/widget/password_dot.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  static const int pinLength = 8;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 26,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: grey30Color,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not you?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordTypeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: mainColor,
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ],
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

            ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 150),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 24),
                      // BoxShadow(color: Colors.black12),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello Romina!!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Type your password", style: TextStyle(fontSize: 19)),
                  ],
                ),
                SizedBox(height: 30),
                Pinput(
                  defaultPinTheme: defaultPinTheme,

                  validator: (s) {
                    return s == '2222' ? null : 'Pin is incorrect';
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
