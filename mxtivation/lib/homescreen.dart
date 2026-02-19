import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
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
              streakItemIdx: i,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingSize/2),
            child: Container(
              //width: MediaQuery.sizeOf(context).width - paddingSize,
              height: streakItemHeight.toDouble(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
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
          Positioned(
            left: 150,
            top: 75,
            child: Text(
              "Actions left: ${context.watch<Globals>().streakItems[idx].amountLeft}",
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
  const TimerWidget({
    super.key,
    required this.dura,
    required this.itemIndex,
    required this.callback,
  });

  final Duration dura;
  final int itemIndex;
  final VoidCallback callback;
  Duration getDura() {
    return dura;
  }

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  void initState() {
    super.initState();

    // Access provider correctly
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<Globals>().startTimer(widget.itemIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = context
        .watch<Globals>()
        .streakItems[widget.itemIndex]
        .duration;

    return Row(children: [buildTime(duration)]);
  }

  Widget buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        duration.inDays > 0
            ? Text(
                "Time left: $days:$hours:$minutes:$seconds",
                style: TextStyle(fontSize: 20),
              )
            : Text(
                "Time left: $hours:$minutes:$seconds",
                style: TextStyle(fontSize: 20),
              ),
      ],
    );
  }
}