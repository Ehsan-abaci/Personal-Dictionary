import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constant/functions.dart';

class FileManager {
  File? fileInDirectoryToSave;
  File? fileInDirectoryToSelect;
  String? message;

  Future<void> importFile() async {
    try {
      FilePickerResult? fileRes = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["json"],
      );
      if (fileRes != null) {
        fileInDirectoryToSelect = File(fileRes.files.single.path!);
      }
    } catch (e) {
      handleFileOperationError();
    }
  }

  Future<void> exportFile(FileStorageManager storageManager) async {
    try {
      if (await storageManager.isStoragePermissionGranted()) {
        String filePath = await storageManager.getUniqueFilePath();
        fileInDirectoryToSave = File(filePath);
      } else {
        await storageManager.requestStoragePermission();
      }
    } catch (e) {
      handleFileOperationError();
    }
  }

  Future<void> handleFileOperationError() async {
    message = "The process has encountered an error";
    showNotification(message);
  }
}

class FileStorageManager {
  Future<bool> isStoragePermissionGranted() async {
    return await Permission.manageExternalStorage.isGranted;
  }

  Future<void> requestStoragePermission() async {
    await Permission.manageExternalStorage.request();
  }

  Future<String> getUniqueFilePath() async {
    Directory personalDictionaryDirectory =
        Directory("/storage/emulated/0/Personal Dictionary");
    String res = "";

    if (await personalDictionaryDirectory.exists()) {
      res = personalDictionaryDirectory.path;
    } else {
      Directory appDirectory =
          await personalDictionaryDirectory.create(recursive: true);
      res = appDirectory.path;
    }
    String filePath = '$res/data.json';

    int suffix = 1;
    while (await File(filePath).exists()) {
      filePath = '$res/data_$suffix.json';
      suffix++;
    }
    return filePath;
  }
}
