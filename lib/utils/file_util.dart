import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

enum FileType { document, image, video, gif }

class FileUtil {
  static FileType getFbUrlFileType(String path) {
    if (path == null) return null;

    if (path.contains('.png') ||
        path.contains('.jpg') ||
        path.contains('.img') ||
        path.contains('.jpeg') ||
        path.contains('.webp')) return FileType.image;
    if (path.contains('.mp4') || path.contains('.wmv')) return FileType.video;
    if (path.contains('.doc')) return FileType.document;
    if (path.contains('.gif')) return FileType.gif;
    return null;
  }

  static Future<File> resizeImage(Uint8List data, int resizeWidth) async {
    Image image = decodeImage(data);

    // Resize the image to a 240? thumbnail (maintaining the aspect ratio).
    Image thumbnail = copyResize(image, width: 360);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/thumbnail.jpeg'; 
    return File(filePath)..writeAsBytesSync(encodePng(thumbnail));
  }

  static Future<String> uploadFireStorage(File file, {String path}) async {
    if (file == null) return '';
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('${path ?? 'root'}/${Path.basename(file.path)}');
      UploadTask uploadTask = storageReference.putFile(file);
      print('uploading...');
      await uploadTask.whenComplete(() {});
      print('File Uploaded');
      final fileURL = await storageReference.getDownloadURL();
      return fileURL;
    } catch (e) {
      throw Exception("Upload file thất bại. Xin kiểm tra lại internet");
    }
  }
}
