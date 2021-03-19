import 'dart:async';

import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/model/reply.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/media_post.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/share/import.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:graphql/client.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;
  final MediaPost mediaPost;

  const CommentPage({Key key, this.post, this.mediaPost}) : super(key: key);

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
        updatedAt: DateTime.now().toIso8601String()));
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createComment(text,
        postId: widget.post?.id, mediaPostId: widget.mediaPost?.id);
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
        userId: AuthBloc.instance.userModel.uid,
        commentId: replyComment.id,
        user: AuthBloc.instance.userModel,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String()));
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createReply(text, replyComment.id);
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      final index = localReplies
          .indexWhere((element) => element.createdAt == res.data.createdAt);
      if (index >= 0) {
        localReplies[index] = res.data;
      }

      comments
          .firstWhere((element) => element.id == replyComment.id)
          .replyIds
          .add(localReplies[index].id);
      if (mounted)
        setState(() {
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
                          separatorBuilder: (context, index) =>
                              SizedBox.shrink(),
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
                          child: TextField(
                            focusNode: _focusNodeComment,
                            controller: _commentC,
                            maxLines: null,
                            // maxLength: 200,
                            onSubmitted: _comment,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
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
                              fillColor: ptSecondaryColor(context),
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
  List<ReplyModel> userReplyCache;
  final GlobalKey _menuKey = new GlobalKey();

  @override
  void initState() {
    userReplyCache = widget.userReplyCache;
    if (widget.comment.userLikeIds != null)
      _isLike = widget.comment.userLikeIds
              ?.contains(AuthBloc.instance.userModel?.id ?? '') ??
          false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    if (userReplyCache != widget.userReplyCache) {
      userReplyCache = widget.userReplyCache;
      isExpandReply = true;
    }
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
        width: 0,
        height: 0,
        child: PopupMenuButton(
            padding: EdgeInsets.zero,
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
                        child: Text(
                          'Báo xấu',
                          style: ptBody(),
                        ),
                        value: 'report'),
                ],
            onSelected: (val) {
              if (val == 'report') showToast('Đã gửi yêu cầu', context, isSuccess: true);
              if (val == 'delete') {
                showConfirmDialog(context, 'Bạn muốn xóa bình luận này?',
                    confirmTap: () {
                  widget.deleteCallBack();
                }, navigatorKey: navigatorKey);
              }
            }));
    final List<ReplyModel> mergeReplies = [
      ...replies,
      ...(userReplyCache
              .where((element) => element.commentId == widget.comment.id)
              ?.toList() ??
          [])
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          onTap: () {
            if (widget.tapCallBack != null) widget.tapCallBack();
          },
          onLongPress: () {
            if (AuthBloc.instance.userModel == null) return;
            dynamic state = _menuKey.currentState;
            state.showButtonMenu();
          },
          tileColor: Colors.white,
          leading: Container(
            width: 36,
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => ProfileOtherPage.navigate(widget.comment.user),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.comment.user.avatar != null
                      ? CachedNetworkImageProvider(widget.comment.user.avatar)
                      : AssetImage('assets/image/default_avatar.png'),
                ),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () => ProfileOtherPage.navigate(widget.comment.user),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.comment.user?.name ?? '',
                  style: ptBody().copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 3,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: widget.comment.content ?? '',
                  style: ptBody().copyWith(
                      fontWeight: FontWeight.w500, color: Colors.black87),
                ),
                TextSpan(
                  text: '  ' +
                      Formart.timeByDayViShort(
                          DateTime.tryParse(widget.comment.updatedAt)),
                  style: ptTiny().copyWith(color: Colors.black54),
                ),
                if (AuthBloc.instance.userModel != null)
                  TextSpan(
                    text: '   ' + 'Trả lời',
                    style: ptTiny(),
                  ),
              ])),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (AuthBloc.instance.userModel != null) button,
              GestureDetector(
                onTap: () async {
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
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    MdiIcons.thumbUp,
                    size: 17,
                    color: _isLike ? ptPrimaryColor(context) : Colors.grey[200],
                  ),
                  SizedBox(width: 4),
                  Text(
                    widget.comment.like.toString(),
                    style: ptTiny(),
                  )
                ]),
              ),
            ],
          ),
        ),
        isExpandReply || widget.shouldExpand
            ? Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Column(
                  children: mergeReplies
                      .map(
                        (e) => ReplyWidget(
                          reply: e,
                        ),
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
                if (isExpandReply) {
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
                            ? 'Rút gọn'
                            : 'Xem ${widget.comment.replyIds.length} phản hồi',
                        style: ptSmall().copyWith(color: Colors.black54),
                      ),
                      Icon(
                        isExpandReply
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 18,
                      ),
                      if (isLoadReply)
                        SizedBox(
                          height: 16,
                          width: 16,
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

  const ReplyWidget({Key key, this.reply}) : super(key: key);
  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  bool _isLike = false;
  PostBloc _postBloc;

  @override
  void initState() {
    // if (widget.reply.userLikeIds != null)
    //   _isLike = widget.reply.userLikeIds
    //           ?.contains(AuthBloc.instance.userModel?.id ?? '') ??
    //       false;

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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.white,
                backgroundImage: widget.reply.user?.avatar != null
                    ? CachedNetworkImageProvider(widget.reply.user.avatar)
                    : AssetImage('assets/image/default_avatar.png'),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reply.user?.name ?? '',
                style: ptBody().copyWith(fontWeight: FontWeight.w500),
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: widget.reply.content ?? '',
                  style: ptBody().copyWith(
                      fontWeight: FontWeight.w500, color: Colors.black87),
                ),
                TextSpan(
                  text: '  ' +
                      Formart.timeByDayViShort(
                          DateTime.tryParse(widget.reply.updatedAt)),
                  style: ptTiny().copyWith(color: Colors.black54),
                ),
              ])),
            ],
          )
        ],
      ),
    );
  }
}
