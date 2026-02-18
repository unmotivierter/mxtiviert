import 'package:mxtivation/main.dart';

int sortStreakDescending(StreakItem a, StreakItem b) => b.streakCount.compareTo(a.streakCount);
int sortStreakAscending(StreakItem a, StreakItem b) => a.streakCount.compareTo(b.streakCount);
int sortStreakPbDescending(StreakItem a, StreakItem b) => b.streakPbCount.compareTo(a.streakPbCount);
int sortStreakPbAscending(StreakItem a, StreakItem b) => a.streakPbCount.compareTo(b.streakPbCount);
int sortNameAscending(StreakItem a, StreakItem b) => a.title.compareTo(b.title);
int sortNameDescending(StreakItem a, StreakItem b) => b.title.compareTo(a.title);