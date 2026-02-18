//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key, required this.height, required this.width, required this.streakName});
  final double height;
  final double width;
  final String streakName;

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
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(camera: firstCamera, streakName: streakName,),
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
  const CameraScreen({super.key, required this.camera, required this.streakName});

  final CameraDescription camera;
  final streakName;

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
            final String newPath = await saveImageToAppFolder(image.path, widget.streakName); 

            // ignore: use_build_context_synchronously
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
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;


  const DisplayPictureScreen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    debugPrint(imagePath);
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
  final newPath = await streakToFileName(tempDir.path, streakName);

  final File imageFile = File(oldPath);
  final File newFile = await imageFile.copy(newPath);

  return newFile.path;
}

Future<String> streakToFileName(String dirPath, String streakName) async {
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
  return '$dirPath/$streakName\_${maxNum+1}.png';
}