import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'navigation.dart';
import 'comparefunctions.dart';
import 'package:table_calendar/table_calendar.dart';

enum TabItems { home, group, add, calendar, settings }

enum Sortby { sDesc, sAsc, sPbDesc, sPbAsc, nDesc, nAsc }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await getApplicationDocumentsDirectory();
  final imageDir = Directory(path.join(appDir.path, 'images'));
  if (!await imageDir.exists()) {
    await imageDir.create(recursive: true);
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => Globals(imageDir: imageDir),
      child: MainApp(),
    ),
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

class StreakPhotos {
  List<File> photos = [];
  Map<String, bool> verifiedPhotos = {};
}

class Globals extends ChangeNotifier {
  Globals({required this.imageDir});
  Directory imageDir = Directory('');
  Map<String, StreakPhotos> getPhotosForItem = {};

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

  ///////Timer logic here:

  final Map<int, Timer> _timers = {};

  Map<StreakItem, Color> streakColors = {};

  void startTimer(int idx) {
    _timers[idx]?.cancel();

    _timers[idx] = Timer.periodic(Duration(seconds: 1), (_) => reduceTime(idx));

    notifyListeners();
  }

  void reduceTime(int idx) {
    final currentDuration = streakItems[idx].duration;
    final seconds = currentDuration.inSeconds - 1;

    if (seconds <= 0) {
      onTimeout(idx);
      return;
    }

    streakItems[idx].duration = Duration(seconds: seconds);

    notifyListeners();
  }

  void onTimeout(int idx) {
    streakItems[idx].streakCount = 0;

    streakItems[idx].duration = streakItems[idx].intervall;

    _timers[idx]?.cancel();
    startTimer(idx);
    notifyListeners();
  }

  //Calendar
  final Map<DateTime, StreakItem> streakDays = {};

  void updateListFromStreak(StreakItem si) {
    final idx = streakItems.indexOf(si);
    if (idx == -1) return;

    final currentDate = DateTime.now();
    for (int i = 0; i < streakItems[idx].streakCount; i++) {
      final streakDate = normalizeDate(currentDate.subtract(Duration(days: i)));

      //streakDays.addEntries([MapEntry(streakDate, si)]);
      streakDays[streakDate] = si;
      //debugPrint("${streakDays}");
      //notifyListeners();
    }
  }

  void updateStreakColors() {
    for (StreakItem si in streakItems) {
      streakColors[si] = RandomColor.getColorObject(
        Options(
          alpha: 0.3,
          luminosity: Luminosity.bright,
          colorType: ColorType.red,
        ),
      );
    }
  }
}
