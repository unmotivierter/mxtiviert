import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'main.dart';
import 'goals.dart';

enum TabItems { home, group, add, calendar, settings }

TabItems currentTab = TabItems.home;

List<StreakItem> streakItems = AddGoals().getStreakList();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentinx = 0;
  int selectinx = 0;

  void selectTab(int i) {
    setState(() {
      currentTab = TabItems.values[i];
      selectinx = i;
      if (currentTab == TabItems.add) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddGoals()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildAppBar(context)),
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

  return Container(
    child: Center(
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
    ),
    width: MediaQuery.of(context).size.width,

    //color: Theme.of(context).colorScheme.inversePrimary,
  );
}
