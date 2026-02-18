import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'navigation.dart';
import 'streak_sp.dart';

class StreakScroller extends StatefulWidget {
  const StreakScroller({super.key, required this.streakItems});

  final List<StreakItem> streakItems;
  final int streakItemHeight =
      150; //if you change this update the same on down below in StreakScrollerItem as well thank you

  @override
  State<StreakScroller> createState() => _StreakScrollerState();
}

class _StreakScrollerState extends State<StreakScroller> {
  bool tapped = false;
  VoidCallback myCallback = () {};
  bool temp = false;

  List<Widget> createScrollerItemsFromList(List<StreakItem> streakItems) {
    streakItems.sort(Provider.of<Globals>(context, listen: true).compareFunc);
    List<Widget> items = [];
    for (final (int idx, StreakItem si) in streakItems.indexed) {
      items.add(
        StreakScrollerItem(
          key: ValueKey(si),
          paddingSize: 10,
          streakItem: si,
          idx: idx,
          callback: myCallback,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    myCallback = () {
      setState(() {
        temp = true;
      });
    };
    return CarouselView(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      itemExtent: widget.streakItemHeight.toDouble(),
      scrollDirection: Axis.vertical,
      onTap: (int i) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StreakScreenSp(
              streakItem: context.watch<Globals>().streakItems[i],
            ),
          ),
        );
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
    required this.idx,
    required this.callback,
  });
  final int paddingSize;
  final StreakItem streakItem;
  final int idx;
  final VoidCallback callback;
  final int streakItemHeight = 150;

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
            child: TimerWidget(
              dura: context.watch<Globals>().streakItems[idx].duration,
              itemIndex: idx,
              callback: callback,
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
  TimerWidget({
    super.key,
    required this.dura,
    required this.itemIndex,
    required this.callback,
  });

  final dura;
  final int itemIndex;
  final VoidCallback callback;
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

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => reduceTime());
  }

  void reduceTime() {
    //print("reduced Time by 1");
    setState(() {
      int seconds = durationNotifier.value.inSeconds - 1;
      if (seconds < 0) {
        onTimeout();
        //timer?.cancel();
      } else {
        durationNotifier.value = Duration(seconds: seconds);
        dur = Duration(seconds: seconds);
        context.read<Globals>().streakItems[widget.itemIndex].duration = dur;
      }
      //print(durationNotifier.value.inSeconds);
    });
  }

  void onTimeout() {
    context.read<Globals>().streakItems[widget.itemIndex].streakCount = 0;
    widget.callback();
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
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (duration.inDays > 0)
              ? Text(
                  "Time left: $days:$hours:$minutes:$seconds",
                  style: TextStyle(fontSize: 20),
                )
              : Text(
                  "Time left: $hours:$minutes:$seconds",
                  style: TextStyle(fontSize: 20),
                ),
        ],
      ),
    );
  }
}
