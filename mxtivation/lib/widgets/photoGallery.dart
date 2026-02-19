// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mxtivation/main.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({super.key, required this.streakItem});
  final StreakItem streakItem;
  //741335372
  @override
  Widget build(BuildContext context) {

    if(context.read<Globals>().getPhotosForItem[streakItem.title] == null){
      List<File> streakPhotos = getStreakPhotos(context);
      Map<String, bool> verifiedPhotos = {for (final file in streakPhotos) file.path: false,};
      context.read<Globals>().getPhotosForItem.addEntries([
        MapEntry(streakItem.title, StreakPhotos()),
      ]);
      context.read<Globals>().getPhotosForItem[streakItem.title]!.photos = streakPhotos;
      context.read<Globals>().getPhotosForItem[streakItem.title]!.verifiedPhotos = verifiedPhotos;
    }
    final streakPhotos = context.read<Globals>().getPhotosForItem[streakItem.title]!.photos;
    final verifiedPhotos= context.read<Globals>().getPhotosForItem[streakItem.title]!.verifiedPhotos;

    return Scaffold(
      appBar: AppBar(
        title: Text("${streakItem.title} Photos"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          for(final photo in streakPhotos.reversed) PhotoItem(photo: photo, verified: verifiedPhotos[photo.path]!, streakItem: streakItem,),
        ],
      )
    );
  }


  List<File> getStreakPhotos(BuildContext context){
    final String streakName = streakItem.title.replaceAll(' ', '_');
    final imageDir = context.read<Globals>().imageDir;
    final List<File> matchingFiles = [];
    final regex = RegExp('^${RegExp.escape(streakName)}_(\\d+)\\.png\$');
    for(final entity in imageDir.listSync()){
      if(entity is File){
        final fileName = entity.uri.pathSegments.last;
        final match = regex.firstMatch(fileName);
        if(match != null){
          matchingFiles.add(entity);
        }
      }
    }
    matchingFiles.sort((a, b) {
      final aName = a.uri.pathSegments.last;
      final bName = b.uri.pathSegments.last;
      final aNumber = int.parse(regex.firstMatch(aName)!.group(1)!);
      final bNumber = int.parse(regex.firstMatch(bName)!.group(1)!);

      return aNumber.compareTo(bNumber);
    });
    return matchingFiles;
  }
}

// ignore: must_be_immutable
class PhotoItem extends StatefulWidget {
  PhotoItem({super.key, required this.photo, required this.verified, required this.streakItem});
  final File photo;
  final StreakItem streakItem;
  bool verified;

  @override
  State<PhotoItem> createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: FileImage(widget.photo),
            fit: BoxFit.cover
          )
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.verified = !widget.verified;
                });
                if(context.read<Globals>().getPhotosForItem[widget.streakItem.title] != null){
                 context.read<Globals>().getPhotosForItem[widget.streakItem.title]!.verifiedPhotos[widget.photo.path] = true;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.verified? Colors.green: Colors.red,
              ),
              child: widget.verified? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank)
            ),
          ),
        )
      ),
    );
  }
}