import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissions() async {
  var permissions = [
    Permission.camera,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.location,
  ];

  for (var permission in permissions) {
    await on(permission);
  }
}

Future<void> on(Permission permission) async {
  var permissionStatus = await permission.status;
  if (permissionStatus.isGranted) {
    debugPrint("$permission permission is granted, not requesting");
  } else if (permissionStatus.isPermanentlyDenied) {
    debugPrint(
      "$permission permission is permanently denied, enable in settings",
    );
  } else {
    var requestResult = await permission.request();

    if (requestResult.isGranted) {
      debugPrint("$permission permission is granted");
    } else if (requestResult.isPermanentlyDenied) {
      debugPrint(
        "$permission permission is permanently denied, enable in settings",
      );
    }
  }
}
