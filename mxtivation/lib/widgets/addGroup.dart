import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mxtivation/main.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  String groupName = ""; 
  bool ready = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Container(
          height: MediaQuery.of(context).size.height/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child:  
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  hint: Text(
                    "Enter your Group name: ",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onChanged: _onChanged,
              ),
            ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(ready ? Colors.blue : Colors.grey),
            ),
            onPressed: ready ? () {
              context.read<Globals>().addGroup(groupName);
              Navigator.pop(context);
            } : null,
            child: Text("done")
          )
        )
      ],
    );
  }
  void _onChanged(String txt) {
    setState(() {
      groupName = txt;
      if(groupName.isNotEmpty){
        ready = true;
      }
    });
  }
}