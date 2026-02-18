import 'package:flutter/material.dart';
import '../main.dart';

class StreakDisplayWidget extends StatelessWidget {
  const StreakDisplayWidget({super.key, required this.streakItem, required this.height, required this.width});
  final StreakItem streakItem;
  final double height;
  final double width;

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(height: height/2-8, width: width-8,
                      child: streakWithFlameText(streakItem.streakCount, 0)
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(height: height/2-8, width: streakItem.solo? width-8 : width/2-8,
                      child: streakWithFlameText(streakItem.streakPbCount, 1)
                    ),
                  ),
                  if(!streakItem.solo) Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(height: height/2-8, width: width/2-8,
                      child: streakWithFlameText(streakItem.groupStreak, 2)
                    ),
                  ),
                ],
              )
            ],
          )
        ]
      ),
    );
  }
}


Widget streakWithFlameText(int streak, int type){
  return FittedBox(
    fit: BoxFit.contain,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$streak", style: TextStyle(
          fontSize: 50,
          color: Colors.orange.shade800,
        )),
        if(type == 0) Icon(Icons.local_fire_department, size: 50, color: Colors.deepOrange,),
        if(type == 1) Text("PB", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
        if(type == 2) Icon(Icons.group, size: 50, color: Colors.deepOrange,),
      ],
    ),
  );
}