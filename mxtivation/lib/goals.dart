import 'package:flutter/material.dart';
import 'main.dart';

final List<StreakItem> streakItems = [
  StreakItem("Streak 1", 12, 30, true, "Group 1"),
  StreakItem("Streak 2", 0, 4, false, "PePe"),
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
      body: Column(
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
                  });
                },
              ),
            ],
          ),
          ElevatedButton(onPressed: () => _onPressed(), child: Text("Done")),
        ],
      ),
    );
  }

  void _onPressed() {
    setState(() {
      streakItems.add(new StreakItem(goalName, 0, 0, isSolo, "Name"));
      print(streakItems.length);
    });

    Navigator.pop(context);
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
