import 'dart:io';

import 'package:datcao/modules/inbox/import/spin_loader.dart';
import 'package:datcao/modules/inbox/import/video_view.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'image_view.dart';

class DetailMediaGroupWidget extends StatelessWidget {
  final List<String?>? files;
  final int? index;

  const DetailMediaGroupWidget({Key? key, this.files, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: index!);
    return PageView(
      controller: controller,
      children: files!.map((e) {
        if (FileUtil.getFbUrlFileType(e) == FileType.video)
          return DetailVideoScreen(e);
        if (FileUtil.getFbUrlFileType(e) == FileType.image)
          return DetailImageScreen(e);
        return SizedBox.shrink();
      }).toList(),
    );
  }
}

class DetailMediaGroupWidgetCache extends StatelessWidget {
  final List<String?>? files;
  final int? index;

  const DetailMediaGroupWidgetCache({Key? key, this.files, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: index!);
    return PageView(
      controller: controller,
      children: files!.map((e) {
        if (FileUtil.getFilePathType(e) == FileType.video)
          return DetailVideoScreenCache(e);
        if (FileUtil.getFilePathType(e) == FileType.image)
          return DetailImageScreenCache(e);
        return SizedBox.shrink();
      }).toList(),
    );
  }
}

class MediaWidgetNetwork extends StatefulWidget {
  final String? file;
  final Function? callBack;
  final double? radius;

  const MediaWidgetNetwork({Key? key, this.file, this.callBack, this.radius})
      : super(key: key);

  @override
  _MediaWidgetNetworkState createState() => _MediaWidgetNetworkState();
}

class _MediaWidgetNetworkState extends State<MediaWidgetNetwork> {
  String? thumbnailPath;
  FileType? type;

  @override
  void initState() {
    type = FileUtil.getFbUrlFileType(widget.file);
    if (type == FileType.video) _getThumbnail();
    super.initState();
  }

  _getThumbnail() async {
    thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.file!,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack!();

        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: _getWidget(type),
    );
  }

  Widget _getWidget(FileType? type) {
    if (type == FileType.image || type == FileType.gif)
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius ?? 5),
        child: Image(
          image: CachedNetworkImageProvider(widget.file!),
          fit: BoxFit.cover,
          errorBuilder: imageNetworkErrorBuilder as Widget Function(
              BuildContext, Object, StackTrace?)?,
          loadingBuilder: kLoadingBuilder,
        ),
      );
    else if (type == FileType.video)
      return thumbnailPath == null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/image/video_holder.png',
                fit: BoxFit.cover,
                errorBuilder: imageNetworkErrorBuilder as Widget Function(
                    BuildContext, Object, StackTrace?)?,
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(thumbnailPath!),
                    fit: BoxFit.cover,
                    errorBuilder: imageNetworkErrorBuilder as Widget Function(
                        BuildContext, Object, StackTrace?)?,
                  ),
                ),
                Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      size: 50, color: Colors.white),
                ),
              ],
            );
    return SizedBox.shrink();
  }
}

class MediaWidgetCache extends StatefulWidget {
  final String? path;
  final Function? callBack;
  final double? radius;

  const MediaWidgetCache({Key? key, this.path, this.callBack, this.radius})
      : super(key: key);

  @override
  _MediaWidgetCacheState createState() => _MediaWidgetCacheState();
}

class _MediaWidgetCacheState extends State<MediaWidgetCache> {
  String? thumbnailPath;
  FileType? type;

  @override
  void initState() {
    type = FileUtil.getFilePathType(widget.path);
    if (type == FileType.video) _getThumbnail();
    super.initState();
  }

  _getThumbnail() async {
    thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.path!,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.callBack != null) widget.callBack!();

          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _getWidget(type));
  }

  Widget _getWidget(FileType? type) {
    if (type == FileType.image || type == FileType.gif)
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius ?? 5),
        child: Image.file(
          File(widget.path!),
          fit: BoxFit.cover,
          errorBuilder: imageNetworkErrorBuilder as Widget Function(
              BuildContext, Object, StackTrace?)?,
        ),
      );
    else if (type == FileType.video)
      return thumbnailPath == null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius ?? 5),
              child: Image.asset(
                'assets/image/video_holder.png',
                fit: BoxFit.cover,
                errorBuilder: imageNetworkErrorBuilder as Widget Function(
                    BuildContext, Object, StackTrace?)?,
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius ?? 5),
                  child: Image.file(
                    File(thumbnailPath!),
                    fit: BoxFit.cover,
                    errorBuilder: imageNetworkErrorBuilder as Widget Function(
                        BuildContext, Object, StackTrace?)?,
                  ),
                ),
                Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      size: 45, color: Colors.white),
                ),
              ],
            );
    return SizedBox.shrink();
  }
}
