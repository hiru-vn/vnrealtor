import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';

class FileUtil {
  static Future<File> writeToFile(
      Uint8List data, String name, String type, int size) async {
    Image image = decodeImage(data)!;

    // Resize the image to a 240? thumbnail (maintaining the aspect ratio).
    Image thumbnail = copyResize(image, width: size);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/$name.$type'; // file_01.tmp is dump file, can be anything
    return File(filePath)..writeAsBytesSync(encodePng(thumbnail));
  }
}
