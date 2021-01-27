import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/model/media_post.dart';
import 'package:vnrealtor/modules/post/comment_page.dart';
import 'package:vnrealtor/share/function/share_to.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/share/widget/spin_loader.dart';
import 'package:vnrealtor/utils/constants.dart';
import 'package:vnrealtor/utils/file_util.dart';

class MediaPostWidget extends StatelessWidget {
  final MediaPost post;
  final String tag;
  final double borderRadius;
  MediaPostWidget({@required this.post, this.tag, this.borderRadius = 0});
  @override
  Widget build(BuildContext context) {
    String genTag = tag ?? post.url + Random().nextInt(10000000).toString();
    final type = FileUtil.getFbUrlFileType(post.url);
    return GestureDetector(
      onTap: () {
        if (type == FileType.image || type == FileType.gif)
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailImagePost(
              post,
              tag: genTag,
            );
          }));
        //if (type == FileType.video)
          // Navigator.push(context, MaterialPageRoute(builder: (_) {
          //   return DetailVideoPost(
          //     post,
          //     tag: genTag,
          //   );
          // }));
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: _getWidget(type)),
    );
  }

  Widget _getWidget(FileType type) {
    if (type == FileType.image || type == FileType.gif)
      return Image.network(
        post.url,
        fit: BoxFit.cover,
        errorBuilder: imageNetworkErrorBuilder,
        loadingBuilder: kLoadingBuilder,
      );
    else if (type == FileType.video)
      return Image.network(
        post.url,
        fit: BoxFit.cover,
        errorBuilder: imageNetworkErrorBuilder,
        loadingBuilder: kLoadingBuilder,
      );
    return SizedBox.shrink();
  }
}

class DetailImagePost extends StatefulWidget {
  final MediaPost post;
  final String tag;
  DetailImagePost(this.post, {this.tag});

  @override
  _DetailImagePostState createState() => _DetailImagePostState();
}

class _DetailImagePostState extends State<DetailImagePost> {
  bool _isLike = false;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.black87),
              imageProvider: NetworkImage(
                widget.post.url,
              ),
              errorBuilder: (_, __, ___) => SizedBox.shrink(),
              loadingBuilder: (context, event) => PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.black87),
                imageProvider: NetworkImage(
                  widget.post.url,
                ),
                loadingBuilder: (context, event) => Center(
                  child: kLoadingSpinner,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(Icons.close),
              ),
            ),
          ),
          Positioned(
            width: deviceWidth(context),
            bottom: 0,
            child: Container(
              height: 48,
              color: Colors.black38,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _isLike = !_isLike;
                        if (_isLike) {
                          widget.post.like++;
                          _postBloc.likePost(widget.post.id);
                        } else {
                          widget.post.like--;
                          _postBloc.unlikePost(widget.post.id);
                        }
                        setState(() {});
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.thumbUpOutline,
                              size: 19,
                              color: _isLike
                                  ? ptPrimaryColor(context)
                                  : Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Like',
                              style: TextStyle(
                                  color: _isLike
                                      ? ptPrimaryColor(context)
                                      : Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.commentOutline,
                            color: Colors.white,
                            size: 19,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              showComment(widget.post, context);
                            },
                            child: Text(
                              'Comment',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.shareOutline,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () => shareTo(context),
                            child: Text(
                              'Share',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// class DetailVideoPost extends StatelessWidget {
//   final String post;
//   final String tag;
//   DetailVideoPost(this.post, {this.tag});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Stack(fit: StackFit.expand, children: [
//           Center(
//             child: PhotoView(
//               backgroundDecoration: BoxDecoration(color: Colors.black87),
//               imageProvider: NetworkImage(
//                 url,
//               ),
//               errorBuilder: (_, __, ___) => SizedBox.shrink(),
//               loadingBuilder: (context, event) => PhotoView(
//                 backgroundDecoration: BoxDecoration(color: Colors.black87),
//                 imageProvider: NetworkImage(
//                   url,
//                 ),
//                 loadingBuilder: (context, event) => Center(
//                   child: kLoadingSpinner,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             right: 10,
//             child: InkWell(
//               onTap: () => Navigator.of(context).maybePop(),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(20)),
//                 width: 40,
//                 height: 40,
//                 child: Icon(Icons.close),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

showComment(MediaPost postModel, BuildContext context) {
  showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
            height: deviceHeight(context) - kToolbarHeight - 15,
            child: Column(
              children: [
                Container(
                  height: 10,
                  width: deviceWidth(context),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: CommentPage(
                  mediaPost: postModel,
                )),
              ],
            ));
      });
}
