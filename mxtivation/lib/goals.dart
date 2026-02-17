import 'package:flutter/material.dart';
import 'main.dart';

final List<StreakItem> streakItems = [
  StreakItem("Streak 1", 12, 30, true),
  StreakItem("Streak 2", 0, 4, false),
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
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hint: Text("Enter your Goal Name: ")),
            onChanged: _onChanged,
          ),
          Row(
            children: [
              Text("Is this a solo project?"),
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
      streakItems.add(new StreakItem(goalName, 0, 0, isSolo));
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
