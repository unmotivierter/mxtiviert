import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'groupview.dart';

class GroupScroller extends StatefulWidget {
  const GroupScroller({super.key});

  final int groupItemHeight =
      150; //if you change this update the same on down below in GroupScrollerItem as well thank you

  @override
  State<GroupScroller> createState() => _GroupScrollerState();
}

class _GroupScrollerState extends State<GroupScroller> {
  List<Widget> createScrollerItemsFromList(List<Group> groups) {
    List<Widget> items = [];
    for (Group g in groups) {
      items.add(
        GroupScrollerItem(
          key: ValueKey(g),
          paddingSize: 10,
          group: g,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<Group> groups = context.watch<Globals>().groups;
    return Stack(
      children: [
        CarouselView(
          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
          itemExtent: widget.groupItemHeight.toDouble(),
          scrollDirection: Axis.vertical,
          onTap: (int i) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupView(
                  groupIdx: i,
                ),
              ),
            );
          },
          children: createScrollerItemsFromList(groups),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              // AddGroup Screen
              onPressed: () => {},
              child: Icon(Icons.add)
            ),
          ),
        )
      ],
    );
  }
}

class GroupScrollerItem extends StatelessWidget {
  const GroupScrollerItem({
    super.key,
    required this.paddingSize,
    required this.group,
  });
  final int paddingSize;
  final Group group;
  final int groupItemHeight = 150;

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
              height: groupItemHeight.toDouble(),
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
                  group.groupname,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 25,
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