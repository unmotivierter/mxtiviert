import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'main.dart';

enum TabItems { home, group, calendar, settings }

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TabItems currentTab = TabItems.home;
  int currentinx = 0;
  int selectinx = 0;
  final List<StreakItem> streakItems = [StreakItem("Streak 1", 12, 30, true), StreakItem("Streak 2", 0, 4, false)];

  void selectTab(int i) {
    setState(() {
      currentTab = TabItems.values[i];
      selectinx = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildAppBar(context)),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: selectinx,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        onTap: selectTab,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (currentTab) {
      case TabItems.home:
        return StreakScroller(streakItems: streakItems);

      case TabItems.group:
        return Text("The group screen");

      case TabItems.calendar:
        return Text("Hi");

      case TabItems.settings:
        return Text("Settings");
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
    }

    return Text(title);
  }
}
