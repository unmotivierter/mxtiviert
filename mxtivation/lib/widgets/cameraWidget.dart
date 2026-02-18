import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key, required this.height, required this.width});
  final double height;
  final double width;

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
        child: Icon(Icons.photo_camera, size: 100,),
      ),
      onTap: () async {
        WidgetsFlutterBinding.ensureInitialized();
        _cameras = await availableCameras(); 
        debugPrint("$_cameras");
        final firstCamera = _cameras.first;
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(camera: firstCamera,),
          )
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
  const CameraScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState(){
    super.initState();
      //controller is for current output of camera
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done);
        },
      )
    );
  }
}
