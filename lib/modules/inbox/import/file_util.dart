import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<File> writeToFile(
      Uint8List data, String name, String type) async {
    // final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/$name.$type'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(data);
  }
}
