import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      final photosStatus = await Permission.photos.request();
      return photosStatus.isGranted;
    }
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      final statusWhenInUse = await Permission.locationWhenInUse.request();
      return statusWhenInUse.isGranted;
    }
    return status.isGranted;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
