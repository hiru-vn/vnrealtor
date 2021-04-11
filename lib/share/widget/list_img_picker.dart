// INPUT :
// *********  A LIST OF STRING - IMAGE URL FROM IMGUR

// OUTPUT :
// *********  A FUCNTION THAT HANDLE A LIST OF
// **** CURRENT SELECTED IMAGE URL ****
// WHEN IMAGE URL IS UPLOAD OR REMOVE - IMPLEMENT FROM FATHER WIDGET

import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:datcao/modules/inbox/import/detail_media.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/file_util.dart';

import 'video_view.dart';

class ImageRowPicker extends StatefulWidget {
  final List<String> listImg;
  final bool canRemove;
  final Function(List<String>) onUpdateListImg;
  final Function reloadParent;
  final Function(String) onAddImg;
  final Function(List<String>) onAddMultiImg;
  final Function(String) onRemoveImg;
  ImageRowPicker(this.listImg,
      {this.onUpdateListImg,
      this.canRemove = true,
      this.reloadParent,
      this.onAddImg,
      this.onAddMultiImg,
      this.onRemoveImg});
  @override
  _ImageRowPickerState createState() => _ImageRowPickerState();
}

class _ImageRowPickerState extends State<ImageRowPicker>
    with AutomaticKeepAliveClientMixin {
  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: (widget.listImg?.length ?? 0) + 1,
      separatorBuilder: (context, index) => SizedBox(width: 10),
      itemBuilder: (context, index) {
        if (index != (widget.listImg?.length ?? 0)) {
          return Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              SizedBox(
                height: 110,
                width: 110,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FileUtil.getFbUrlFileType(widget.listImg[index]) ==
                              FileType.video
                          ? VideoViewNetwork(
                              url: widget.listImg[index], w: 100, h: 100)
                          : ImageViewNetwork(
                              url: widget.listImg[index], w: 100, h: 100),
                    ),
                  ),
                ),
              ),
              if (widget.canRemove)
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      showConfirmDialog(context, 'Xác nhận xóa hình ảnh này?',
                          navigatorKey: navigatorKey, confirmTap: () {
                        widget.listImg.removeAt(index);
                        setState(() {});
                        //await navigatorKey.currentState.maybePop();
                        if (widget.onRemoveImg != null)
                          widget.onRemoveImg(widget.listImg[index]);
                        if (widget.onUpdateListImg != null)
                          widget.onUpdateListImg(widget.listImg);
                        if (widget.reloadParent != null) widget.reloadParent();
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      )),
                    ),
                  ),
                ),
            ],
          );
        }
        if (widget.onUpdateListImg != null)
          return Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () => imagePicker(context, onCameraPick: (str) {
                if (widget.onAddImg != null) widget.onAddImg(str);
              }, onImagePick: (str) {
                if (widget.onAddImg != null) widget.onAddImg(str);
              }, onVideoPick: (str) {
                if (widget.onAddImg != null) widget.onAddImg(str);
              }),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(MdiIcons.plusCircle, size: 75, color: Colors.white),
              ),
            ),
          );
        return Container();
      },
    );
  }
}

class ImageButtonPicker extends StatefulWidget {
  final List<String> listImg;
  final bool canRemove;
  final Function(List<String>) onUpdateListImg;
  final Function reloadParent;
  final Function(String) onAddImg;
  final Function(List<String>) onAddMultiImg;

  final Function(String) onRemoveImg;
  ImageButtonPicker(this.listImg,
      {this.onUpdateListImg,
      this.canRemove = true,
      this.reloadParent,
      this.onAddImg,
      this.onAddMultiImg,
      this.onRemoveImg});
  @override
  _ImageButtonPickerState createState() => _ImageButtonPickerState();
}

class _ImageButtonPickerState extends State<ImageButtonPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            imagePicker(
              context,
              onCameraPick: (str) {
                if (widget.onAddImg != null) widget.onAddImg(str);
              },
              // , onImagePick: (str) {
              //   if (widget.onAddImg != null) widget.onAddImg(str);
              // },
              onVideoPick: (str) {
                if (widget.onAddImg != null) widget.onAddImg(str);
              },
              onMultiImagePick: (str) {
                if (widget.onAddMultiImg != null) widget.onAddMultiImg(str);
              },
            );
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(MdiIcons.camera),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Thêm hình ảnh/ video',
                  style: ptTitle(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        if (widget.listImg.length != 0)
          SizedBox(
            height: 100,
            width: deviceWidth(context),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (widget.listImg?.length ?? 0) + 1,
              separatorBuilder: (context, index) => SizedBox(width: 6),
              itemBuilder: (context, index) {
                if (index != (widget.listImg?.length ?? 0)) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 95,
                            width: 95,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: !widget.listImg[index].startsWith('http')
                                  ? FileUtil.getFilePathType(
                                              widget.listImg[index]) ==
                                          FileType.video
                                      ? MediaWidgetCache(
                                          path: widget.listImg[index],
                                          callBack: () {})
                                      : Image.file(
                                          File(widget.listImg[index]),
                                          fit: BoxFit.cover,
                                        )
                                  : (FileUtil.getFbUrlFileType(
                                              widget.listImg[index]) ==
                                          FileType.video
                                      ? VideoViewNetwork(
                                          url: widget.listImg[index],
                                          w: 95,
                                          h: 95)
                                      : ImageViewNetwork(
                                          url: widget.listImg[index],
                                          w: 95,
                                          h: 95)),
                            ),
                          ),
                        ),
                      ),
                      if (widget.canRemove)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              showConfirmDialog(
                                  context, 'Xác nhận xóa hình ảnh này?',
                                  navigatorKey: navigatorKey, confirmTap: () {
                                // widget.listImg.removeAt(index);
                                //await navigatorKey.currentState.maybePop();
                                if (widget.onRemoveImg != null)
                                  widget.onRemoveImg(widget.listImg[index]);
                                if (widget.onUpdateListImg != null)
                                  widget.onUpdateListImg(widget.listImg);
                                if (widget.reloadParent != null)
                                  widget.reloadParent();
                              });
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: ptPrimaryColor(context),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              )),
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
      ],
    );
  }
}

class MediaPickerWidget extends StatefulWidget {
  final Function(List<String>) onMediaPick;
  final Function(List<String>) onCaptureImage;
  final Function(List<String>) onGalleryPick;
  MediaPickerWidget(
      {Key key,
      @required this.onMediaPick,
      @required this.onCaptureImage,
      @required this.onGalleryPick})
      : super(key: key);

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
      end: 10, // end at a very big index (to get all the assets)
    );
    setState(() {});
  }

  _onLoadMore() async {
    final lastIndex = recentAssets.length;
    final loadMoreAssets = await albums.first.getAssetListRange(
      start: lastIndex, // start at index 0
      end: lastIndex + 10, // end at a very big index (to get all the assets)
    );
    setState(() {
      recentAssets.addAll(loadMoreAssets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceWidth(context) / 5 + 5,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollEndNotification &&
                  scrollController.position.extentAfter == 0) {
                _onLoadMore();
              }
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              itemCount: recentAssets.length + 2,
              itemBuilder: (_, index) {
                if (index == 0)
                  return Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Container(
                      width: deviceWidth(context) / 5 - 5,
                      height: deviceWidth(context) / 5 - 5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        MdiIcons.camera,
                        size: 40,
                        color: ptPrimaryColor(context).withOpacity(0.2),
                      ),
                    ),
                  );
                if (index == 1)
                  return Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Container(
                      width: deviceWidth(context) / 5 - 5,
                      height: deviceWidth(context) / 5 - 5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        MdiIcons.imageAlbum,
                        size: 40,
                        color: ptPrimaryColor(context).withOpacity(0.2),
                      ),
                    ),
                  );
                return Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: deviceWidth(context) / 5 - 5,
                      height: deviceWidth(context) / 5 - 5,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: AssetThumbnail(
                        asset: recentAssets[index - 2],
                        onTap: (val) {
                          if (!selectedAssets.contains(val))
                            selectedAssets.add(val);
                          else
                            selectedAssets.remove(val);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isSending) kLoadingSpinner
        ],
      ),
    );
  }
}

class AssetThumbnail extends StatefulWidget {
  final Function(AssetEntity) onTap;
  const AssetThumbnail({
    Key key,
    @required this.asset,
    @required this.onTap,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  _AssetThumbnailState createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  bool isSelected = false;
  Uint8List data;

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
              : Image.memory(data, fit: BoxFit.cover),
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

class MediaPagePickerWidget extends StatefulWidget {
  final Function(List<String>) onMediaPick;
  final int maxCount;
  MediaPagePickerWidget({Key key, @required this.onMediaPick, this.maxCount})
      : super(key: key);

  @override
  _MediaPagePickerWidgetState createState() => _MediaPagePickerWidgetState();
}

class _MediaPagePickerWidgetState extends State<MediaPagePickerWidget> {
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
      end: 21, // end at a very big index (to get all the assets)
    );
    setState(() {});
  }

  _onLoadMore() async {
    final lastIndex = recentAssets.length;
    final loadMoreAssets = await albums.first.getAssetListRange(
      start: lastIndex, // start at index 0
      end: lastIndex + 21, // end at a very big index (to get all the assets)
    );
    setState(() {
      recentAssets.addAll(loadMoreAssets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title:
              Text('Gallery', style: ptBigBody().copyWith(color: Colors.black)),
        ),
        body: Stack(
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
                  crossAxisCount: 3,
                ),
                itemCount: recentAssets.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: Container(
                      width: deviceWidth(context) / 3,
                      height: deviceWidth(context) / 3,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(0)),
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
                    ),
                  );
                },
              ),
            ),
            if (selectedAssets.length > 0)
              Positioned(
                  bottom: 20,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          setState(() {
                            isSending = true;
                          });
                          List<File> files = await Future.wait(
                              selectedAssets.map((e) => e.file).toList());
                          navigatorKey.currentState.pop();
                          widget.onMediaPick(files.map((e) => e.path).toList());
                        } catch (e) {} finally {
                          setState(() {
                            isSending = false;
                          });
                        }
                      },
                      child: Container(
                        width: deviceWidth(context) / 1.2,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            'Gửi ${selectedAssets.length} ảnh',
                            style: ptBigTitle().copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )),
            if (isSending) kLoadingSpinner
          ],
        ),
      ),
    );
  }
}
