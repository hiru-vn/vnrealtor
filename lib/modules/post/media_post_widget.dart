import 'dart:io';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
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

class GroupMediaPostWidget extends StatelessWidget {
  final List<MediaPost> posts;
  final bool autoPlayVideo;

  const GroupMediaPostWidget({Key key, this.posts, this.autoPlayVideo = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final callBack = (int index) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return DetailListMediaPost(
          posts: posts,
          index: index,
        );
      }));
    };
    if (posts.length == 1) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: deviceWidth(context) * 1.1),
        child: SizedBox(
          width: deviceWidth(context),
          child: MediaPostWidget(
            post: posts[0],
            onTapPostCallBack: () => callBack(0),
            autoPlayVideo: autoPlayVideo,
          ),
        ),
      );
    }
    if (posts.length == 2) {
      return Row(
        children: [
          SizedBox(
            width: deviceWidth(context) / 2 - 1.5,
            height: deviceWidth(context) / 2,
            child: MediaPostWidget(
              post: posts[0],
              onTapPostCallBack: () => callBack(0),
            ),
          ),
          SizedBox(
            width: 3,
          ),
          SizedBox(
            width: deviceWidth(context) / 2 - 1.5,
            height: deviceWidth(context) / 2,
            child: MediaPostWidget(
              post: posts[1],
              onTapPostCallBack: () => callBack(1),
            ),
          ),
        ],
      );
    }
    if (posts.length == 3) {
      return Column(
        children: [
          SizedBox(
            width: deviceWidth(context),
            height: deviceWidth(context) / 2,
            child: MediaPostWidget(
              post: posts[0],
              onTapPostCallBack: () => callBack(0),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2.5,
                child: MediaPostWidget(
                  post: posts[1],
                  onTapPostCallBack: () => callBack(1),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2.5,
                child: MediaPostWidget(
                  post: posts[2],
                  onTapPostCallBack: () => callBack(2),
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (posts.length == 4) {
      return Column(
        children: [
          SizedBox(
            width: deviceWidth(context),
            height: deviceWidth(context) / 2,
            child: MediaPostWidget(
              post: posts[0],
              onTapPostCallBack: () => callBack(0),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[1],
                  onTapPostCallBack: () => callBack(1),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[2],
                  onTapPostCallBack: () => callBack(2),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[3],
                  onTapPostCallBack: () => callBack(3),
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (posts.length == 5) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2,
                child: MediaPostWidget(
                  post: posts[0],
                  onTapPostCallBack: () => callBack(0),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2,
                child: MediaPostWidget(
                  post: posts[1],
                  onTapPostCallBack: () => callBack(1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[2],
                  onTapPostCallBack: () => callBack(2),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[3],
                  onTapPostCallBack: () => callBack(3),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[4],
                  onTapPostCallBack: () => callBack(4),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (posts.length > 5) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2,
                child: MediaPostWidget(
                  post: posts[0],
                  onTapPostCallBack: () => callBack(0),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 2 - 1.5,
                height: deviceWidth(context) / 2,
                child: MediaPostWidget(
                  post: posts[1],
                  onTapPostCallBack: () => callBack(1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[2],
                  onTapPostCallBack: () => callBack(2),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: MediaPostWidget(
                  post: posts[3],
                  onTapPostCallBack: () => callBack(3),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: deviceWidth(context) / 3 - 2,
                height: deviceWidth(context) / 3,
                child: Stack(
                  children: [
                    SizedBox(
                      width: deviceWidth(context) / 3 - 2,
                      height: deviceWidth(context) / 3,
                      child: MediaPostWidget(
                        post: posts[4],
                        onTapPostCallBack: () => callBack(4),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        width: deviceWidth(context) / 3 - 2,
                        height: deviceWidth(context) / 3,
                        color: Colors.black45,
                      ),
                    ),
                    IgnorePointer(
                      child: Center(
                        child: Text(
                          '+' + (posts.length - 4).toString(),
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}

class MediaPostWidget extends StatefulWidget {
  final MediaPost post;
  final Function onTapPostCallBack;
  final bool autoPlayVideo;
  MediaPostWidget(
      {@required this.post,
      @required this.onTapPostCallBack,
      this.autoPlayVideo = false});

  @override
  _MediaPostWidgetState createState() => _MediaPostWidgetState();
}

class _MediaPostWidgetState extends State<MediaPostWidget> {
  String thumbnailPath;
  FileType type;
  VideoPlayerController _controller;

  @override
  void initState() {
    type = FileUtil.getFbUrlFileType(widget.post.url);
    if (type == FileType.video) {
      _getThumbnail();
      _controller = VideoPlayerController.network(widget.post.url)
        ..initialize().then(
          (_) {
            if (mounted)
              setState(() {
                _controller.setLooping(true);
                _controller.setVolume(0);
                _controller.play();
              });
          },
        );
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
    return GestureDetector(
      onTap: () {
        widget.onTapPostCallBack();

        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: _getWidget(type),
    );
  }

  Widget _getWidget(FileType type) {
    final thumb = thumbnailPath == null
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
    if (type == FileType.image || type == FileType.gif)
      return Image(
        image:
            CachedNetworkImageProvider(widget.post.halfUrl ?? widget.post.url),
        fit: BoxFit.cover,
        errorBuilder: imageNetworkErrorBuilder,
        loadingBuilder: kLoadingBuilder,
      );
    else if (type == FileType.video) {
      if (widget.autoPlayVideo) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          try {
            final InViewState inViewState = InViewNotifierList.of(context);
            if (inViewState == null) return thumb;

            inViewState.addContext(context: context, id: widget.post.url);
            final Size size = _controller.value.size;
            if (size == null) return thumb;
            return AnimatedBuilder(
                animation: inViewState,
                builder: (context, snapshot) {
                  if (inViewState.inView(widget.post.url)) {
                    _controller.play();
                  } else {
                    _controller.pause();
                  }
                  return ClipRect(
                      child: OverflowBox(
                          maxWidth: deviceWidth(context),
                          maxHeight: double.infinity,
                          alignment: Alignment.center,
                          child: new FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: Container(
                                  width: size?.width ?? deviceWidth(context),
                                  height: size?.height ??
                                      (deviceWidth(context) *
                                          _controller.value.aspectRatio),
                                  child: VideoPlayer(_controller)))));
                });
          } catch (e) {
            return thumb;
          }
        });
      } else
        return thumb;
    }
    return SizedBox.shrink();
  }
}

class DetailListMediaPost extends StatelessWidget {
  final List<MediaPost> posts;
  final int index;

  const DetailListMediaPost({Key key, this.posts, this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: index);
    return PageView(
      controller: controller,
      children: posts.map((e) {
        if (e.type == 'VIDEO') return DetailVideoPost(e);
        if (e.type == 'PICTURE') return DetailImagePost(e);
        return SizedBox();
      }).toList(),
    );
  }
}

class DetailImagePost extends StatefulWidget {
  final MediaPost post;
  DetailImagePost(this.post);

  @override
  _DetailImagePostState createState() => _DetailImagePostState();
}

class _DetailImagePostState extends State<DetailImagePost> {
  bool _isLike = false;
  PostBloc _postBloc;
  MediaPost _post;

  @override
  void initState() {
    _post = widget.post;
    if (AuthBloc.instance.userModel != null)
      _isLike =
          widget.post.userLikeIds.contains(AuthBloc.instance.userModel.id);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      if (AuthBloc.instance.userModel != null)
        _postBloc.getOneMediaPost(widget.post.id).then((res) {
          if (res.isSuccess)
            setState(() {
              _post = res.data;
              _isLike =
                  _post.userLikeIds.contains(AuthBloc.instance.userModel.id);
            });
          else
            showToast(res.errMessage, context);
        });
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
              imageProvider: CachedNetworkImageProvider(
                _post.halfUrl ?? _post.url,
              ),
              errorBuilder: (_, __, ___) => SizedBox.shrink(),
              loadingBuilder: (context, event) => Center(
                child: kLoadingSpinner,
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
                          _post.like++;
                          _postBloc.likeMediaPost(_post.id);
                        } else {
                          if (_post.like > 0) _post.like--;
                          _postBloc.unlikeMediaPost(_post.id);
                        }
                        setState(() {});
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
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
                    child: GestureDetector(
                      onTap: () async {
                        // if (AuthBloc.instance.userModel == null) {
                        //   await navigatorKey.currentState.maybePop();
                        //   LoginPage.navigatePush();
                        //   return;
                        // }
                        showComment(widget.post, context);
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
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
                            Text(
                              'Bình luận',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        String content =
                            widget.post.dynamicLink?.shortLink ?? '';
                        shareTo(context,
                            image: [widget.post.url], content: content);
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
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
                            Text(
                              'Chia sẻ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
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
                    _post.like?.toString() ?? '0',
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
  final int scaleW, scaleH;
  DetailVideoPost(this.post, {this.scaleW, this.scaleH});

  @override
  _DetailVideoPostState createState() => _DetailVideoPostState();
}

class _DetailVideoPostState extends State<DetailVideoPost> {
  VideoPlayerController _controller;
  bool videoEnded = false;
  bool _isLike = false;
  PostBloc _postBloc;
  MediaPost _post;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      if (AuthBloc.instance.userModel != null) {
        _postBloc.getOneMediaPost(widget.post.id).then((res) {
          if (res.isSuccess)
            setState(() {
              _post = res.data;
              _isLike =
                  _post.userLikeIds.contains(AuthBloc.instance.userModel.id);
            });
          else
            showToast(res.errMessage, context);
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _post = widget.post;
    if (AuthBloc.instance.userModel != null)
      _isLike =
          widget.post.userLikeIds.contains(AuthBloc.instance.userModel.id);
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
                          _post.like++;
                          _postBloc.likeMediaPost(_post.id);
                        } else {
                          if (_post.like > 0) _post.like--;
                          _postBloc.unlikeMediaPost(_post.id);
                        }
                        setState(() {});
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
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
                    child: GestureDetector(
                      onTap: () {
                        showComment(_post, context);
                      },
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
                            Text(
                              'Bình luận',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        String content =
                            widget.post.dynamicLink?.shortLink ?? '';
                        shareTo(context,
                            video: [widget.post.url], content: content);
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
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
                            Text(
                              'Chia sẻ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
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
                    _post.like?.toString() ?? '0',
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
            height: deviceHeight(context) - kToolbarHeight,
            child: CommentPage(
                mediaPost: postModel,
                keyboardPadding: MediaQuery.of(context).viewInsets.bottom));
      });
}
