// Dada KI Jay Ho

import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>> chooseListOfFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ["pdf", "png", "jpg", "jpeg"]);
  List<File> files = [];
  if (result != null) {
    result.paths.removeWhere((element) => element!.isEmpty);

    files = result.paths.map((path) => File(path!)).toList();
  }
  return files;
}
