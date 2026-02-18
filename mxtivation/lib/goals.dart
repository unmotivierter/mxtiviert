import 'package:flutter/material.dart';
import 'package:mxtivation/navigation.dart';
import 'package:numberpicker/numberpicker.dart';

import 'main.dart';

final List<StreakItem> streakItems = [
  StreakItem("Streak 1", 12, 30, 4, true, "Group 1", Duration(hours: 2)),
  StreakItem("Streak 2", 1, 14, 0, false, "PePe", Duration(seconds: 10)),
];

class AddGoals extends StatefulWidget {
  const AddGoals({super.key});

  List<StreakItem> getStreakList() {
    return streakItems;
  }

  @override
  State<AddGoals> createState() => _AddGoalsState();
}

class _AddGoalsState extends State<AddGoals> {
  String goalName = "empty string";
  String group = "Personal";
  Duration duration = Duration();
  int days = 0;
  int hours = 0;
  int minutes = 0;

  bool isSolo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      appBar: AppBar(
        title: Text(
          "Create a new Goal",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hint: Text(
                  "Enter your Goal Name: ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onChanged: _onChanged,
            ),
            Row(
              children: [
                Text("Is this a solo project?", style: TextStyle(fontSize: 20)),
                Checkbox(
                  value: isSolo,
                  onChanged: (bool? value) {
                    setState(() {
                      isSolo = value!;
                      group = "Personal";
                    });
                  },
                ),
              ],
            ),

            Row(
              children: [
                Text("Select your group", style: TextStyle(fontSize: 20)),
                DropdownMenu(
                  enabled: !isSolo,
                  enableSearch: false,
                  label: Text("Personal"),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Personal", label: "Personal"),
                    DropdownMenuEntry(value: "gr2", label: "Group1"),
                    DropdownMenuEntry(value: "gr3", label: "Group2"),
                  ],
                  onSelected: (ValueNotifier) {
                    setState(() {
                      group = ValueNotifier.toString();
                    });
                  },
                ),
              ],
            ),
            Text("Select your Intervall", style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Text("Days:", style: TextStyle(fontSize: 20)),
                NumberPicker(
                  itemWidth: 50,
                  infiniteLoop: true,
                  minValue: 0,
                  maxValue: 30,
                  value: days,
                  onChanged: (int i) => setState(() {
                    days = i;
                  }),
                ),
                Text("Hours:", style: TextStyle(fontSize: 20)),
                NumberPicker(
                  itemWidth: 50,
                  infiniteLoop: true,
                  minValue: 0,
                  maxValue: 23,
                  value: hours,
                  onChanged: (int i) => setState(() {
                    hours = i;
                  }),
                ),
                Text("Minutes:", style: TextStyle(fontSize: 20)),
                NumberPicker(
                  itemWidth: 50,
                  infiniteLoop: true,
                  minValue: 0,
                  maxValue: 59,
                  value: minutes,
                  onChanged: (int i) => setState(() {
                    minutes = i;
                  }),
                ),
              ],
            ),
            ElevatedButton(onPressed: () => _onPressed(), child: Text("Done")),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    setState(() {
      streakItems.add(
        new StreakItem(
          goalName,
          0,
          0,
          0,
          isSolo,
          group,
          Duration(days: days, hours: hours, minutes: minutes, seconds: 0),
        ),
      );
      Navigator.pop(context);

      print(streakItems.length);
    });

    //Navigator.pop(context);
  }

  void _onChanged(String txt) {
    setState(() {
      goalName = txt;
    });
  }

  List<StreakItem> getStreakList() {
    return streakItems;
  }
}
