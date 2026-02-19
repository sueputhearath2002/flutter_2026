import 'package:basic_flutter/UI/main/crud_firebase/get_user_screen.dart';
import 'package:basic_flutter/UI/main/fetch_api_pagination.dart';
import 'package:basic_flutter/constant/color.dart';
import 'package:basic_flutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: GetUserScreen(),
      // FetchApiPagination(),
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
