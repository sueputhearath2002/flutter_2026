import 'package:basic_flutter/UI/starter_screen.dart';
import 'package:basic_flutter/basic_widget/list_view_builder_widget.dart';
import 'package:basic_flutter/basic_widget/scaffold_widget.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerTheme: DividerThemeData(color: Colors.transparent),
        scaffoldBackgroundColor: whiteColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StarterScreen(),
      // ListViewBuilderWidet(),
      // CardWidget(),
      // \ListviewWidget(),
      //  PaddingSizedboxExpanded(),
      // RowColumnButton(),
      // home: BasicWidget(),
    );
  }
}
