import 'dart:io';
import 'dart:typed_data';

import 'package:datcao/modules/inbox/import/font.dart';
import 'package:datcao/modules/inbox/import/spin_loader.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPickerWidget extends StatefulWidget {
  final Function(List<String>) onMediaPick;
  MediaPickerWidget({Key? key, required this.onMediaPick}) : super(key: key);

  @override
  _MediaPickerWidgetState createState() => _MediaPickerWidgetState();
}

class _MediaPickerWidgetState extends State<MediaPickerWidget> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> recentAssets = [];
  List<AssetEntity> selectedAssets = [];
  bool isSending = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getMedia();
    super.initState();
  }

  Future<void> getMedia() async {
    final permitted = await PhotoManager.requestPermission();
    if (!permitted) return;
    albums = await PhotoManager.getAssetPathList(onlyAll: true);

    // Now that we got the album, fetch all the assets it contains
    recentAssets = await albums.first.getAssetListRange(
      start: 0, // start at index 0
      end: 20, // end at a very big index (to get all the assets)
    );
    setState(() {});
  }

  _onLoadMore() async {
    final lastIndex = recentAssets.length;
    final loadMoreAssets = await albums.first.getAssetListRange(
      start: lastIndex, // start at index 0
      end: lastIndex + 20, // end at a very big index (to get all the assets)
    );
    setState(() {
      recentAssets.addAll(loadMoreAssets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollController.position.extentAfter == 0) {
              _onLoadMore();
            }
            return true;
          },
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // A grid view with 3 items per row
              crossAxisCount: 4,
            ),
            itemCount: recentAssets.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(0.5),
                child: AssetThumbnail(
                  asset: recentAssets[index],
                  onTap: (val) {
                    if (!selectedAssets.contains(val))
                      selectedAssets.add(val);
                    else
                      selectedAssets.remove(val);
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
        if (selectedAssets.length > 0)
          Positioned(
              bottom: 0,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    try {
                      setState(() {
                        isSending = true;
                      });
                      List<File?> files = await Future.wait(
                          selectedAssets.map((e) => e.file).toList());
                      widget.onMediaPick(files.map((e) => e!.path).toList());
                    } catch (e) {} finally {
                      setState(() {
                        isSending = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Text(
                      'Gửi ${selectedAssets.length} ảnh',
                      style: ptBigBody().copyWith(color: Colors.white),
                    ),
                  ),
                ),
              )),
        if (isSending) kLoadingSpinner
      ],
    );
  }
}

class AssetThumbnail extends StatefulWidget {
  final Function(AssetEntity) onTap;
  const AssetThumbnail({
    Key? key,
    required this.asset,
    required this.onTap,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  bool isSelected = false;
  Uint8List? data;

  @override
  void initState() {
    widget.asset.thumbData.then((value) => setState(() {
          data = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap(widget.asset);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          data == null
              ? Container(
                  color: Colors.grey[100],
                )
              : Image.memory(data!, fit: BoxFit.cover),
          if (isSelected)
            Center(
                child: Container(
              padding: EdgeInsets.all(4),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 17,
              ),
            ))
        ],
      ),
    );
  }
}
