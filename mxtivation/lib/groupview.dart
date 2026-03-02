import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'package:provider/provider.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key, required this.groupIdx});
  final int groupIdx;

  @override
  Widget build(BuildContext context) {
    final double wHeight = MediaQuery.of(context).size.height / 2.5;
    final double wWidth = MediaQuery.of(context).size.width / 2.5;
    if(groupIdx >= context.read<Globals>().groups.length){return Placeholder();}
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<Globals>().groups[groupIdx].groupname,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Container(
                height: wHeight,
                width: wWidth,
                color: Theme.of(context).colorScheme.secondaryContainer
              ),
              Container(
                height: wHeight,
                width: wWidth,
                color: Theme.of(context).colorScheme.secondaryContainer
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Container(
                height: wHeight,
                width: wWidth,
                color: Theme.of(context).colorScheme.secondaryContainer
              ),
              Container(
                height: wHeight,
                width: wWidth,
                color: Theme.of(context).colorScheme.secondaryContainer
              ),
            ],
          ),
        ],
      ),

    );
  }
}
