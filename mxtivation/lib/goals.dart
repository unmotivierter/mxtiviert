import 'package:flutter/material.dart';
import 'package:mxtivation/navigation.dart';
import 'package:provider/provider.dart';
import 'main.dart';


class AddGoals extends StatefulWidget {
  const AddGoals({super.key});

  @override
  State<AddGoals> createState() => _AddGoalsState();
}

class _AddGoalsState extends State<AddGoals> {
  String goalName = "empty string";
  String group = "Personal";

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
            ElevatedButton(onPressed: () => _onPressed(), child: Text("Done")),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    Provider.of<Globals>(context, listen: false).addStreakItem(
      StreakItem(goalName, 0, 0, 0, isSolo, group, Duration(hours: 1, minutes: 5, seconds: 1))
    );
    Navigator.pop(context);
  }

  void _onChanged(String txt) {
    setState(() {
      goalName = txt;
    });
  }
}
