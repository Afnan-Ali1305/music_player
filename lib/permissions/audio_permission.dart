import 'package:permission_handler/permission_handler.dart';

class AudioPermission {
  static Future<bool> request() async {
    return await Permission.audio.request().isGranted;
  }
}
