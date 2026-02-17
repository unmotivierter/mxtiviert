import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'navigation.dart';
import 'homescreen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final List<StreakItem> streakItems = [StreakItem("Streak 1", 12, 30, true), StreakItem("Streak 2", 0, 4, false)];

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

class StreakItem{
  String title;
  int streakCount;
  int streakCountPb;
  bool solo;
  //add time left and time interval
  StreakItem(this.title, this.streakCount, this.streakCountPb, this.solo);
}