import 'package:flutter/material.dart';
import 'package:mxtivation/main.dart';
import 'package:mxtivation/widgets/cameraWidget.dart';
import 'package:provider/provider.dart';
import 'widgets/streakWidget.dart';
import 'widgets/photoGalleryPreviewWidget.dart';

class StreakScreenSp extends StatelessWidget {
  const StreakScreenSp({super.key, required this.streakItemIdx});
  final int streakItemIdx;

  @override
  Widget build(BuildContext context) {
    final StreakItem streakItem = context.watch<Globals>().streakItems[streakItemIdx];
    final double wHeight = MediaQuery.of(context).size.height / 2.5;
    final double wWidth = MediaQuery.of(context).size.width / 2.5;

    /*if(!context.read<Globals>().getPhotosForItem.containsKey(streakItem)){
      context.read<Globals>().getPhotosForItem.addEntries([
        MapEntry(streakItem, StreakPhotos()),
      ]);
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          streakItem.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              StreakDisplayWidget(
                streakItem: streakItem,
                height: wHeight,
                width: wWidth,
              ),
              //Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CameraWidget(height: wHeight, width: wWidth, streakItemIdx: streakItemIdx,),
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
                child: PhotoGalleryPreviewWidget(
                  height: wHeight,
                  width: wWidth,
                  streakItemIdx: streakItemIdx,
                ),
              ),
              //Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: wHeight,
                  width: wWidth,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
