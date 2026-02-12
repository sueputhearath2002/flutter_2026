import 'package:basic_flutter/UI/main/fetch_api_pagination.dart';
import 'package:basic_flutter/UI/main/fetch_api_screen.dart';
import 'package:basic_flutter/UI/starter_screen.dart';
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
        appBarTheme: AppBarTheme(backgroundColor: whiteColor),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FetchApiPagination(),
      // FetchApiScreen(),
      // StarterScreen(),
      // ListViewBuilderWidet(),
      // CardWidget(),
      // \ListviewWidget(),
      //  PaddingSizedboxExpanded(),
      // RowColumnButton(),
      // home: BasicWidget(),
    );
  }
}
