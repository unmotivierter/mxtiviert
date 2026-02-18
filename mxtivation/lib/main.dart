import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'navigation.dart';
import 'comparefunctions.dart';

enum TabItems { home, group, add, calendar, settings }

enum Sortby { sDesc, sAsc, sPbDesc, sPbAsc, nDesc, nAsc }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  Duration intervall;
  int amountPerIntervall;
  //add time left and time interval
  StreakItem(
    this.title,
    this.streakCount,
    this.streakPbCount,
    this.groupStreak,
    this.solo,
    this.goaler,
    this.duration,
    this.intervall,
    this.amountPerIntervall,
  );
}

class Globals extends ChangeNotifier {
  TabItems currentTab = TabItems.home;

  int Function(StreakItem a, StreakItem b) compareFunc = sortStreakDescending;

  List<StreakItem> streakItems = [
    StreakItem(
      "Streak 1",
      12,
      30,
      4,
      true,
      "Group 1",
      Duration(hours: 2),
      Duration(hours: 2),
      1,
    ),
    StreakItem(
      "Streak 2",
      1,
      14,
      0,
      false,
      "PePe",
      Duration(seconds: 10),
      Duration(seconds: 10),
      2,
    ),
  ];

  void selectTab(int i) {
    currentTab = TabItems.values[i];
    notifyListeners();
  }

  void setCompFunc(Sortby sort) {
    switch (sort) {
      case Sortby.sDesc:
        compareFunc = sortStreakDescending;
        break;
      case Sortby.sAsc:
        compareFunc = sortStreakAscending;
        break;
      case Sortby.sPbDesc:
        compareFunc = sortStreakPbDescending;
        break;
      case Sortby.sPbAsc:
        compareFunc = sortStreakPbAscending;
        break;
      case Sortby.nDesc:
        compareFunc = sortNameDescending;
        break;
      case Sortby.nAsc:
        compareFunc = sortNameAscending;
        break;
    }
    notifyListeners();
  }

  void addStreakItem(StreakItem item) {
    streakItems.add(item);
    notifyListeners();
  }

  void resetDuration(int idx) {
    streakItems[idx].duration = streakItems[idx].intervall;
    notifyListeners();
  }
}
