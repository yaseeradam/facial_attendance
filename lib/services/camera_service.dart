import 'dart:io';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static CameraController? _controller;
  static List<CameraDescription>? _cameras;

  static Future<bool> initialize() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) return false;

      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return false;

      _controller = CameraController(_cameras!.first, ResolutionPreset.medium);
      await _controller!.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }

  static CameraController? get controller => _controller;

  static Future<File?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    try {
      final image = await _controller!.takePicture();
      return File(image.path);
    } catch (e) {
      return null;
    }
  }

  static void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}