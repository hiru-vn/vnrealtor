import 'dart:io';
import 'dart:math';
import 'package:datcao/modules/inbox/import/video_view.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'spin_loader.dart';

class VideoViewNetwork extends StatefulWidget {
  final String url;
  final String? tag;
  final int? w, h;
  VideoViewNetwork({required this.url, this.tag, this.w, this.h});

  @override
  _VideoViewNetworkState createState() => _VideoViewNetworkState();
}

class _VideoViewNetworkState extends State<VideoViewNetwork> {
  String? thumbnailPath;
  @override
  void initState() {
    _getThumbnail();
    super.initState();
  }

  _getThumbnail() async {
    thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          400, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String genTag =
        widget.tag ?? widget.url + Random().nextInt(10000000).toString();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailVideoScreen(
            widget.url,
            tag: genTag,
            scaleW: widget.w,
            scaleH: widget.h,
          );
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: thumbnailPath == null
            ? Image.asset(
                'assets/image/video_holder.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SizedBox.shrink(),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(thumbnailPath!),
                    fit: BoxFit.cover,
                    errorBuilder: imageNetworkErrorBuilder as Widget Function(BuildContext, Object, StackTrace?)?,
                  ),
                  Center(
                    child: Icon(Icons.play_circle_outline_rounded,
                        size: 50, color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}

// class DetailVideoScreen extends StatefulWidget {
//   final String url;
//   final String tag;
//   final int scaleW, scaleH;
//   DetailVideoScreen(this.url, {this.tag, this.scaleW, this.scaleH});

//   @override
//   _DetailVideoScreenState createState() => _DetailVideoScreenState();
// }

// class _DetailVideoScreenState extends State<DetailVideoScreen> {
//   VideoPlayerController _controller;
//   bool videoEnded = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then(
//         (_) {
//           if (mounted)
//             setState(() {
//               _controller.play();
//             });
//         },
//       );
//     _controller.addListener(() {
//       if (_controller.value.position == _controller.value.duration) {
//         setState(() {
//           videoEnded = true;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         child: Stack(fit: StackFit.expand, children: [
//           Positioned(
//             width: MediaQuery.of(context).size.width,
//             top: kToolbarHeight,
//             bottom: 0,
//             child: Container(
//               child: Center(
//                 child: _controller.value.initialized
//                     ? AspectRatio(
//                         aspectRatio: _controller.value.aspectRatio,
//                         child: VideoPlayer(_controller),
//                       )
//                     : kLoadingSpinner,
//               ),
//             ),
//           ),
//           Positioned(
//             top: kToolbarHeight,
//             right: 10,
//             child: InkWell(
//               onTap: () {
//                 Navigator.of(context).maybePop();
//                 FocusScope.of(context).requestFocus(FocusNode());
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(20)),
//                 width: 40,
//                 height: 40,
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (videoEnded) {
//             await _controller.seekTo(Duration.zero);
//             _controller.play();
//             setState(() {
//               videoEnded = false;
//             });
//             return;
//           }
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           videoEnded
//               ? Icons.replay
//               : (_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }
