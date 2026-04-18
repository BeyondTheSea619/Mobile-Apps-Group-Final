import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String imgPath = '';
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    openCamera();
  }

  Future<bool> openCamera() async {
    try {
      var cameras = await availableCameras();

      setState(() {
        controller = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
      });

      await controller?.initialize();

      // refresh UI after camera opens
      setState(() {});

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<String> capturePhoto() async {
    try {
      var pic = await controller?.takePicture();

      setState(() {
        imgPath = pic!.path;
      });

      return pic!.path;
    } on Exception catch (e) {
      return Future.value('ERROR: Error in taking photo: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller == null
                ? const Text('Camera not opened!')
                : Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: CameraPreview(controller!),
                    ),
                  ),
            Flexible(
              child: imgPath == ''
                  ? const Text('No photo taken')
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Image.file(
                        File(imgPath),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () async {
          var result = await capturePhoto();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
            ),
          );

          if (imgPath.isNotEmpty) {
            Navigator.pop(context, imgPath);
          }
        },
      ),
    );
  }
}