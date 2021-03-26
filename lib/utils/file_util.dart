import 'dart:io';
import 'dart:typed_data';
import 'package:datcao/share/function/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum FileType { document, image, video, gif }

class FileUtil {
  static FileType getFbUrlFileType(String path) {
    if (path == null) return null;

    if (path.toLowerCase().contains('.png') ||
        path.toLowerCase().contains('.jpg') ||
        path.toLowerCase().contains('.img') ||
        path.toLowerCase().contains('.jpeg') ||
        path.toLowerCase().contains('.webp')) return FileType.image;
    if (path.toLowerCase().contains('.mp4') || path.contains('.wmv'))
      return FileType.video;
    if (path.toLowerCase().contains('.doc')) return FileType.document;
    if (path.toLowerCase().contains('.gif')) return FileType.gif;
    return null;
  }

  static FileType getFilePathType(String path) {
    if (path == null) return null;

    if (Path.extension(path).toLowerCase() == '.png' ||
        Path.extension(path).toLowerCase() == '.jpg' ||
        Path.extension(path).toLowerCase() == '.img' ||
        Path.extension(path).toLowerCase() == '.jpeg' ||
        Path.extension(path).toLowerCase() == '.webp') return FileType.image;
    if (Path.extension(path).toLowerCase() == '.mp4' ||
        Path.extension(path).toLowerCase() == '.wmv') return FileType.video;
    if (Path.extension(path).toLowerCase() == '.doc') return FileType.document;
    if (Path.extension(path).toLowerCase() == '.gif') return FileType.gif;
    return null;
  }

  static Future<File> resizeImage(Uint8List data, int resizeWidth) async {
    img.Image image = img.decodeImage(data);

    // Resize the image to a 240? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(image, width: resizeWidth);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/thumbnail.jpg';
    return File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));
  }

  static Future<File> resizeImageOverride(
      String filePath, int resizeWidth) async {
    img.Image image = img.decodeImage(File(filePath).readAsBytesSync());

    // Resize the image to a 240? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(image, width: resizeWidth);

    return File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));
  }

  static Future<String> uploadFireStorage(String filePath,
      {String path, bool isResize = true, int resizeWidth = 1080}) async {
    if (filePath == null) return '';
    File file = File(filePath);
    if ((await file.length()) > 20 * 1024 * 1024) {
      showToastNoContext(
          'File có kích thước quá lớn, vui lòng upload file có dung lương < 20MB',
          bgColor: Colors.orange,
          textColor: Colors.white);
      return '';
    }

    try {
      // if (isResize &&
      //     getFbUrlFileType(Path.basename(filePath)) == FileType.image) {
      //   file = await resizeImageOverride(filePath, resizeWidth);
      // }

      Reference storageReference = FirebaseStorage.instance.ref().child(
          '${path ?? 'root'}/${DateTime.now().toString().replaceAll(' ', '')}${changeImageToJpg(Path.basename(file.path)).replaceAll(new RegExp(r'(\?alt).*'), '').replaceAll(' ', '')}');
      UploadTask uploadTask = storageReference.putFile(file);
      print('uploading...');
      await uploadTask.whenComplete(() {});
      print('File Uploaded');
      final fileURL = await storageReference.getDownloadURL();
      return fileURL;
    } catch (e) {
      throw Exception("Upload file thất bại. Xin vui lòng thử lại");
    }
  }

  static String changeImageToJpg(String name) {
    if (getFilePathType(name) == FileType.image)
      return name.replaceAll(Path.extension(name), '.jpg');
    return name;
  }

  static Future<bool> deleteFileFireStorage(String path) async {
    if (path == null) return false;
    String filePath = path;
    // filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

    // filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(filePath);

      if (storageReference != null) {
        print(filePath);
        print(storageReference);
        await storageReference.delete();
        return true;
      }
      return false;
    } catch (e) {
      // showToastNoContext(e.toString());
      return false;
    }
  }
}
