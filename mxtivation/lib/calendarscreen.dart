import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mxtivation/widgets/photoGalleryPreviewWidget.dart';

class Calendarscreen extends StatefulWidget {
  const Calendarscreen({super.key});

  @override
  State<Calendarscreen> createState() => _CalendarscreenState();
}

class _CalendarscreenState extends State<Calendarscreen> {
  DateTime _focusedDay = DateTime.now();
  //DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  //int selectedStreak = 0;

  //List<DropdownMenuEntry> dropDownbuttons = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    /*
    context.read<Globals>().updateListFromStreak(
      context.read<Globals>().streakItems[context
          .read<Globals>()
          .selectedStreak],
    );
    */
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

  bool isStreakDayByList(DateTime day, int sId) {
    //debugPrint("${context.read<Globals>().streakDays[day]}");
    //context.read<Globals>().UpdateList(context.read<Globals>().streakItems[0]);
    //Globals().UpdateList(context.read<Globals>().streakItems[0]);
    /*
    context.read<Globals>().updateListFromStreak(
      context.watch<Globals>().streakItems[context
          .read<Globals>()
          .selectedStreak],
    );*/
    if (context.read<Globals>().streakDays[day] != null &&
        context.read<Globals>().streakDays[day] ==
            context.read<Globals>().streakItems[sId]) {
      return true;
    }
    return false;
  }

  /*
  List<DropdownMenuEntry> fillStreakDropdownMenu() {
    for (int i = 0; i < context.read<Globals>().streakItems.length; i++) {
      context.read<Globals>().dropDownbuttons.add(
        DropdownMenuEntry(
          value: i,
          label: context.read<Globals>().streakItems[i].title,
        ),
      );
    }

    return context.read<Globals>().dropDownbuttons;
  }

  */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.3,
            width: MediaQuery.of(context).size.height,

            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: TableCalendar(
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
                    if (isStreakDayByList(
                      day,
                      context.read<Globals>().selectedStreak,
                    )) {
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              context.read<Globals>().streakColors[context
                                  .read<Globals>()
                                  .streakItems[context
                                  .read<Globals>()
                                  .selectedStreak]],
                          shape: BoxShape.circle,
                        ),
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        child: Text("${day.day}"),
                      );
                    }
                    return null;
                  },
                  todayBuilder: (context, day, _focusedDay) {
                    if (isStreakDayByList(
                      day,
                      context.read<Globals>().selectedStreak,
                    )) {
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              context.read<Globals>().streakColors[context
                                  .read<Globals>()
                                  .streakItems[context
                                  .read<Globals>()
                                  .selectedStreak]],
                          shape: BoxShape.circle,
                        ),
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        child: Text("${day.day}"),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      child: Text("${day.day}"),
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Align(
              alignment: Alignment.bottomLeft,
              child: PhotoGalleryPreviewWidget(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2.5,
                streakItemIdx: context.read<Globals>().selectedStreak,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
