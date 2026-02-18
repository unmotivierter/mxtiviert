import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homescreen.dart';
import 'main.dart';
import 'goals.dart';

typedef CompareFunction = int Function(dynamic a, dynamic b);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

Sortby selected = Sortby.sDesc;

class _AppState extends State<App> {
  int selectidx = 0;

  //add sort by time left

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: _buildAppBar(context),
        title: Text(getAppBarText(context.watch<Globals>().currentTab), style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer)),
        actions: [ if(context.watch<Globals>().currentTab == TabItems.home) Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: DropdownButton(
              value: selected,
              items: [
                DropdownMenuItem(value: Sortby.sDesc, child: Text("Streak ↓")),
                DropdownMenuItem(value: Sortby.sAsc, child: Text("Streak ↑")),
                DropdownMenuItem(value: Sortby.sPbDesc, child: Text("Streak PB ↓")),
                DropdownMenuItem(value: Sortby.sPbAsc, child: Text("Streak PB ↑")),
                DropdownMenuItem(value: Sortby.nDesc, child: Text("Name ↓")),
                DropdownMenuItem(value: Sortby.nAsc, child: Text("Name ↑")),
              ],
              onChanged: (sort) {
                setState(() {
                  selected = sort!;
                  context.read<Globals>().setCompFunc(sort);
                });
              },
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ), 
          ),],
        ),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ],
        currentIndex: selectidx,
        selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.primary,

        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: (int i) {
          context.read<Globals>().selectTab(i);
          selectidx = i;
          if(context.read<Globals>().currentTab == TabItems.add){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddGoals()),
            ).then((_) {
              // ignore: use_build_context_synchronously
              context.read<Globals>().selectTab(0);
            });
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget selectedWidget;
    switch (context.watch<Globals>().currentTab) {
      case TabItems.home:
        selectedWidget = StreakScroller(streakItems: context.read<Globals>().streakItems);

      case TabItems.group:
        selectedWidget = Text("The group screen");

      case TabItems.calendar:
        selectedWidget = Text("Hi");

      case TabItems.settings:
        selectedWidget = Text("Settings");
      case TabItems.add:
        selectedWidget = StreakScroller(streakItems: context.read<Globals>().streakItems);
    }

    return Container(
      //color: Theme.of(context).colorScheme.surfaceDim,
      color: Theme.of(context).colorScheme.outlineVariant,
      child: selectedWidget,
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  String title = "";
  switch (context.watch<Globals>().currentTab) {
    case TabItems.home: title = "Home"; break;
    case TabItems.group: title = "Groups"; break;
    case TabItems.calendar: title = "Calendar"; break;
    case TabItems.settings: title = "Settings"; break;
    case TabItems.add: title = "Add Goal"; break;
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
    ),
  );
}

String getAppBarText(TabItems currentTab){
  switch (currentTab) {
    case TabItems.home: return "Home";
    case TabItems.group: return "Groups";
    case TabItems.calendar: return "Calendar";
    case TabItems.settings: return "Settings";
    case TabItems.add: return "Add Goal";
  }
}