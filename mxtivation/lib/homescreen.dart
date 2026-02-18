import 'dart:async';

import 'package:flutter/material.dart';
import 'main.dart';
import 'navigation.dart';

typedef CompareFunction = int Function(dynamic a, dynamic b);

final int streakItemHeight = 150;

class StreakScroller extends StatefulWidget {
  const StreakScroller({super.key, required this.streakItems});

  final List<StreakItem> streakItems;

  @override
  State<StreakScroller> createState() => _StreakScrollerState();
}

class _StreakScrollerState extends State<StreakScroller> {
  bool tapped = false;

  List<Widget> createScrollerItemsFromList(List<StreakItem> streakItems) {
    streakItems.sort(curCompFunc);
    List<Widget> items = [];
    for (StreakItem si in streakItems) {
      items.add(StreakScrollerItem(paddingSize: 10, streakItem: si));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      itemExtent: streakItemHeight.toDouble(),
      scrollDirection: Axis.vertical,
      onTap: (int i) {
        //wip
      },
      children: createScrollerItemsFromList(widget.streakItems),
    );
  }
}

class StreakScrollerItem extends StatelessWidget {
  const StreakScrollerItem({
    super.key,
    required this.paddingSize,
    required this.streakItem,
  });
  final int paddingSize;
  final StreakItem streakItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width - paddingSize,
            height: streakItemHeight.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Row(
                    children: [
                      Text(
                        "${streakItem.streakCount}",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      Icon(
                        Icons.local_fire_department,
                        size: 50,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 125,
            top: 10,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.5,
              height: 40,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  streakItem.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 150,
            top: 50,
            child: const TimerWidget(
              dura: Duration(hours: 1, minutes: 5, seconds: 3),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 15,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    streakItem.goaler,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.dura});

  final dura;
  Duration getDura() {
    return dura;
  }

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  //_TimerWidgetState({required this.dur});
  //var duration = 0;
  late Duration dur = widget.dura;
  //static Duration dur = Duration(minutes: 1, seconds: 9);
  late ValueNotifier<Duration> durationNotifier = ValueNotifier<Duration>(dur);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => reduceTime());
  }

  void reduceTime() {
    //print("reduced Time by 1");
    setState(() {
      int seconds = durationNotifier.value.inSeconds - 1;
      if (seconds < 0) {
        timer?.cancel();
        onTimeout();
      } else {
        durationNotifier.value = Duration(seconds: seconds);
        dur = Duration(seconds: seconds);
      }
      //print(durationNotifier.value.inSeconds);
    });
  }

  void onTimeout() {
    print("Timeout");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Text("Time left: ", style: TextStyle(fontSize: 20)),
        buildTime(dur),
      ],
    );
  }

  Widget buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Time left: ", style: TextStyle(fontSize: 20)),
          Text("$hours", style: TextStyle(fontSize: 20)),
          Text(": $minutes", style: TextStyle(fontSize: 20)),
          Text(": $seconds", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
