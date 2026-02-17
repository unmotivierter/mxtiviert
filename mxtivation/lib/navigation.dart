import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'main.dart';
import 'goals.dart';

typedef CompareFunction = int Function(dynamic a, dynamic b);

enum TabItems { home, group, add, calendar, settings }
enum Sortby { sDesc, sAsc, sPbDesc, sPbAsc, nDesc, nAsc}

TabItems currentTab = TabItems.home;

List<StreakItem> streakItems = AddGoals().getStreakList();

CompareFunction curCompFunc = (a, b) => 0;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

Sortby selected = Sortby.sDesc;

class _AppState extends State<App> {
  int currentinx = 0;
  int selectinx = 0;

  void selectTab(int i) {
    setState(() {
      currentTab = TabItems.values[i];
      selectinx = i;
      if (currentTab == TabItems.add) {
        selectinx = 0;
        currentinx = 0;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddGoals()),
        ).then((_) {
          selectTab(0);
        });
      }
    });
  }

  int sortStreakDescending(dynamic a, dynamic b) => b.streakCount.compareTo(a.streakCount);
  int sortStreakAscending(dynamic a, dynamic b) => a.streakCount.compareTo(b.streakCount);
  int sortStreakPbDescending(dynamic a, dynamic b) => b.streakPbCount.compareTo(a.streakPbCount);
  int sortStreakPbAscending(dynamic a, dynamic b) => a.streakPbCount.compareTo(b.streakPbCount);
  int sortNameAscending(dynamic a, dynamic b) => a.title.compareTo(b.title);
  int sortNameDescending(dynamic a, dynamic b) => b.title.compareTo(a.title);
  //add sort by time left

  void setCompFunc(Sortby sort){
    setState(() {
      switch(sort){
        case Sortby.sDesc: curCompFunc = sortStreakDescending; break;
        case Sortby.sAsc: curCompFunc = sortStreakAscending; break;
        case Sortby.sPbDesc: curCompFunc = sortStreakPbDescending; break;
        case Sortby.sPbAsc: curCompFunc = sortStreakPbAscending; break;
        case Sortby.nDesc: curCompFunc = sortNameDescending; break;
        case Sortby.nAsc: curCompFunc = sortNameAscending; break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBar(context),
        actions: [Align(
          alignment: Alignment.centerRight,
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
                setCompFunc(sort);
              });
            },
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
        currentIndex: selectinx,
        selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.primary,

        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: selectTab,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget selectedWidget;
    switch (currentTab) {
      case TabItems.home:
        selectedWidget = StreakScroller(streakItems: streakItems);

      case TabItems.group:
        selectedWidget = Text("The group screen");

      case TabItems.calendar:
        selectedWidget = Text("Hi");

      case TabItems.settings:
        selectedWidget = Text("Settings");
      case TabItems.add:
        selectedWidget = StreakScroller(streakItems: streakItems);
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
  switch (currentTab) {
    case TabItems.home:
      title = "Home";
      break;
    case TabItems.group:
      title = "Groups";
      break;
    case TabItems.calendar:
      title = "Calendar";
      break;
    case TabItems.settings:
      title = "Settings";
      break;
    case TabItems.add:
      title = "Add Goal";
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Center(
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
    ),
    //color: Theme.of(context).colorScheme.inversePrimary,
  );
}
