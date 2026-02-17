import 'package:flutter/material.dart';
import 'main.dart';

final int streakItemHeight = 150;


class StreakScroller extends StatelessWidget {
  const StreakScroller({super.key, required this.streakItems});

  final List<StreakItem> streakItems;

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      itemExtent: streakItemHeight.toDouble(),
      scrollDirection: Axis.vertical,
      children: [
        StreakScrollerItem(paddingSize: 10),
        StreakScrollerItem(paddingSize: 10),
      ],
    );
  }
}

class StreakScrollerItem extends StatelessWidget {
  const StreakScrollerItem({super.key, required this.paddingSize});
  final int paddingSize; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width - paddingSize,
        height: streakItemHeight.toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.onPrimary,
        )
      ),
    );
  }
}