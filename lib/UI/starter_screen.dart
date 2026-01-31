import 'package:basic_flutter/UI/create_account.dart';
import 'package:basic_flutter/widget/button_cus.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatelessWidget {
  StarterScreen({super.key});
  final mainColor = Color(0xFF004CFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 134,
                  height: 134,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        spreadRadius: 3,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        spreadRadius: 3,
                      ),
                    ],
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset("assets/images/Group 1000004649.png"),
                ),
                Text(
                  "Shoppe",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 52),
                ),
                SizedBox(height: 30),
                Text(
                  "Beautiful eCommerce UI Kit\n for your online store",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 70),
                ButtonCus(
                  buttonName: "Let's get started",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccount()),
                    );
                  },
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I already have an account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: mainColor,
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
