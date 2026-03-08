import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mxtivation/main.dart';
import 'package:provider/provider.dart';
import 'package:mxtivation/homescreen.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key, required this.groupIdx});
  final int groupIdx;

  @override
  Widget build(BuildContext context) {
    final double wHeight = MediaQuery.of(context).size.height/3.5;
    if(groupIdx >= context.read<Globals>().groups.length){return Placeholder();}
    String groupname = context.read<Globals>().groups[groupIdx].groupname;
    int id = context.read<Globals>().groups[groupIdx].id;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupname,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        actions: [
          MenuAnchor(
            builder:(context, controller, child) {
              return IconButton(
                onPressed: () {
                  controller.isOpen? controller.close() : controller.open();
                }, 
                icon: Icon(Icons.more_horiz)
                );
              },
            menuChildren: [
              MenuItemButton(
                child: Text("Settings"),
              ),
              MenuItemButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Do you want to leave this group?"),
                        content: Text("It is irreversible and might have terrible consequences!"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(), 
                            child: Text("no")
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //remove group item
                              Navigator.of(context)..pop()..pop();
                            },
                            child: Text("yes")
                          )
                        ],
                      );
                    }
                  );
                },
                child: Text("delete")
              )
            ],
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(groupname,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              final streakItems = context.read<Globals>().streakItems;
              List<StreakItem> groupStreakItems = [];
              for(final streakItem in streakItems){
                if(streakItem.goalerId == id){
                  groupStreakItems.add(streakItem);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text("$groupname's streaks"),
                  ),
                  body: Container(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      child: StreakScroller(streakItems: groupStreakItems)
                    ),
                  )
                ),
              );
            },
            child: Container(
              height: wHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Theme.of(context).colorScheme.primaryContainer
              ),
            ),
          ),
          Container(height: wHeight,),
        ],
      ),

    );
  }
}
