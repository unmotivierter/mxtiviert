import 'package:flutter/material.dart';
import 'main.dart';

final int streakItemHeight = 150;

class StreakScroller extends StatefulWidget {
  const StreakScroller({super.key, required this.streakItems});

  final List<StreakItem> streakItems;

  @override
  State<StreakScroller> createState() => _StreakScrollerState();
}

class _StreakScrollerState extends State<StreakScroller> {

  bool tapped = false;

  List<Widget> createScrollerItemsFromList(List<StreakItem> streakItems){
    streakItems.sort((a, b) => b.streakCount.compareTo(a.streakCount));
    List<Widget> items = [];
    for(StreakItem si in streakItems){
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
          Positioned(
            left: 125,
            top: 10,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width/1.5,
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
          Align(
            alignment: Alignment.center,
            child: Text("Time left: ...wip",
              style: TextStyle(
                fontSize: 20,
              ),
            )
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
                  child: Text(streakItem.goaler, style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
