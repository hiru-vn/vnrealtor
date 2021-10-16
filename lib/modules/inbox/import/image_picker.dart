import 'dart:io';

import 'package:datcao/share/function/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

// variable to hold image to be displayed

void imagePicker(BuildContext context,
    {Function(String path)? onCameraPick,
    Function(String path)? onImagePick,
    Function(String path)? onVideoPick,
    Function(List<String>)? onMultiImagePick,
    String? title}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
      context: context,
      builder: (_) {
        return Material(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   title ??
                //       'Chọn ảnh ${onVideoPick != null ? 'và video ' : ''}từ điện thoại',
                //   style: TextStyle(
                //       fontWeight: FontWeight.bold, color: Color(0xff696969)),
                // ),
                // SizedBox(
                //   height: 12,
                // ),
                // if (onVideoPick != null) Divider(height: 1, color: Colors.grey),
                // if (onVideoPick != null)
                //   SizedBox(
                //     height: 16,
                //   ),
                if (onCameraPick != null) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onCustomPersionRequest(
                          permission: Permission.camera,
                          onGranted: () {
                            // close showModalBottomSheet
                            Navigator.of(context).pop();
                            ImagePicker()
                                .pickImage(source: ImageSource.camera)
                                .then((value) {
                              if (value == null) return;
                              onCameraPick(value.path);
                            });
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Chụp ảnh từ camera',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
                if (onMultiImagePick != null) ...[
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onCustomPersionRequest(
                          permission: Permission.photos,
                          onGranted: () async {
                            // close showModalBottomSheet
                            Navigator.of(context).pop();
                            try {
                              final assets = await MultiImagePicker.pickImages(
                                maxImages: 9,
                                enableCamera: false,
                                cupertinoOptions:
                                    CupertinoOptions(takePhotoIcon: "chat"),
                                materialOptions: MaterialOptions(
                                  actionBarColor: '#05515e',
                                  statusBarColor: '#05515e',
                                  textOnNothingSelected: 'Huỷ chọn',
                                  actionBarTitle: "Chọn 1 hoặc nhiều ảnh",
                                  allViewTitle: "Tất cả hình ảnh",
                                  useDetailsView: false,
                                  selectCircleStrokeColor: "#000000",
                                ),
                              );
                              final List<String> images = await Future.wait(
                                  assets.map(
                                      (e) => getImageFilePathFromAssets(e)));
                              onMultiImagePick(images);
                            } on Exception catch (e) {
                              showToast(e.toString(), context);
                            }
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.collections,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Kho hình ảnh',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
                if (onImagePick != null) ...[
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onCustomPersionRequest(
                          permission: Permission.photos,
                          onGranted: () {
                            // close showModalBottomSheet
                            Navigator.of(context).pop();

                            ImagePicker()
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value == null) return;
                              onImagePick(value.path);
                            });
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.image,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Hình ảnh',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
                if (onVideoPick != null) ...[
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onCustomPersionRequest(
                          permission: Permission.photos,
                          onGranted: () {
                            // close showModalBottomSheet
                            Navigator.of(context).pop();

                            ImagePicker()
                                .pickVideo(source: ImageSource.gallery)
                                .then((value) {
                              if (value == null) return;
                              onVideoPick(value.path);
                            });
                          });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.video_collection,
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          'Kho video',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8))),
            padding: EdgeInsets.all(15),
          ),
        );
      }).then((value) => FocusScope.of(context).requestFocus(FocusNode()));
}

onCustomPersionRequest(
    {required Permission permission,
    Function? onGranted,
    Function? onAlreadyDenied,
    Function? onJustDeny,
    Function? onAndroidPermanentDenied}) {
  permission.status.then((value) {
    if (value.isDenied) {
      Permission.camera.request().then((value) {
        if (value.isDenied && onJustDeny != null) {
          onJustDeny();
        } else if (value.isGranted && onGranted != null) {
          onGranted();
        } else if (value.isPermanentlyDenied &&
            onAndroidPermanentDenied != null) {
          onAndroidPermanentDenied();
        }
      });
    } else if (value.isDenied && onAlreadyDenied != null) {
      onAlreadyDenied();
    } else if (value.isGranted && onGranted != null) {
      onGranted();
    }
  });
}

Future<String> getImageFilePathFromAssets(Asset asset) async {
  final byteData = await asset.getByteData();

  final tempFile =
      File("${(await getTemporaryDirectory()).path}/${asset.name}");
  final file = await tempFile.writeAsBytes(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );

  return file.path;
}
