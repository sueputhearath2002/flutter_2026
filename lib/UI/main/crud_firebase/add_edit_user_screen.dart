import 'package:basic_flutter/UI/main/model/user_model.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/widget/button_cus.dart';
import 'package:basic_flutter/widget/text_form_cus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

class AddEditUserScreen extends StatelessWidget {
  AddEditUserScreen({super.key});
  final List<String> geners = ['Male', 'Femal', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonCus(buttonName: 'Save user', onPressed: () {}),
        ),
      ],
      appBar: AppBar(title: Text("Add & Edit USER")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormCus(hintText: "User name"),
          SizedBox(height: 16),
          TextFormCus(hintText: "Age"),
          SizedBox(height: 16),
          TextFormCus(hintText: "Address"),
          SizedBox(height: 16),
          DropdownFlutter<String>(
            decoration: CustomDropdownDecoration(
              closedFillColor: grey30Color,
              closedBorderRadius: BorderRadius.circular(32),
            ),
            hintText: 'Select gender',
            items: geners,
            initialItem: 'Male',
            onChanged: (value) => print(value),
          ),
        ],
      ),
    );
  }
}
