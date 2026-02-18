import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'package:mxtivation/widgets/cameraWidget.dart';
import 'widgets/streakWidget.dart';

class StreakScreenSp extends StatelessWidget {
  const StreakScreenSp({super.key, required this.streakItem});
  final StreakItem streakItem;

  @override
  Widget build(BuildContext context) {
    final double wHeight = MediaQuery.of(context).size.height/2.5;
    final double wWidth = MediaQuery.of(context).size.width/2.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(streakItem.title, style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              StreakDisplayWidget(streakItem: streakItem, height: wHeight, width: wWidth),
              //Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CameraWidget(height: wHeight, width: wWidth,),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              //Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: wHeight, width: wWidth, color: Theme.of(context).colorScheme.secondaryContainer,),
              ),
              //Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: wHeight, width: wWidth, color: Theme.of(context).colorScheme.tertiaryContainer),
              ),
            ],
          ),
        ],
      )
    );
  }
}