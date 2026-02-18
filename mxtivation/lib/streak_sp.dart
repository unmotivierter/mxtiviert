import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'widgets/streakWidget.dart';

class StreakScreenSp extends StatelessWidget {
  const StreakScreenSp({super.key, required this.streakItem});
  final StreakItem streakItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(streakItem.title, style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),),
      ),
      body: Column(
        children: [
          Row(
            children: [
              StreakDisplayWidget(streakItem: streakItem, height: 150, width: 150),
              StreakDisplayWidget(streakItem: streakItem, height: 150, width: 150),
            ],
          ),
          Row(
            children: [
              StreakDisplayWidget(streakItem: streakItem, height: 150, width: 150),
              StreakDisplayWidget(streakItem: streakItem, height: 150, width: 150),
            ],
          ),
        ],
      )
    );
  }
}