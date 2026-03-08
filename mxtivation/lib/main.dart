// ignore_for_file: use_build_context_synchronously

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
    
    context.read<Globals>().loadData();
    //context.read<Globals>().saveData();
    updateTime(context); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.flutterDash),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.flutterDash),
      //themeMode: ThemeMode.system,
      themeMode: ThemeMode.dark,
      home: App(),
    );
  }

  void updateTime(BuildContext context) async {
    final Map<String, int> timers = await context.read<Globals>().loadTime(); 
    final int globalTimeThen = await context.read<Globals>().loadGlobalTime();
    final int globalTimeNow = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int timeDiff = globalTimeNow - globalTimeThen;
    final items  = context.read<Globals>().streakItems;

    for(var entry in timers.entries){
      //logic might just be flawed if timer is 0
      //(defenetly didn't cause the app not to load)
      /*
      int overflows = 0;
      int remaining = (entry.value != 0)? entry.value : 1;     

      while((remaining - timeDiff) < 0){
        timeDiff -= remaining;
        overflows++;
      }
      remaining = entry.value - timeDiff;
      */
      int idx = getIdxFromStreakName(context, entry.key);
      if(idx == -1){continue;}
      int timerSeconds = entry.value;
      if(timerSeconds <= 0){
        timerSeconds = context.read<Globals>().streakItems[idx].intervall.inSeconds;
      }

      final int overflows = timeDiff ~/ timerSeconds;
      final int remaining = timerSeconds - (timeDiff % timerSeconds);

      for(int i = 0; i < items.length; i++){
        if(items[i].title == entry.key){
          context.read<Globals>().streakItems[i].duration = Duration(seconds: remaining);
          if(overflows > 0){
            context.read<Globals>().streakItems[i].streakCount = 0;
          }
        }
      }
    }
    context.read<Globals>().saveTime();
  }
  int getIdxFromStreakName(BuildContext context, String name){
    final items = context.read<Globals>().streakItems;
    for(int i = 0; i < items.length; i++){
      if(items[i].title == name){
        return i;
      }
    }
    return -1;
  }
}

class StreakItem {
  String title;
  int streakCount;
  int streakPbCount;
  int groupStreak;
  bool solo;
  String goaler; //name of person/group who have goal :)
  int goaler_id;
  Duration duration;
  Duration intervall;
  int amountPerIntervall;
  int amountLeft;
  List<DateTime> dates;

  StreakItem({
    required this.title,
    required this.streakCount,
    required this.streakPbCount,
    required this.groupStreak,
    required this.solo,
    required this.goaler,
    required this.goaler_id,
    this.duration = const Duration(days: 1),
    required this.intervall,
    required this.amountPerIntervall,
    required this.amountLeft,
    required this.dates,
  });
}

class Profile{
  String username;
  int id;
  Profile({required this.username, required this.id});
  //not finished at all
}

class Group{
  String groupname;
  int id;
  List<Profile> members = [];
  Group({required this.groupname, required this.id});
}

class StreakPhotos {
  List<File> photos = [];
  Map<String, bool> verifiedPhotos = {};
  StreakPhotos({required this.photos, required this.verifiedPhotos});
}

class Globals extends ChangeNotifier {
  int highestId = 0;
  Globals({required this.imageDir}){
    Profile(username: "Ich", id: nextId());
  }
  Directory imageDir = Directory('');

  final box = Hive.box('appData');

  Map<String, StreakPhotos> getPhotosForItem = {};

  TabItems currentTab = TabItems.home;

  int Function(StreakItem a, StreakItem b) compareFunc = sortStreakDescending;

  List<StreakItem> streakItems = [];
  List<Group> groups = [];

  void addStreakItem(StreakItem streakItem){
    streakItems.add(streakItem);
    saveData();
    notifyListeners();
  }

  void removeStreakItemAtIdx(int idx) async {
    final streakFileName = streakItems[idx].title.replaceAll(' ', '_');
    final files = imageDir.listSync();

    for(var file in files){
      final name = file.uri.pathSegments.last;
      final regex = RegExp(r'^'+ streakFileName + r'_(\d+)\.png$');
      final match = regex.firstMatch(name);
      if(match != null){
        await file.delete();
      }
    }

    streakItems.removeAt(idx);
    saveData();

    notifyListeners();
  }

  void updateStreak(int streakItemIdx, bool reset){
    streakItems[streakItemIdx].streakCount = reset? 0 : streakItems[streakItemIdx].streakCount+1;
    saveData();
    notifyListeners();
  }

  void addGroup(String name){
    groups.add(Group(groupname: name, id: nextId()));

    saveData();
    notifyListeners();
  }

  void selectTab(int i) {
    currentTab = TabItems.values[i];

    if (currentTab == TabItems.calendar) {
      updateListFromStreak(selectedStreak);
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

  //saving data to files:
  Future<void> saveData() async {
    final data = {
      'streakItems': streakItems.map((e) => {
        'title': e.title,
        'streakCount': e.streakCount,
        'streakPbCount': e.streakPbCount,
        'groupStreak': e.groupStreak,
        'solo': e.solo,
        'goaler': e.goaler,
        'goaler_id': e.goaler_id,
        'intervall': e.intervall.inSeconds,
        'amountPerIntervall': e.amountPerIntervall,
        'amountLeft': e.amountLeft,
        'dates': e.dates
          .map((dt) => dt.millisecondsSinceEpoch)
          .toList(),
      }).toList(),

      'photosMap': getPhotosForItem.map(
        (key, value) => MapEntry(key, {
          'photoPaths': value.photos.map((f) => f.path).toList(),
          'verifiedPhotos': value.verifiedPhotos,
        }),
      ),
    };

    await box.put('appData', data);
  }

  Future<void> saveTime() async{
    final streakTimers = {
      for (var item in streakItems)
        item.title: item.duration.inSeconds,
    };

    final dataToSave = {
      'streakTimers': streakTimers,
      'CurrentTime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    await box.put('timerData', dataToSave);
  }

  Future<Map<String, int>> loadTime() async{
    final data = box.get('timerData');
    if (data == null) return {}; 

    return Map<String, int>.from(data['streakTimers']);
  }
  
  Future<int> loadGlobalTime() async {
    final data = box.get('timerData');
    if (data == null) return 0;

    return data['CurrentTime'];
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
        goaler_id: e['goaler_id'],
        intervall: Duration(seconds: e['intervall']),
        dates: (e['dates'] as List).map((ms) => DateTime.fromMicrosecondsSinceEpoch(ms)).toList(),
        amountPerIntervall: e['amountPerIntervall'],
        amountLeft: e['amountLeft'],
      )).toList();

    // Rebuild getPhotosForItem map
    getPhotosForItem = Map<String, StreakPhotos>.from(
      (data['photosMap'] as Map).map(
        (key, value) => MapEntry(
          key,
          StreakPhotos(
            photos: (value['photoPaths'] as List).map((p) => File(p)).toList(),
            verifiedPhotos: Map<String, bool>.from(value['verifiedPhotos']),
          ),
        ),
      ),
    );
  }

  int nextId(){
    highestId++;
    return highestId-1;
  }


  ///////Timer logic here:

  final Map<int, Timer> _timers = {};

  Map<StreakItem, Color> streakColors = {};

  //maybe update from idx to a key like streak name
  void startTimer(int idx) {
    _timers[idx]?.cancel();

    _timers[idx] = Timer.periodic(Duration(seconds: 1), (_) => reduceTime(idx));

    notifyListeners();
  }

  void reduceTime(int idx) {
    if(idx >= streakItems.length) return;
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
      updateStreak(idx, true);
    }

    streakItems[idx].duration = streakItem.intervall;

    streakItems[idx].amountLeft = streakItem.amountPerIntervall;

    _timers[idx]?.cancel();
    startTimer(idx);
    updateListFromStreak(selectedStreak);
    notifyListeners();
  }

  //Calendar
  final Map<DateTime, Set<int>> streakDays = {};

  int selectedStreak = 0;
  List<DropdownMenuEntry> dropDownbuttons = [];

  void updateListFromStreak(int streakIdx) {
    final si = streakItems[streakIdx];
    final currentDate = DateTime.now();

    for (int i = 0; i < si.streakCount; i++) {
      final streakDate = normalizeDate(currentDate.subtract(Duration(days: i)));
      streakItems[streakIdx].dates.add(streakDate);

      addNewDate(streakIdx, streakDate);
    }

    for (int i = 0; i < streakItems[streakIdx].dates.length; i++) {
      addNewDate(streakIdx, streakItems[streakIdx].dates[i]);
    }
    saveData();
    notifyListeners();
  }

  void addNewDate(int streakIdx, DateTime date) {
    final normalizedDate = normalizeDate(date);

    streakDays.putIfAbsent(normalizedDate, () => <int>{});

    streakDays[normalizedDate]!.add(streakIdx);

    saveData();

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
