import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'navigation.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.flutterDash),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.flutterDash),
      //themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      home: App(),
    );
  }
}

class StreakItem {
  String title;
  int streakCount;
  int streakPbCount;
  bool solo;
  String goaler; //name of person/group who have goal :)
  //add time left and time interval
  StreakItem(this.title, this.streakCount, this.streakPbCount, this.solo, this.goaler);
}
