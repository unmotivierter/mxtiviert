import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'cameraWidget.dart';
import 'photoGallery.dart';
import 'package:mxtivation/main.dart';

class PhotoGalleryPreviewWidget extends StatelessWidget {
  const PhotoGalleryPreviewWidget({super.key, required this.height, required this.width, required this.streakItemIdx});
  final double height;
  final double width;
  final int streakItemIdx;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getLatestImagePath(context.read<Globals>().streakItems[streakItemIdx].title),
      builder: (context, snapshot) {
        final bool latestImageExists = snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty;
        final latestImagePath = snapshot.data;
        return InkWell(
          onTap: () async {
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) {
                //add check if no photos then do normal container
                return PhotoGallery(streakItem: context.read<Globals>().streakItems[streakItemIdx],);
              },
            ),
          );
          },
          child: Container(
            height: height,
            width: width,
            decoration: latestImageExists ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: FileImage(io.File(latestImagePath!)),
                fit: BoxFit.cover,
              )
            ): BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).colorScheme.outline,
            ),
            child: latestImageExists ? null : Icon(Icons.photo, size: 100),
          ),
        );
      }
    );
  }
  Future<String> getLatestImagePath(String streakName) async{
    final dirPath = await getApplicationDocumentsDirectory();
    final dir = io.Directory(path.join(dirPath.path, 'images'));
    final fotoPath = await streakToFileName(dir.path, streakName, false);
    if(await io.File(fotoPath).exists()){
      return fotoPath;
    }
    else {
      debugPrint("no file at: $fotoPath");
      return "";
    }
  }
}