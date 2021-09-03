import 'dart:async';

import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/reply.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/function/time_ago.dart';
import 'package:datcao/share/widget/tag_user_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/media_post.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/share/import.dart';
import 'package:graphql/client.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;
  final MediaPost mediaPost;
  final double keyboardPadding;

  const CommentPage(
      {Key key, this.post, this.mediaPost, this.keyboardPadding = 0})
      : super(key: key);

  static Future navigate(PostModel post, MediaPost mediaPost) {
    return navigatorKey.currentState.push(pageBuilder(CommentPage(
      post: post,
      mediaPost: mediaPost,
    )));
  }

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isPost = true;
  bool isMediaPost = false;
  bool isReply = false;
  List<CommentModel> comments;
  TextEditingController _commentC = TextEditingController();
  PostBloc _postBloc;
  String sort = '{createdAt: 1}';
  ScrollController _controller;
  StreamSubscription<FetchResult> _streamSubcription;
  FocusNode _focusNodeComment = FocusNode();
  CommentModel replyComment;
  List<ReplyModel> localReplies = [];
  List<UserModel> tagUsers = [];

  @override
  void initState() {
    if (widget.mediaPost != null) {
      isPost = false;
      isMediaPost = true;
    }
    _focusNodeComment.addListener(() {
      if (!_focusNodeComment.hasFocus) {
        // Future.delayed(Duration(milliseconds: 100), () {
        //   setState(() {
        //     isReply = false;
        //     replyComment = null;
        //   });
        // });
      }
    });

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _focusNodeComment?.dispose();
    _streamSubcription?.cancel();
  }

  _deleteComment(String id) async {
    comments.removeWhere((element) => element.id == id);
    setState(() {});
    final res = await _postBloc.deleteComment(id);
    if (!res.isSuccess) showToast(res.errMessage, context);
  }

  _comment(String text) async {
    if (text.trim() == '') return;
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    comments.add(CommentModel(
        content: text,
        like: 0,
        userId: AuthBloc.instance.userModel.id,
        user: AuthBloc.instance.userModel,
        updatedAt: DateTime.now().toIso8601String(),
        userTags: Map.fromIterable(tagUsers,
            key: (e) => e.id, value: (e) => e.name)));
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createComment(text,
        postId: widget.post?.id,
        mediaPostId: widget.mediaPost?.id,
        tagUserIds: tagUsers.map((e) => e.id).toList());
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      final resComment = (res.data as CommentModel);
      if (isPost) widget.post.commentIds.add(resComment.id);
      if (isMediaPost) widget.mediaPost.commentIds.add(resComment.id);
      final index = comments
          .lastIndexWhere((element) => element.userId == resComment.userId);
      if (index >= 0)
        setState(() {
          comments[index] = resComment;
          tagUsers = [];
        });
    }
  }

  _reply(String text) async {
    if (text.trim() == '') return;
    if (replyComment == null) return;
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    localReplies.add(ReplyModel(
        content: text,
        userId: AuthBloc.instance.userModel.id,
        commentId: replyComment.id,
        user: AuthBloc.instance.userModel,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        userTags: Map.fromIterable(tagUsers,
            key: (e) => e.id, value: (e) => e.name)));
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createReply(text, replyComment.id,
        tagUserIds: tagUsers.map((e) => e.id).toList());
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      final index = localReplies
          .lastIndexWhere((element) => element.userId == res.data.userId);
      if (mounted)
        setState(() {
          if (index >= 0) {
            localReplies[index].id = res.data.id;
            comments
                .firstWhere((element) => element.id == replyComment.id)
                .replyIds
                .add(res.data.id);
          }
          isReply = false;
          replyComment = null;
        });
    }
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _getComments(filter: GraphqlFilter(limit: 20));

      // //setup socket
      // if (isPost) _postBloc.subscriptionCommentByPostId(widget.post.id);
      // if (isMediaPost)
      //   _postBloc.subscriptionCommentByPostId(widget.mediaPost.id);
      // Future.delayed(Duration(seconds: 2), () {
      //   _streamSubcription = _postBloc.commentSubcription.listen((event) {
      //     print(event.data);
      //     CommentModel socketComment =
      //         CommentModel.fromJson(event.data['newComment']);
      //     if (socketComment.userId != AuthBloc.instance.userModel?.id)
      //       setState(() {
      //         comments.add(socketComment);
      //       });
      //   });
      // });
    }
    super.didChangeDependencies();
  }

  Future _getComments({GraphqlFilter filter}) async {
    BaseResponse res;
    if (AuthBloc.instance.userModel == null) {
      if (isPost)
        res = await _postBloc.getAllCommentByPostIdGuest(widget.post.id,
            filter: filter);
      if (isMediaPost)
        res = await _postBloc.getAllCommentByMediaPostIdGuest(
            widget.mediaPost.id,
            filter: filter);
    } else {
      if (isPost)
        res = await _postBloc.getAllCommentByPostId(widget.post.id,
            filter: filter);
      if (isMediaPost)
        res = await _postBloc.getListMediaPostComment(widget.mediaPost.id,
            filter: filter);
    }
    if (res == null) return;
    if (res.isSuccess) {
      if (mounted)
        setState(() {
          comments = res.data;
        });
      Future.delayed(
        Duration(
          milliseconds: 50,
        ),
        () => _controller.jumpTo(_controller.position.maxScrollExtent),
      );
    } else {
      showToast('Có lỗi khi lấy dữ liệu', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 1,
        builder: (context, controller) {
          _controller = controller;
          return Scaffold(
            appBar: AppBar1(
              title: 'Bình luận',
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                      value: sort,
                      style: ptBody().copyWith(color: Colors.black87),
                      items: [
                        DropdownMenuItem(
                          child: Text('Mới nhất'),
                          value: '{createdAt: -1}',
                        ),
                        DropdownMenuItem(
                          child: Text('Cũ nhất'),
                          value: '{createdAt: 1}',
                        ),
                      ],
                      underline: SizedBox.shrink(),
                      onChanged: (val) {
                        setState(() {
                          sort = val;
                        });
                        _getComments(
                            filter: GraphqlFilter(limit: 20, order: val));
                      }),
                )
              ],
            ),
            body: Column(
              children: [
                comments != null
                    ? Expanded(
                        child: ListView.separated(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: controller,
                          padding: EdgeInsets.zero,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return CommentWidget(
                                userReplyCache: localReplies,
                                comment: comment,
                                deleteCallBack: comments[index].userId ==
                                        AuthBloc.instance.userModel?.id
                                    ? () => _deleteComment(comments[index].id)
                                    : () {},
                                shouldExpand:
                                    comments[index].id == replyComment?.id,
                                tapCallBack: () {
                                  setState(() {
                                    isReply = true;
                                    replyComment = comments[index];
                                  });
                                  _focusNodeComment.requestFocus();
                                });
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                        ),
                      )
                    : Expanded(child: ListSkeleton()),
                if (AuthBloc.instance.userModel != null)
                  Container(
                    width: deviceWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    color: Colors.white70,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: Colors.white,
                          backgroundImage: AuthBloc.instance.userModel.avatar !=
                                  null
                              ? CachedNetworkImageProvider(
                                  AuthBloc.instance.userModel.avatar)
                              : AssetImage('assets/image/default_avatar.png'),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: TagUserField(
                            onUpdateTags: (users) {
                              tagUsers = users;
                            },
                            focusNode: _focusNodeComment,
                            controller: _commentC,
                            onSubmitted: _comment,
                            keyboardPadding: widget.keyboardPadding,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    audioCache.play('tab3.mp3');
                                    (isReply)
                                        ? _reply(_commentC.text)
                                        : _comment(_commentC.text);
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 35,
                                      child: Center(child: Icon(Icons.send)))),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              isDense: true,
                              hintText: isReply
                                  ? 'Trả lời ${replyComment?.user?.name ?? ''}'
                                  : 'Viết bình luận.',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              fillColor: ptPrimaryColor(context),
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final Function tapCallBack;
  final Function deleteCallBack;
  final List<ReplyModel> userReplyCache;
  final bool shouldExpand;

  const CommentWidget(
      {Key key,
      this.comment,
      this.tapCallBack,
      this.userReplyCache,
      this.deleteCallBack,
      this.shouldExpand = false})
      : super(key: key);
  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isLike = false;
  PostBloc _postBloc;
  List<ReplyModel> replies = [];
  bool isLoadReply = false;
  bool isExpandReply = false;
  bool canExpand = false;
  List<ReplyModel> userReplyCache;
  final GlobalKey _menuKey = new GlobalKey();
  List<String> contentSplit;

  @override
  void initState() {
    userReplyCache = widget.userReplyCache;
    if (widget.comment.userLikeIds != null)
      _isLike = widget.comment.userLikeIds
              ?.contains(AuthBloc.instance.userModel?.id ?? '') ??
          false;
    String content = widget.comment.content;
    if (widget.comment.userTags != null) {
      widget.comment.userTags.forEach((key, value) {
        content = content.replaceAll('@' + value.trim(), '<tag>$key<tag>');
      });

      contentSplit = content.split('<tag>');
      contentSplit.removeWhere((element) => element.trim() == '');
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _get2InitialReply();
    }
    if (userReplyCache != widget.userReplyCache) {
      userReplyCache = widget.userReplyCache;
      isExpandReply = true;
    }
    // if (replies.length < 3) {
    //   isExpandReply = true;
    // }

    super.didChangeDependencies();
  }

  Future _get2InitialReply() async {
    BaseResponse res;
    if (AuthBloc.instance.userModel == null) {
      res = await _postBloc.getAllReplyByCommentIdGuest(widget.comment.id,
          filter: GraphqlFilter(limit: 2, order: "{updatedAt: 1}"));
    } else {
      if (widget.comment.id != null)
        res = await _postBloc.getAllReplyByCommentId(widget.comment.id,
            filter: GraphqlFilter(limit: 2, order: "{updatedAt: 1}"));
    }
    if (mounted)
      setState(() {
        isLoadReply = false;
      });
    if (res == null) return;
    if (res.isSuccess) {
      if (mounted)
        setState(() {
          replies = res.data;
          if (replies.length > 0) isExpandReply = true;
          if (widget.comment.replyIds.length > 2) canExpand = true;
        });
    } else {
      // showToast('Có lỗi khi lấy dữ liệu', context);
    }
  }

  Future _getReply({GraphqlFilter filter}) async {
    BaseResponse res;
    setState(() {
      isLoadReply = true;
    });

    if (AuthBloc.instance.userModel == null) {
      res = await _postBloc.getAllReplyByCommentIdGuest(widget.comment.id,
          filter: filter);
    } else {
      res = await _postBloc.getAllReplyByCommentId(widget.comment.id,
          filter: filter);
    }
    if (mounted)
      setState(() {
        isLoadReply = false;
      });
    if (res == null) return;
    if (res.isSuccess) {
      if (mounted)
        setState(() {
          replies = res.data;
          isExpandReply = true;
        });
    } else {
      showToast('Có lỗi khi lấy dữ liệu', context);
    }
  }

  _deleteReplyCallBack(String id) async {
    widget.comment.replyIds.remove(id);
    replies.removeWhere((element) => element.id == id);
    userReplyCache.removeWhere((element) => element.id == id);
    setState(() {});
    final res = await _postBloc.deleteReply(id);
    if (!res.isSuccess) showToast(res.errMessage, context);
  }

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
        width: 0,
        height: 0,
        child: PopupMenuButton(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: SizedBox.shrink(),
            key: _menuKey,
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  if (AuthBloc.instance.userModel?.id == widget.comment.userId)
                    PopupMenuItem<String>(
                        child: Text(
                          'Xóa',
                          style: ptBody(),
                        ),
                        value: 'delete'),
                  if (AuthBloc.instance.userModel?.id != widget.comment.userId)
                    PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/report_icon.png",
                              width: 17,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Báo xấu',
                              style: ptBody(),
                            ),
                          ],
                        ),
                        value: 'report'),
                  if (AuthBloc.instance.userModel?.id != widget.comment.userId)
                    PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/messenger_icon.png",
                              width: 17,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Gửi tin nhắn cho ${widget.comment.user.name}',
                              style: ptBody(),
                            ),
                          ],
                        ),
                        value: 'sendMessage'),
                ],
            onSelected: (val) async {
              if (val == 'report')
                showToast('Đã gửi yêu cầu', context, isSuccess: true);
              if (val == 'delete') {
                showConfirmDialog(context, 'Bạn muốn xóa bình luận này?',
                    confirmTap: () {
                  widget.deleteCallBack();
                  FocusScope.of(context).requestFocus(FocusNode());
                }, navigatorKey: navigatorKey);
              }
              if (val == 'sendMessage') {
                audioCache.play('tab3.mp3');
                showWaitingDialog(context);
                await InboxBloc.instance.navigateToChatWith(
                    widget.comment.user.name,
                    widget.comment.user.avatar,
                    DateTime.now(),
                    widget.comment.user.avatar, [
                  AuthBloc.instance.userModel.id,
                  widget.comment.user.id,
                ], [
                  AuthBloc.instance.userModel.avatar,
                  widget.comment.user.avatar,
                ]);
                closeLoading();
              }
            }));
    final List<ReplyModel> mergeReplies = [
      ...replies,
      ...(userReplyCache
              .where((element) =>
                  element.commentId == widget.comment.id &&
                  !replies.any((e) => e.id == element.id))
              ?.toList() ??
          [])
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            width: deviceWidth(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  padding: const EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      ProfileOtherPage.navigate(widget.comment.user);
                      audioCache.play('tab3.mp3');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.comment.user.avatar != null
                            ? CachedNetworkImageProvider(
                                widget.comment.user.avatar)
                            : AssetImage('assets/image/default_avatar.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ptPrimaryColorLight(context),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, left: 10, top: 3, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.comment.user?.name ?? '',
                                    style: roboto_18_700().copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(TimeAgo.timeAgoSinceDate(
                                    DateTime.tryParse(widget.comment.createdAt),
                                  ))
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      if (AuthBloc.instance.userModel == null)
                                        return;
                                      dynamic state = _menuKey.currentState;
                                      state.showButtonMenu();
                                    },
                                  ),
                                  if (AuthBloc.instance.userModel != null)
                                    button,
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(children: [
                            if ((contentSplit?.length ?? 0) < 1)
                              TextSpan(
                                text: (widget.comment.content ?? ''),
                                style: ptBody().copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else
                              ...contentSplit.map((e) {
                                print(contentSplit);
                                if (widget.comment.userTags?.containsKey(e) ??
                                    false) {
                                  return TextSpan(
                                      text: (contentSplit.indexOf(e) == 0
                                              ? ''
                                              : ' ') +
                                          widget.comment.userTags[e] +
                                          (contentSplit.indexOf(e) ==
                                                  contentSplit.length - 1
                                              ? ''
                                              : ' '),
                                      style: ptBody().copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          ProfileOtherPage.navigate(null,
                                              userId: e);
                                        });
                                } else
                                  return TextSpan(
                                    text: (e),
                                    style: ptBody().copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  );
                              }).toList(),
                          ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      audioCache.play('tab3.mp3');
                      if (AuthBloc.instance.userModel == null) {
                        await navigatorKey.currentState.maybePop();
                        LoginPage.navigatePush();
                        return;
                      }
                      setState(() {
                        _isLike = !_isLike;
                      });
                      if (_isLike) {
                        widget.comment.userLikeIds
                            .add(AuthBloc.instance.userModel.id);
                        widget.comment.like++;
                        _postBloc.likeComment(widget.comment.id);
                      } else {
                        if (widget.comment.like > 0) widget.comment.like--;
                        _postBloc.unlikeComment(widget.comment.id);
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Thích",
                            style: roboto_18_700().copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _isLike
                                  ? ptMainColor()
                                  : ptSecondaryColor(context),
                            ),
                          ),
                          Image.asset(
                            "assets/image/like.png",
                            width: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.comment.like.toString(),
                            style: ptTiny(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 1,
                      height: 25,
                      color: HexColor.fromHex("#505050"),
                    ),
                  ),
                ],
              ),
              if (AuthBloc.instance.userModel != null)
                GestureDetector(
                  onTap: () {
                    if (widget.tapCallBack != null) widget.tapCallBack();
                  },
                  child: Text(
                    'Trả lời',
                    style: roboto_18_700().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: ptSecondaryColor(context),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // CustomListTile(
        //   onTap: () {
        //     if (widget.tapCallBack != null) widget.tapCallBack();
        //   },
        //   onLongPress: () {
        //     if (AuthBloc.instance.userModel == null) return;
        //     dynamic state = _menuKey.currentState;
        //     state.showButtonMenu();
        //   },
        //   tileColor: Colors.white,
        //   leading: Container(
        //     width: 36,
        //     padding: EdgeInsets.only(top: 15),
        //     alignment: Alignment.topCenter,
        //     child: GestureDetector(
        //       onTap: () {
        //         ProfileOtherPage.navigate(widget.comment.user);
        //         audioCache.play('tab3.mp3');
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //         ),
        //         child: CircleAvatar(
        //           radius: 18,
        //           backgroundColor: Colors.white,
        //           backgroundImage: widget.comment.user.avatar != null
        //               ? CachedNetworkImageProvider(widget.comment.user.avatar)
        //               : AssetImage('assets/image/default_avatar.png'),
        //         ),
        //       ),
        //     ),
        //   ),
        //   title: GestureDetector(
        //     onTap: () {
        //       ProfileOtherPage.navigate(widget.comment.user);
        //       audioCache.play('tab3.mp3');
        //     },
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text(
        //           widget.comment.user?.name ?? '',
        //           style: roboto_18_700().copyWith(
        //               fontSize: 16, color: HexColor.fromHex("#505050")),
        //         ),
        //       ],
        //     ),
        //   ),
        //   subtitle: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text.rich(TextSpan(children: [
        //         if ((contentSplit?.length ?? 0) < 1)
        //           TextSpan(
        //             text: (widget.comment.content ?? ''),
        //             style: ptBody().copyWith(
        //                 fontWeight: FontWeight.w500, color: Colors.black87),
        //           )
        //         else
        //           ...contentSplit.map((e) {
        //             print(contentSplit);
        //             if (widget.comment.userTags?.containsKey(e) ?? false) {
        //               return TextSpan(
        //                   text: (contentSplit.indexOf(e) == 0 ? '' : ' ') +
        //                       widget.comment.userTags[e] +
        //                       (contentSplit.indexOf(e) ==
        //                               contentSplit.length - 1
        //                           ? ''
        //                           : ' '),
        //                   style: ptBody().copyWith(
        //                       fontWeight: FontWeight.w500, color: Colors.blue),
        //                   recognizer: TapGestureRecognizer()
        //                     ..onTap = () {
        //                       ProfileOtherPage.navigate(null, userId: e);
        //                     });
        //             } else
        //               return TextSpan(
        //                 text: (e),
        //                 style: ptBody().copyWith(
        //                     fontWeight: FontWeight.w500, color: Colors.black87),
        //               );
        //           }).toList(),
        //         TextSpan(
        //           text: '  ' +
        //               Formart.timeByDayViShort(
        //                   DateTime.tryParse(widget.comment.updatedAt)),
        //           style: ptTiny().copyWith(color: Colors.black54),
        //         ),
        //         if (AuthBloc.instance.userModel != null)
        //           TextSpan(
        //             text: '   ' + 'Trả lời',
        //             style: ptTiny(),
        //           ),
        //       ])),
        //     ],
        //   ),
        //   trailing: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       if (AuthBloc.instance.userModel != null) button,
        //       GestureDetector(
        //         onTap: () async {
        //           audioCache.play('tab3.mp3');
        //           if (AuthBloc.instance.userModel == null) {
        //             await navigatorKey.currentState.maybePop();
        //             LoginPage.navigatePush();
        //             return;
        //           }
        //           setState(() {
        //             _isLike = !_isLike;
        //           });
        //           if (_isLike) {
        //             widget.comment.userLikeIds
        //                 .add(AuthBloc.instance.userModel.id);
        //             widget.comment.like++;
        //             _postBloc.likeComment(widget.comment.id);
        //           } else {
        //             if (widget.comment.like > 0) widget.comment.like--;
        //             _postBloc.unlikeComment(widget.comment.id);
        //           }
        //           setState(() {});
        //         },
        //         child: Row(mainAxisSize: MainAxisSize.min, children: [
        //           Icon(
        //             MdiIcons.thumbUp,
        //             size: 17,
        //             color: _isLike ? ptPrimaryColor(context) : Colors.grey[200],
        //           ),
        //           SizedBox(width: 4),
        //           Text(
        //             widget.comment.like.toString(),
        //             style: ptTiny(),
        //           )
        //         ]),
        //       ),
        //     ],
        //   ),
        // ),
        isExpandReply || widget.shouldExpand
            ? Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Column(
                  children: mergeReplies
                      .map(
                        (e) => ReplyWidget(
                            reply: e,
                            deleteCallBack: () {
                              _deleteReplyCallBack(e.id);
                            }),
                      )
                      .toList(),
                ),
              )
            : SizedBox.shrink(),
        if ((widget.comment?.replyIds?.length ?? 0) > 0)
          Padding(
            padding: const EdgeInsets.only(left: 65),
            child: GestureDetector(
              onTap: () {
                audioCache.play('tab3.mp3');
                if (isExpandReply) {
                  if (canExpand) {
                    setState(() {
                      isExpandReply = false;
                      canExpand = false;
                    });
                    _getReply(
                        filter:
                            GraphqlFilter(limit: 40, order: "{updatedAt: 1}"));
                  } else
                    setState(() {
                      isExpandReply = false;
                    });
                } else {
                  if (replies.length > 0) {
                    setState(() {
                      isExpandReply = true;
                    });
                  } else {
                    _getReply(
                        filter:
                            GraphqlFilter(limit: 40, order: "{updatedAt: 1}"));
                  }
                }
              },
              child: SizedBox(
                height: 18,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isExpandReply
                            ? (canExpand
                                ? 'Xem ${widget.comment.replyIds.length - 2} phản hồi'
                                : 'Rút gọn')
                            : 'Xem ${widget.comment.replyIds.length} phản hồi',
                        style: ptSmall().copyWith(color: Colors.black54),
                      ),
                      Icon(
                        isExpandReply && !canExpand
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 18,
                      ),
                      SizedBox(width: 3),
                      if (isLoadReply)
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                            strokeWidth: 2.5,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ReplyWidget extends StatefulWidget {
  final ReplyModel reply;
  final Function deleteCallBack;

  const ReplyWidget({Key key, this.reply, this.deleteCallBack})
      : super(key: key);
  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  PostBloc _postBloc;
  final GlobalKey _menuKey = new GlobalKey();
  List<String> contentSplit;

  bool _isLike = false;

  @override
  void initState() {
    String content = widget.reply.content;
    if (widget.reply.userTags != null) {
      widget.reply.userTags.forEach((key, value) {
        content = content.replaceAll('@' + value.trim(), '<tag>$key<tag>');
      });

      contentSplit = content.split('<tag>');
      contentSplit.removeWhere((element) => element.trim() == '');
    }

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
    final button = SizedBox(
        width: 0,
        height: 0,
        child: PopupMenuButton(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: SizedBox.shrink(),
            key: _menuKey,
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  if (AuthBloc.instance.userModel?.id == widget.reply.user.id)
                    PopupMenuItem<String>(
                        child: Text(
                          'Xóa',
                          style: ptBody(),
                        ),
                        value: 'delete'),
                  if (AuthBloc.instance.userModel?.id != widget.reply.user.id)
                    PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/report_icon.png",
                              width: 17,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Báo xấu',
                              style: ptBody(),
                            ),
                          ],
                        ),
                        value: 'report'),
                  if (AuthBloc.instance.userModel?.id != widget.reply.user.id)
                    PopupMenuItem<String>(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/image/messenger_icon.png",
                              width: 17,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Gửi tin nhắn cho ${widget.reply.user.name}',
                              style: ptBody(),
                            ),
                          ],
                        ),
                        value: 'sendMessage'),
                ],
            onSelected: (val) {
              if (val == 'report')
                showToast('Đã gửi yêu cầu', context, isSuccess: true);
              if (val == 'delete') {
                showConfirmDialog(context, 'Bạn muốn xóa bình luận này?',
                    confirmTap: () {
                  widget.deleteCallBack();
                  FocusScope.of(context).requestFocus(FocusNode());
                }, navigatorKey: navigatorKey);
              }
            }));

    return widget.reply != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPress: () {
                  audioCache.play('tab3.mp3');
                  if (AuthBloc.instance.userModel == null) return;
                  dynamic state = _menuKey.currentState;
                  state?.showButtonMenu();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: deviceWidth(context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              padding: const EdgeInsets.only(top: 5),
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () {
                                  ProfileOtherPage.navigate(widget.reply.user);
                                  audioCache.play('tab3.mp3');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white,
                                    backgroundImage: widget.reply.user.avatar !=
                                            null
                                        ? CachedNetworkImageProvider(
                                            widget.reply.user.avatar)
                                        : AssetImage(
                                            'assets/image/default_avatar.png'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ptPrimaryColorLight(context),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0,
                                      left: 10,
                                      top: 3,
                                      right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.reply.user?.name ?? '',
                                                style: roboto_18_700().copyWith(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(TimeAgo.timeAgoSinceDate(
                                                  DateTime.tryParse(
                                                      widget.reply.updatedAt)))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.more_vert),
                                                onPressed: () {
                                                  if (AuthBloc
                                                          .instance.userModel ==
                                                      null) return;
                                                  dynamic state =
                                                      _menuKey.currentState;
                                                  state.showButtonMenu();
                                                },
                                              ),
                                              if (AuthBloc.instance.userModel !=
                                                  null)
                                                button,
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text.rich(TextSpan(children: [
                                        if ((contentSplit?.length ?? 0) < 1)
                                          TextSpan(
                                            text: (widget.reply.content ?? ''),
                                            style: ptBody().copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        else
                                          ...contentSplit.map((e) {
                                            print(contentSplit);
                                            if (widget.reply.userTags
                                                    ?.containsKey(e) ??
                                                false) {
                                              return TextSpan(
                                                  text: (contentSplit
                                                                  .indexOf(e) ==
                                                              0
                                                          ? ''
                                                          : ' ') +
                                                      widget.reply.userTags[e] +
                                                      (contentSplit
                                                                  .indexOf(e) ==
                                                              contentSplit
                                                                      .length -
                                                                  1
                                                          ? ''
                                                          : ' '),
                                                  style: ptBody().copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.blue),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          ProfileOtherPage
                                                              .navigate(null,
                                                                  userId: e);
                                                        });
                                            } else
                                              return TextSpan(
                                                text: (e),
                                                style: ptBody().copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              );
                                          }).toList(),
                                      ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                      ),
                      child: Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  audioCache.play('tab3.mp3');
                                  if (AuthBloc.instance.userModel == null) {
                                    await navigatorKey.currentState.maybePop();
                                    LoginPage.navigatePush();
                                    return;
                                  }
                                  setState(() {
                                    _isLike = !_isLike;
                                  });
                                  // if (_isLike) {
                                  //   widget.comment.userLikeIds
                                  //       .add(AuthBloc.instance.userModel.id);
                                  //   widget.comment.like++;
                                  //   _postBloc.likeComment(widget.comment.id);
                                  // } else {
                                  //   if (widget.comment.like > 0)
                                  //     widget.comment.like--;
                                  //   _postBloc.unlikeComment(widget.comment.id);
                                  // }
                                  // setState(() {});
                                },
                                child: Container(
                                  height: 20,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Thích",
                                        style: roboto_18_700().copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          color: _isLike
                                              ? ptPrimaryColor(context)
                                              : ptSecondaryColor(context),
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/image/like.png",
                                        width: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "0",
                                        style: ptTiny(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 1,
                                  height: 25,
                                  color: HexColor.fromHex("#505050"),
                                ),
                              ),
                            ],
                          ),
                          if (AuthBloc.instance.userModel != null)
                            GestureDetector(
                              // onTap: () {
                              //   if (widget.tapCallBack != null) widget.tapCallBack();
                              // },
                              child: Text(
                                'Trả lời',
                                style: ptTiny(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
// child: Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //       ),
                //       child: GestureDetector(
                //         onTap: () {
                //           audioCache.play('tab3.mp3');
                //           ProfileOtherPage.navigate(widget.reply.user);
                //         },
                //         child: CircleAvatar(
                //           radius: 13,
                //           backgroundColor: Colors.white,
                //           backgroundImage: widget.reply.user?.avatar != null
                //               ? CachedNetworkImageProvider(widget.reply.user.avatar)
                //               : AssetImage('assets/image/default_avatar.png'),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               ProfileOtherPage.navigate(widget.reply.user);
                //               audioCache.play('tab3.mp3');
                //             },
                //             child: Text(widget.reply.user?.name ?? '',
                //                 style: roboto_18_700().copyWith(
                //                     fontSize: 16, color: HexColor.fromHex("#505050"))),
                //           ),
                //           Text.rich(
                //             TextSpan(children: [
                //               if ((contentSplit?.length ?? 0) < 1)
                //                 TextSpan(
                //                   text: (widget.reply.content ?? ''),
                //                   style: ptBody().copyWith(
                //                       fontWeight: FontWeight.w500,
                //                       color: Colors.black87),
                //                 )
                //               else
                //                 ...contentSplit.map((e) {
                //                   print(contentSplit);
                //                   if (widget.reply.userTags?.containsKey(e) ?? false) {
                //                     return TextSpan(
                //                         text:
                //                             (contentSplit.indexOf(e) == 0 ? '' : ' ') +
                //                                 widget.reply.userTags[e] +
                //                                 (contentSplit.indexOf(e) ==
                //                                         contentSplit.length - 1
                //                                     ? ''
                //                                     : ' '),
                //                         style: ptBody().copyWith(
                //                             fontWeight: FontWeight.w500,
                //                             color: Colors.blue),
                //                         recognizer: TapGestureRecognizer()
                //                           ..onTap = () {
                //                             ProfileOtherPage.navigate(null, userId: e);
                //                           });
                //                   } else
                //                     return TextSpan(
                //                       text: (e),
                //                       style: ptBody().copyWith(
                //                           fontWeight: FontWeight.w500,
                //                           color: Colors.black87),
                //                     );
                //                 }).toList(),
                //               TextSpan(
                //                 text: '  ' +
                //                     Formart.timeByDayViShort(
                //                         DateTime.tryParse(widget.reply.updatedAt)),
                //                 style: ptTiny().copyWith(color: Colors.black54),
                //               ),
                //             ]),
                //           ),
                //         ],
                //       ),
                //     ),
                //     PopupMenuButton(
                //         child: SizedBox.shrink(),
                //         key: _menuKey,
                //         itemBuilder: (_) => <PopupMenuItem<String>>[
                //               if (AuthBloc.instance.userModel?.id ==
                //                   widget.reply.userId)
                //                 PopupMenuItem<String>(
                //                     child: Text(
                //                       'Xóa',
                //                       style: ptBody(),
                //                     ),
                //                     value: 'delete'),
                //               if (AuthBloc.instance.userModel?.id !=
                //                   widget.reply.userId)
                //                 PopupMenuItem<String>(
                //                     child: Text(
                //                       'Báo xấu',
                //                       style: ptBody(),
                //                     ),
                //                     value: 'report'),
                //             ],
                //         onSelected: (val) {
                //           if (val == 'report')
                //             showToast('Đã gửi yêu cầu', context, isSuccess: true);
                //           if (val == 'delete') {
                //             showConfirmDialog(context, 'Bạn muốn xóa bình luận này?',
                //                 confirmTap: () {
                //               widget.deleteCallBack();
                //               FocusScope.of(context).requestFocus(FocusNode());
                //             }, navigatorKey: navigatorKey);
                //           }
                //         })
                //   ],
                // ),
                ),
          )
        : SizedBox();
  }
}
