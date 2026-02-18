import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'navigation.dart';

enum TabItems { home, group, add, calendar, settings }
enum Sortby { sDesc, sAsc, sPbDesc, sPbAsc, nDesc, nAsc}

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => Globals(),
      child: MainApp())
    );
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
  int groupStreak;
  bool solo;
  String goaler; //name of person/group who have goal :)
  Duration duration;
  //add time left and time interval
  StreakItem(
    this.title,
    this.streakCount,
    this.streakPbCount,
    this.groupStreak,
    this.solo,
    this.goaler,
    this.duration,
  );
}


class Globals extends ChangeNotifier{
  TabItems currentTab = TabItems.home;
  

  void selectTab(int i) {
    currentTab = TabItems.values[i];
    notifyListeners();
  }

}