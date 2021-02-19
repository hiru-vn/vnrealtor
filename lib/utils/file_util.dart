import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

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

  static Future<String> uploadFireStorage(File file, { String path}) async {
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
