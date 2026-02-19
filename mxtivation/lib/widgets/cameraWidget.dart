//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mxtivation/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key, required this.height, required this.width, required this.streakItem});
  final double height;
  final double width;
  final StreakItem streakItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.outline,
        ),
        child: Icon(Icons.photo_camera, size: 100),
      ),
      onTap: () async {
        WidgetsFlutterBinding.ensureInitialized();
        _cameras = await availableCameras();
        debugPrint("$_cameras");
        //might need to be changed to _cameras[0] on real devices
        final firstCamera = _cameras[1];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(camera: firstCamera, streakItem: streakItem,),
          ),
        );
      },
    );
  }
}

late List<CameraDescription> _cameras;

/*Future<void> getCams() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
}*/

/// CameraScreen is the Main Application.
class CameraScreen extends StatefulWidget {
  /// Default Constructor
  const CameraScreen({super.key, required this.camera, required this.streakItem});

  final CameraDescription camera;
  final StreakItem streakItem;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    //controller is for current output of camera
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return CameraPreview(_controller);
              }
              else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.cancel),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try{
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if(!context.mounted) return;
            final String newPath = await saveImageToAppFolder(image.path, widget.streakItem.title); 

            if(context.read<Globals>().getPhotosForItem[widget.streakItem.title] == null){
              List<File> streakPhotos = getStreakPhotos(context);
              Map<String, bool> verifiedPhotos = {for (final file in streakPhotos) file.path: false,};
              context.read<Globals>().getPhotosForItem.addEntries([
                MapEntry(widget.streakItem.title, StreakPhotos()),
              ]);
              context.read<Globals>().getPhotosForItem[widget.streakItem.title]!.photos = streakPhotos;
              context.read<Globals>().getPhotosForItem[widget.streakItem.title]!.verifiedPhotos = verifiedPhotos;
            }
            context.read<Globals>().getPhotosForItem[widget.streakItem.title]!.photos.add(File(newPath));
            context.read<Globals>().getPhotosForItem[widget.streakItem.title]!.verifiedPhotos.addEntries([MapEntry(newPath, false)]);

            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DisplayPictureScreen(
                  imagePath: newPath,
                ),
              ),
            );
          } catch(e){
            debugPrint("$e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }



  List<File> getStreakPhotos(BuildContext context){
    final String streakName = widget.streakItem.title.replaceAll(' ', '_');
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;


  const DisplayPictureScreen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

Future<String> saveImageToAppFolder(String oldPath, String streakName) async {
  final directory = await getApplicationDocumentsDirectory();
  final tempDir = Directory(path.join(directory.path, 'images'));
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }
  final newPath = await streakToFileName(tempDir.path, streakName, true);

  final File imageFile = File(oldPath);
  final File newFile = await imageFile.copy(newPath);

  return newFile.path;
}

Future<String> streakToFileName(String dirPath, String streakName, bool increment) async {
  streakName = streakName.replaceAll(' ', '_');
  final directory = Directory(dirPath);
  final files = directory.listSync();

  int maxNum = 0;
  
  for(var file in files){
    final name = file.uri.pathSegments.last;
    final regex = RegExp(r'^'+ streakName + r'_(\d+)\.png$');
    final match = regex.firstMatch(name);
    if(match != null){
      final number = int.tryParse(match.group(1)!);
      if(number != null && number > maxNum){
        maxNum = number;
      }
    }
  }
  return increment ? '$dirPath/${streakName}_${maxNum+1}.png' : '$dirPath/${streakName}_$maxNum.png';
}