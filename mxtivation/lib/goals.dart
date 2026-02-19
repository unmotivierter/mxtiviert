import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'main.dart';

class AddGoals extends StatefulWidget {
  const AddGoals({super.key});

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
  String intervalltxt = "Select Your Intervall";

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
                  onSelected: (valueNotifier) {
                    setState(() {
                      group = valueNotifier.toString();
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Text(intervalltxt, style: TextStyle(fontSize: 20)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    int dayController = 0;
                    int hourController = 0;
                    int minuteController = 0;
                    int amt = 1;

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
                                  autofocus: true,

                                  onChanged: (value) => setStateSheet(() {
                                    amt = int.parse(value);
                                  }),
                                ),
                              ),

                              Row(
                                children: [
                                  Text("Days:", style: TextStyle(fontSize: 15)),
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
                                child: Text(
                                  "Done",
                                  style: TextStyle(fontSize: 20),
                                ),

                                onPressed: () {
                                  setState(() {
                                    days = dayController;
                                    hours = hourController;
                                    minutes = minuteController;
                                    amount = amt;

                                    intervalltxt =
                                        "$amount actions every $days days, $hours hours and $minutes minutes";
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

            ElevatedButton(
              onPressed: () => _onPressed(),
              child: Text("Add Goal", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    Provider.of<Globals>(context, listen: false).addStreakItem(
      StreakItem(
        goalName,
        0,
        0,
        0,
        isSolo,
        group,
        Duration(hours: hours, days: days, minutes: minutes),
        Duration(hours: hours, days: days, minutes: minutes),
        amount,
        amount,
      ),
    );
    context.read<Globals>().fillStreakDropdownMenu();
    Navigator.pop(context);
  }

  void _onChanged(String txt) {
    setState(() {
      goalName = txt;
    });
  }
}
