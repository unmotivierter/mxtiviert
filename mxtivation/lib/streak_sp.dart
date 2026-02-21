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
    if(streakItemIdx >= context.read<Globals>().streakItems.length){
      return Placeholder();
    }
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
        actions: [
          MenuAnchor(
            builder:(context, controller, child) {
              return IconButton(
                onPressed: () {
                  controller.isOpen? controller.close() : controller.open();
                }, 
                icon: Icon(Icons.more_horiz)
                );
              },
            menuChildren: [
              MenuItemButton(
                child: Text("Settings"),
              ),
              MenuItemButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Do you want to delete this streak?"),
                        content: Text("It is irreversible and might have terrible consequences!"),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(), 
                            child: Text("no")
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final globals = Provider.of<Globals>(context, listen: false);
                              Navigator.of(context)..pop()..pop();
                              //context.read<Globals>().removeStreakItemAtIdx(streakItemIdx);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                globals.removeStreakItemAtIdx(streakItemIdx);
                              });
                            },
                            child: Text("yes")
                          )
                        ],
                      );
                    }
                  );
                },
                child: Text("delete")
              )
            ],
          ),
        ],
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
