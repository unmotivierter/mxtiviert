import 'package:flutter/material.dart';
import 'package:mxtivation/navigation.dart';
import 'package:numberpicker/numberpicker.dart';

import 'main.dart';

final List<StreakItem> streakItems = [
  StreakItem(
    "Streak 1",
    12,
    30,
    4,
    true,
    "Group 1",
    Duration(hours: 2),
    Duration(hours: 2),
    3,
  ),
  StreakItem(
    "Streak 2",
    1,
    14,
    0,
    false,
    "PePe",
    Duration(seconds: 10),
    Duration(seconds: 10),
    3,
  ),
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
  int amount = 0;

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
            ElevatedButton(
              child: Text(
                "Select your Intervall",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    int dayController = 1;
                    int hourController = 0;
                    int minuteController = 0;
                    int amt = 0;

                    return StatefulBuilder(
                      builder: (context, setStateSheet) => Scaffold(
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Enter Amount per Time: ",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  keyboardType: TextInputType.number,

                                  onChanged: (value) => setStateSheet(() {
                                    amt = int.parse(value);
                                  }),
                                ),
                              ),

                              Row(
                                children: [
                                  Text("Days:", style: TextStyle(fontSize: 20)),
                                  NumberPicker(
                                    itemWidth: 50,
                                    infiniteLoop: true,
                                    minValue: 0,
                                    maxValue: 30,
                                    value: dayController,
                                    onChanged: (int i) => setStateSheet(() {
                                      dayController = i;
                                    }),
                                  ),
                                  Text(
                                    "Hours:",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  NumberPicker(
                                    itemWidth: 50,
                                    infiniteLoop: true,
                                    minValue: 0,
                                    maxValue: 23,
                                    value: hourController,
                                    onChanged: (int i) => setStateSheet(() {
                                      hourController = i;
                                    }),
                                  ),
                                  Text(
                                    "Minutes:",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  NumberPicker(
                                    itemWidth: 50,
                                    infiniteLoop: true,
                                    minValue: 0,
                                    maxValue: 59,
                                    value: minuteController,
                                    onChanged: (int i) => setStateSheet(() {
                                      minuteController = i;
                                    }),
                                  ),
                                ],
                              ),

                              ElevatedButton(
                                child: Text("Done"),

                                onPressed: () {
                                  setState(() {
                                    days = dayController;
                                    hours = hourController;
                                    minutes = minuteController;
                                    amount = amt;
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
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
          Duration(days: days, hours: hours, minutes: minutes, seconds: 0),
          amount,
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
