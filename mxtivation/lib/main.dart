import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  await Hive.initFlutter();
  await Hive.openBox('appData');

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return Globals(imageDir: imageDir);
      },
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
  int amountLeft;

  StreakItem({
    required this.title,
    required this.streakCount,
    required this.streakPbCount,
    required this.groupStreak,
    required this.solo,
    required this.goaler,
    required this.duration,
    required this.intervall,
    required this.amountPerIntervall,
    required this.amountLeft,}
  );
}

class StreakPhotos {
  List<File> photos = [];
  Map<String, bool> verifiedPhotos = {};
  StreakPhotos({required this.photos, required this.verifiedPhotos});
}

class Globals extends ChangeNotifier {
  Globals({required this.imageDir});
  Directory imageDir = Directory('');

  final box = Hive.box('appData');

  Map<String, StreakPhotos> getPhotosForItem = {};

  TabItems currentTab = TabItems.home;

  int Function(StreakItem a, StreakItem b) compareFunc = sortStreakDescending;

  List<StreakItem> streakItems = [
    StreakItem(
      title: "Streak 1",
      streakCount: 12,
      streakPbCount: 30,
      groupStreak: 4,
      solo: false,
      goaler: "Group 1",
      duration: Duration(hours: 2),
      intervall: Duration(hours: 2),
      amountPerIntervall: 1,
      amountLeft: 1,
    ),
    StreakItem(
      title: "Streak 2",
      streakCount:1,
      streakPbCount: 14,
      groupStreak: 0,
      solo: true,
      goaler: "PePe",
      duration: Duration(seconds: 10),
      intervall: Duration(seconds: 10),
      amountPerIntervall: 2,
      amountLeft: 2,
    ),
  ];

  void selectTab(int i) {
    currentTab = TabItems.values[i];

    if (currentTab == TabItems.calendar) {
      updateListFromStreak(streakItems[selectedStreak]);
      debugPrint("$selectedStreak");
    }
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
  
  //saving data to files:
  Future<void> saveData() async{
    final data = {
      'streakItems': streakItems.map((e) => {
        'title': e.title,
        'streakCount': e.streakCount,
        'streakPbCount': e.streakPbCount,
        'groupStreak': e.groupStreak,
        'solo': e.solo,
        'goaler': e.goaler,
        'duration': e.duration.inSeconds,
        'intervall': e.intervall.inSeconds,
        'amountPerIntervall': e.amountPerIntervall,
        'amountLeft': e.amountLeft,
      }).toList(),

      'photosMap': getPhotosForItem.map((key, value) => MapEntry(
        key, 
        {
          'photoPaths': value.photos.map((f)=>f.path).toList(),
          'verifiedPhotos': value.verifiedPhotos,
        },
      )),
    };
    
    await box.put('appData', data);
  }

  //for testing porpuses
  /*dynamic getData(){
    return box.get('appData');
  }*/


  Future<void> loadData() async {
  final data = box.get('appData');
  if (data == null) return; // nothing saved yet

  // Rebuild streakItems list
  streakItems = (data['streakItems'] as List).map((e) => StreakItem(
        title: e['title'],
        streakCount: e['streakCount'],
        streakPbCount: e['streakPbCount'],
        groupStreak: e['groupStreak'],
        solo: e['solo'],
        goaler: e['goaler'],
        duration: Duration(seconds: e['duration']),
        intervall: Duration(seconds: e['intervall']),
        amountPerIntervall: e['amountPerIntervall'],
        amountLeft: e['amountLeft'],
      )).toList();

  // Rebuild getPhotosForItem map
  getPhotosForItem = Map<String, StreakPhotos>.from(
    (data['photosMap'] as Map).map((key, value) => MapEntry(
          key,
          StreakPhotos(
            photos: (value['photoPaths'] as List)
                .map((p) => File(p))
                .toList(),
            verifiedPhotos:
                Map<String, bool>.from(value['verifiedPhotos']),
          ),
        )),
  );
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
    final streakItem = streakItems[idx];
    if (streakItem.amountLeft > 0) {
      streakItems[idx].streakCount = 0;
    }

    streakItems[idx].duration = streakItem.intervall;

    streakItems[idx].amountLeft = streakItem.amountPerIntervall;

    _timers[idx]?.cancel();
    startTimer(idx);
    updateListFromStreak(streakItems[selectedStreak]);
    notifyListeners();
  }

  //Calendar
  final Map<DateTime, StreakItem> streakDays = {};
  int selectedStreak = 0;
  List<DropdownMenuEntry> dropDownbuttons = [];

  void updateListFromStreak(StreakItem si) {
    streakDays.clear();
    final idx = streakItems.indexOf(si);
    if (idx == -1) return;

    final currentDate = DateTime.now();
    for (int i = 0; i < streakItems[idx].streakCount; i++) {
      final streakDate = normalizeDate(currentDate.subtract(Duration(days: i)));

      //streakDays.addEntries([MapEntry(streakDate, si)]);
      streakDays[streakDate] = si;
      //debugPrint("${streakDays}");
    }
    notifyListeners();
  }

  void updateStreakColors() {
    for (StreakItem si in streakItems) {
      if (streakColors[si] != null) return;
      streakColors[si] = RandomColor.getColorObject(
        Options(luminosity: Luminosity.dark, colorType: ColorType.random),
      );
    }
  }

  List<DropdownMenuEntry> fillStreakDropdownMenu() {
    dropDownbuttons.clear();
    for (int i = 0; i < streakItems.length; i++) {
      dropDownbuttons.add(
        DropdownMenuEntry(value: i, label: streakItems[i].title),
      );
    }

    return dropDownbuttons;
  }
}
