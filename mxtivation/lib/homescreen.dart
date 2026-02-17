import 'package:flutter/material.dart';
import 'main.dart';

final int streakItemHeight = 150;

class StreakScroller extends StatelessWidget {
  const StreakScroller({super.key, required this.streakItems});

  final List<StreakItem> streakItems;

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      itemExtent: streakItemHeight.toDouble(),
      scrollDirection: Axis.vertical,
      children: [
        StreakScrollerItem(paddingSize: 10, streakItem: streakItems[0]),
        StreakScrollerItem(paddingSize: 10, streakItem: streakItems[1]),
      ],
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
                      Text("${streakItem.streakCount}", style: TextStyle(
                        fontSize: 50,
                        color: Colors.orange.shade800,
                      )),
                      Icon(Icons.local_fire_department, size: 50, color: Colors.deepOrange,),
                    ],
                  )
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                streakItem.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
