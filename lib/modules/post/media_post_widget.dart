import 'dart:io';
import 'dart:math';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/media_post.dart';
import 'package:datcao/modules/post/comment_page.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/spin_loader.dart';
import 'package:datcao/utils/constants.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class MediaPostWidget extends StatefulWidget {
  final MediaPost post;
  final String tag;
  final double borderRadius;
  MediaPostWidget({@required this.post, this.tag, this.borderRadius = 0});

  @override
  _MediaPostWidgetState createState() => _MediaPostWidgetState();
}

class _MediaPostWidgetState extends State<MediaPostWidget> {
  String thumbnailPath;
  FileType type;

  @override
  void initState() {
    type = FileUtil.getFbUrlFileType(widget.post.url);
    if (type == FileType.video) _getThumbnail();
    super.initState();
  }

  _getThumbnail() async {
    thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.post.url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String genTag =
        widget.tag ?? widget.post.url + Random().nextInt(10000000).toString();

    return GestureDetector(
      onTap: () {
        if (type == FileType.image || type == FileType.gif)
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailImagePost(
              widget.post,
              tag: genTag,
            );
          }));
        if (type == FileType.video)
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return DetailVideoPost(
              widget.post,
              tag: genTag,
            );
          }));
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: _getWidget(type)),
    );
  }

  Widget _getWidget(FileType type) {
    if (type == FileType.image || type == FileType.gif)
      return Image(
        image: CachedNetworkImageProvider(widget.post.url),
        fit: BoxFit.cover,
        errorBuilder: imageNetworkErrorBuilder,
        loadingBuilder: kLoadingBuilder,
      );
    else if (type == FileType.video)
      return thumbnailPath == null
          ? Image.asset(
              'assets/image/video_holder.png',
              fit: BoxFit.cover,
              errorBuilder: imageNetworkErrorBuilder,
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(thumbnailPath),
                  fit: BoxFit.cover,
                  errorBuilder: imageNetworkErrorBuilder,
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
      backgroundColor: Colors.transparent,
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
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
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
                        if (AuthBloc.instance.userModel == null) {
                          LoginPage.navigatePush();
                          return;
                        }
                        _isLike = !_isLike;
                        if (_isLike) {
                          widget.post.like++;
                          _postBloc.likeMediaPost(widget.post.id);
                        } else {
                          if (widget.post.like > 0) widget.post.like--;
                          _postBloc.unlikeMediaPost(widget.post.id);
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
                              'Thích',
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
                            onTap: () async {
                              if (AuthBloc.instance.userModel == null) {
                                await navigatorKey.currentState.maybePop();
                                LoginPage.navigatePush();
                                return;
                              }
                              showComment(widget.post, context);
                            },
                            child: Text(
                              'Bình luận',
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
                            onTap: () =>
                                shareTo(context, image: [widget.post.url]),
                            child: Text(
                              'Chia sẻ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            width: deviceWidth(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ptPrimaryColor(context),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      MdiIcons.thumbUp,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.post?.like?.toString() ?? '0',
                    style: ptSmall().copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showComment(widget.post, context);
                    },
                    child: Text(
                      '${widget.post?.commentIds?.length.toString() ?? '0'} bình luận',
                      style: ptSmall().copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class DetailVideoPost extends StatefulWidget {
  final MediaPost post;
  final String tag;
  final int scaleW, scaleH;
  DetailVideoPost(this.post, {this.tag, this.scaleW, this.scaleH});

  @override
  _DetailVideoPostState createState() => _DetailVideoPostState();
}

class _DetailVideoPostState extends State<DetailVideoPost> {
  VideoPlayerController _controller;
  bool videoEnded = false;
  bool _isLike = false;
  PostBloc _postBloc;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.url)
      ..initialize().then(
        (_) {
          if (mounted)
            setState(() {
              _controller.play();
            });
        },
      );
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          videoEnded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: kToolbarHeight,
            bottom: 0,
            child: Container(
              child: Center(
                child: _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : kLoadingSpinner,
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight,
            right: 10,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
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
                        if (AuthBloc.instance.userModel == null) {
                          LoginPage.navigatePush();
                          return;
                        }
                        _isLike = !_isLike;
                        if (_isLike) {
                          widget.post.like++;
                          _postBloc.likeMediaPost(widget.post.id);
                        } else {
                          if (widget.post.like > 0) widget.post.like--;
                          _postBloc.unlikeMediaPost(widget.post.id);
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
                              'Thích',
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
                              'Bình luận',
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
                            onTap: () =>
                                shareTo(context, video: [widget.post.url]),
                            child: Text(
                              'Chia sẻ',
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     if (videoEnded) {
      //       await _controller.seekTo(Duration.zero);
      //       _controller.play();
      //       setState(() {
      //         videoEnded = false;
      //       });
      //       return;
      //     }
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     videoEnded
      //         ? Icons.replay
      //         : (_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      //   ),
      // ),
    );
  }
}

showComment(MediaPost postModel, BuildContext context) {
  showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
            height: deviceHeight(context) - kToolbarHeight - 15,
            child: CommentPage(
              mediaPost: postModel,
            ));
      });
}
