import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendarscreen extends StatefulWidget {
  const Calendarscreen({super.key});

  @override
  State<Calendarscreen> createState() => _CalendarscreenState();
}

class _CalendarscreenState extends State<Calendarscreen> {
  DateTime _focusedDay = DateTime.now();
  //DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int selectedStreak = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    context.read<Globals>().updateListFromStreak(
      context.read<Globals>().streakItems[selectedStreak],
    );
    context.read<Globals>().updateStreakColors();
  }

  bool isStreakDayByCurrentStreak(DateTime _day) {
    final currentDate = DateTime.now();
    for (
      int i = 0;
      i < context.read<Globals>().streakItems[0].streakCount;
      i++
    ) {
      final streakDate = currentDate.subtract(Duration(days: i));

      if (isSameDay(streakDate, _day)) {
        return true;
      }
    }
    return false;
  }

  bool isStreakDayByList(DateTime day) {
    //debugPrint("${context.read<Globals>().streakDays[day]}");
    //context.read<Globals>().UpdateList(context.read<Globals>().streakItems[0]);
    //Globals().UpdateList(context.read<Globals>().streakItems[0]);
    if (context.read<Globals>().streakDays[normalizeDate(day)] != null) {
      return true;
    }
    return false;
  }

  List<DropdownMenuEntry> fillStreakDropdownMenu() {
    List<DropdownMenuEntry> buttons = [];
    for (int i = 0; i < context.read<Globals>().streakItems.length; i++) {
      buttons.add(
        DropdownMenuEntry(
          value: i,
          label: context.read<Globals>().streakItems[i].title,
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(DateTime.now().year - 1),
          lastDay: DateTime(DateTime.now().year + 1),
          /*selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) => {
            setState(() {
              //debugPrint("$selectedDay, $focusedDay");
              _focusedDay = focusedDay;
              _selectedDay = selectedDay;
            }),
          },*/
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) => setState(() {
            _focusedDay = focusedDay;
          }),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, _focusedDay) {
              if (isStreakDayByList(day)) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        context.read<Globals>().streakColors[context
                            .read<Globals>()
                            .streakItems[selectedStreak]],
                    shape: BoxShape.circle,
                  ),
                );
              }
              return null;
            },
            todayBuilder: (context, day, _focusedDay) {
              if (isStreakDayByList(day)) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        context.read<Globals>().streakColors[context
                            .read<Globals>()
                            .streakItems[selectedStreak]],
                    shape: BoxShape.circle,
                  ),
                );
              }
              return null;
            },
          ),
        ),

        DropdownMenu(
          dropdownMenuEntries: fillStreakDropdownMenu(),
          onSelected: (value) => setState(() {
            selectedStreak = value;
            context.read<Globals>().updateListFromStreak(
              context.read<Globals>().streakItems[selectedStreak],
            );
          }),
        ),
      ],
    );
  }
}
