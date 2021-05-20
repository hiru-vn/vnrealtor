import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/modules/post/media_post_widget.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/post/post_google_map.dart';
import 'package:datcao/modules/post/report_post_page.dart';
import 'package:datcao/modules/post/search_post_page.dart';
import 'package:datcao/modules/post/update_post_page.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comment_page.dart';

class PostWidget extends StatefulWidget {
  final Function commentCallBack;
  final PostModel post;
  PostWidget(this.post, {this.commentCallBack});
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final GlobalKey<State<StatefulWidget>> moreBtnKey =
      GlobalKey<State<StatefulWidget>>();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: deviceWidth(context),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(12).copyWith(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.post.isPage
                          ? PageDetail.navigate(widget.post?.page)
                          : ProfileOtherPage.navigate(widget.post?.user);
                    },
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.post.isPage
                          ? widget.post.page.avartar != null
                              ? CachedNetworkImageProvider(
                                  widget.post.page.avartar)
                              : AssetImage('assets/image/default_avatar.png')
                          : widget.post?.user?.id ==
                                  AuthBloc.instance?.userModel?.id
                              ? ((AuthBloc.instance.userModel.avatar != null &&
                                      AuthBloc.instance.userModel.avatar !=
                                          'null')
                                  ? CachedNetworkImageProvider(
                                      AuthBloc.instance.userModel.avatar)
                                  : AssetImage(
                                      'assets/image/default_avatar.png'))
                              : ((widget.post?.user?.avatar != null &&
                                      widget.post?.user?.avatar != 'null')
                                  ? CachedNetworkImageProvider(
                                      widget.post?.user?.avatar)
                                  : AssetImage(
                                      'assets/image/default_avatar.png')),
                      child: VerifiedIcon(
                        widget.post?.user?.role,
                        10,
                        isPage: widget.post.isPage,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              widget.post.isPage
                                  ? PageDetail.navigate(widget.post?.page)
                                  : ProfileOtherPage.navigate(
                                      widget.post?.user);
                            },
                            child: Text(
                              widget.post.isPage
                                  ? widget.post.page.name
                                  : widget.post?.user?.name ?? '',
                              style: ptTitle(),
                            ),
                          ),
                          if (!widget.post.isPage)
                            SizedBox(
                              width: 5,
                            ),
                          if (!widget.post.isPage)
                            if ([UserRole.agent, UserRole.company]
                                .contains(UserBloc.getRole(widget.post?.user)))
                              CustomTooltip(
                                margin: EdgeInsets.only(top: 0),
                                message: 'Tài khoản xác thực',
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue[600],
                                  ),
                                  padding: EdgeInsets.all(1.3),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 11,
                                  ),
                                ),
                              ),
                          SizedBox(width: 5),
                          if (!widget.post.isPage)
                            CustomTooltip(
                              message: 'Điểm tương tác',
                              child: Text(
                                widget.post?.user?.reputationScore.toString(),
                                style: ptSmall(),
                              ),
                            ),
                          SizedBox(width: 1),
                          if (!widget.post.isPage)
                            CustomTooltip(
                              message: 'Điểm tương tác',
                              child: SizedBox(
                                height: 13,
                                width: 13,
                                child: Image.asset('assets/image/ip.png'),
                              ),
                            ),
                          if (widget.post.isPage)
                            Container(
                              child: Text(
                                "bởi ${widget.post.user.name}",
                                style: ptTiny(),
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Text(
                            DateTime.tryParse(widget.post?.createdAt)
                                        .add(Duration(days: 1))
                                        .compareTo(DateTime.now()) <
                                    0
                                ? (Formart.formatToDateTime(DateTime.tryParse(
                                        widget.post?.createdAt)) ??
                                    '')
                                : Formart.timeByDayVi(
                                    DateTime.tryParse(widget.post?.createdAt)),
                            style: ptTiny().copyWith(color: Colors.black54),
                          ),
                          SizedBox(width: 5),
                          if (widget.post.distance != null) ...[
                            Container(
                                height: 4,
                                width: 4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black26)),
                            SizedBox(width: 5),
                            Text(
                              widget.post.distance.toStringAsFixed(1) + ' km',
                              style: ptTiny().copyWith(color: Colors.black54),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  // GestureDetector(
                  //     onTap: () {
                  //       showToast('Đã copy link bài viết', context,
                  //           isSuccess: true);
                  //       Clipboard.setData(
                  //         new ClipboardData(
                  //             text: widget.post.dynamicLink.shortLink),
                  //       );
                  //     },
                  //     child:
                  //         SizedBox(width: 30, child: Icon(MdiIcons.fileLink))),
                  if (AuthBloc.instance.userModel != null)
                    Center(
                      child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          child:
                              SizedBox(width: 30, child: Icon(Icons.more_vert)),
                          itemBuilder: (_) => <PopupMenuItem<String>>[
                                if (widget.post.userId !=
                                    AuthBloc.instance.userModel?.id) ...[
                                  PopupMenuItem(
                                    child: Text('Liên hệ'),
                                    value: 'Liên hệ',
                                  ),
                                  ([
                                    UserRole.admin,
                                    UserRole.admin_post,
                                    UserRole.manager
                                  ].contains(UserBloc.getRole(
                                          AuthBloc.instance.userModel)))
                                      ? PopupMenuItem(
                                          child: Text('Ẩn bài'),
                                          value: 'Ẩn bài',
                                        )
                                      : PopupMenuItem(
                                          child: Text('Báo cáo'),
                                          value: 'Báo cáo',
                                        ),
                                ] else ...[
                                  PopupMenuItem(
                                    child: Text('Xóa bài'),
                                    value: 'Xóa bài',
                                  ),
                                  PopupMenuItem(
                                      child: Text('Sửa bài'), value: 'Sửa bài'),
                                ],
                                PopupMenuItem(
                                    child: Text('Copy link'),
                                    value: 'Copy link'),
                              ],
                          onSelected: (val) async {
                            if (val == 'Copy link') {
                              showToast('Đã copy link bài viết', context,
                                  isSuccess: true);
                              Clipboard.setData(
                                new ClipboardData(
                                    text: widget.post.dynamicLink.shortLink),
                              );
                            }
                            if (val == 'Liên hệ') {
                              showWaitingDialog(context);
                              await InboxBloc.instance.navigateToChatWith(
                                  widget.post.user.name,
                                  widget.post.user.avatar,
                                  DateTime.now(),
                                  widget.post.user.avatar, [
                                AuthBloc.instance.userModel.id,
                                widget.post.user.id,
                              ], [
                                AuthBloc.instance.userModel.avatar,
                                widget.post.user.avatar,
                              ]);
                              navigatorKey.currentState.maybePop();
                            }
                            if (val == 'Báo cáo') {
                              showReport(widget.post, context);
                            }
                            if (val == 'Xóa bài') {
                              final confirm = await showConfirmDialog(context,
                                  'Vui lòng xác nhận xóa bài viết này.',
                                  confirmTap: () {},
                                  navigatorKey: navigatorKey);
                              if (!confirm) return;
                              final res =
                                  await _postBloc.deletePost(widget.post.id);
                              if (res.isSuccess) {
                              } else {
                                showToast(res.errMessage, context);
                              }
                            }
                            if (val == 'Ẩn bài') {
                              final res =
                                  await _postBloc.hidePost(widget.post.id);
                              if (res.isSuccess) {
                                showToast(
                                    'Đã ẩn, bài viết này sẽ không hiện trên feed của tất cả user khác',
                                    context,
                                    isSuccess: true);
                              } else {
                                showToast(res.errMessage, context);
                              }
                            }
                            if (val == 'Sửa bài') {
                              final res =
                                  await UpdatePostPage.navigate(widget.post);
                              if (res == true) {
                                await _postBloc.getNewFeed(
                                    filter: GraphqlFilter(
                                        limit: 10, order: "{updatedAt: -1}"));
                                return;
                              }
                            }
                          }),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15).copyWith(top: 0, bottom: 5),
              child: GestureDetector(
                onTap: () {
                  PostDetail.navigate(widget.post);
                },
                child: Linkify(
                  onOpen: (link) async {
                    // if (Validator.isUrl(link.url)) {
                    if (await canLaunch(link.url)) {
                      await launch(link.url);
                    } else {
                      showToastNoContext('Đường dẫn hết hiệu lực');
                    }
                    // }
                  },
                  text: (widget.post?.content?.trim() ?? ''),
                  // trimLines: 5,
                  // trimLength: 1000,
                  style: ptBody().copyWith(color: Colors.black87),
                  textAlign: TextAlign.start,
                  // colorClickableText: Colors.pink,
                  // trimMode: TrimMode.Length,
                  // trimCollapsedText: 'Xem thêm',
                  // trimExpandedText: 'Rút gọn',
                  // moreStyle: TextStyle(
                  //   fontSize: 14,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),
              ),
            ),
            if (widget.post.tagUsers != null && widget.post.tagUsers.length > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(bottom: 7),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Cùng với: ',
                      style: ptSmall().copyWith(color: Colors.black)),
                  ...widget.post.tagUsers.map(
                    (e) => TextSpan(
                        text: '${e.name}, ',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => ProfileOtherPage.navigate(e),
                        style: ptSmall().copyWith(fontStyle: FontStyle.italic)),
                  )
                ])),
              ),
            if ((widget.post?.hashTag?.length ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  children: widget.post.hashTag
                      .map((e) => GestureDetector(
                            onTap: () {
                              SearchPostPage.navigate(hashTag: e);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5).copyWith(top: 0),
                              child: Text(e),
                            ),
                          ))
                      .toList(),
                ),
              ),
            if ((widget.post?.mediaPosts?.length ?? 0) > 0)
              Stack(
                children: [
                  GroupMediaPostWidget(
                    posts: widget.post?.mediaPosts,
                  ),
                  if (widget.post.locationLat != null &&
                      widget.post.locationLong != null)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await showGoogleMapPoint(
                                context,
                                widget.post.locationLat,
                                widget.post.locationLong,
                                widget.post.polygonPoints);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Text(
                            'Xem vị trí',
                            style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: Row(
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: ptPrimaryColor(context),
            //         ),
            //         padding: EdgeInsets.all(4),
            //         child: Icon(
            //           MdiIcons.thumbUp,
            //           size: 11,
            //           color: Colors.white,
            //         ),
            //       ),
            //       SizedBox(
            //         width: 5,
            //       ),
            //       Text(
            //         widget.post?.like?.toString() ?? '0',
            //         style: ptSmall(),
            //       ),
            //       Spacer(),
            //       GestureDetector(
            //         onTap: () {
            //           showComment(widget.post);
            //         },
            //         child: Text(
            //           '${widget.post?.commentIds?.length.toString() ?? '0'} bình luận',
            //           style: ptSmall(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    if (AuthBloc.instance.userModel == null) {
                      LoginPage.navigatePush();
                      return;
                    }
                    widget.post.isUserLike = !widget.post.isUserLike;

                    if (widget.post.isUserLike) {
                      _postBloc.likePost(widget.post);
                    } else {
                      _postBloc.unlikePost(widget.post);
                    }
                    setState(() {});
                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !widget.post.isUserLike
                            ? Icon(
                                MdiIcons.heartOutline,
                                size: 22,
                                color: ptPrimaryColor(context),
                              )
                            : Icon(
                                MdiIcons.heart,
                                size: 22,
                                color: Colors.red,
                              ),
                        SizedBox(
                          height: 3,
                        ),
                        Text('${widget.post.like} lượt thích',
                            style: ptTiny()
                                .copyWith(color: ptPrimaryColor(context))),
                      ]),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    // if (AuthBloc.instance.userModel == null) {
                    //   LoginPage.navigatePush();
                    //   return;
                    // }
                    if (widget.commentCallBack != null)
                      widget.commentCallBack();
                    else
                      showComment(widget.post);
                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.chatOutline,
                          color: ptPrimaryColor(context),
                          size: 22,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text('${widget.post.numberOfComment} bình luận',
                            style: ptTiny()
                                .copyWith(color: ptPrimaryColor(context))),
                      ]),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    String content = widget.post.dynamicLink?.shortLink ?? '';
                    content = content + '\n' + widget.post.content;
                    shareTo(context,
                        content: content,
                        image: widget.post.mediaPosts
                            .where((element) => element.type == 'PICTURE')
                            .map((e) => e.url)
                            .toList(),
                        video: widget.post.mediaPosts
                            .where((element) => element.type == 'VIDEO')
                            .map((e) => e.url)
                            .toList());
                    // shareStringTo(context, content);
                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.shareOutline,
                          color: ptPrimaryColor(context),
                          size: 22,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text('${widget.post.share} chia sẻ',
                            style: ptTiny()
                                .copyWith(color: ptPrimaryColor(context))),
                      ]),
                ),
                Spacer(),
                if (AuthBloc.instance.userModel != null)
                  GestureDetector(
                    onTap: () async {
                      if (AuthBloc.instance.userModel?.savedPostIds
                              ?.contains(widget.post.id) ??
                          false) {
                        showToast('Bài viết đã được lưu', context,
                            isSuccess: true);
                        return;
                      }

                      final res = await _postBloc.savePost(widget.post);
                      if (res.isSuccess) {
                      } else {
                        setState(() {
                          _postBloc.myPosts.remove(widget.post);
                        });
                        showToast(res.errMessage, context);
                      }
                    },
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !(AuthBloc.instance.userModel?.savedPostIds
                                      ?.contains(widget.post.id) ??
                                  false)
                              ? Icon(
                                  MdiIcons.bookmarkOutline,
                                  color: ptPrimaryColor(context),
                                  size: 22,
                                )
                              : Icon(
                                  MdiIcons.bookmark,
                                  color: ptPrimaryColor(context),
                                  size: 22,
                                ),
                          SizedBox(
                            height: 3,
                          ),
                          Text('Lưu',
                              style: ptTiny()
                                  .copyWith(color: ptPrimaryColor(context))),
                        ]),
                  ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),

            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  showComment(PostModel postModel) {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
              height: deviceHeight(context) - kToolbarHeight - 15,
              child: CommentPage(
                  post: postModel,
                  keyboardPadding: MediaQuery.of(context).viewInsets.bottom));
        });
  }
}

class PostSmallWidget extends StatefulWidget {
  final Function commentCallBack;
  final PostModel post;
  PostSmallWidget(this.post, {this.commentCallBack});
  @override
  _PostSmallWidgetState createState() => _PostSmallWidgetState();
}

class _PostSmallWidgetState extends State<PostSmallWidget> {
  final GlobalKey<State<StatefulWidget>> moreBtnKey =
      GlobalKey<State<StatefulWidget>>();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget thumbNail;
    if (widget.post.mediaPosts.any((element) => element.type == 'PICTURE')) {
      final String url = widget.post.mediaPosts
          .firstWhere((element) => element.type == 'PICTURE')
          .url;
      thumbNail = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: deviceWidth(context) / 3.5,
            height: deviceWidth(context) / 4.8,
            child: Image(
              image: CachedNetworkImageProvider(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      thumbNail = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: deviceWidth(context) / 3.5,
            height: deviceWidth(context) / 4.8,
            child: Image.asset(
              'assets/image/video_holder.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 15, bottom: 10),
        child: Container(
            width: deviceWidth(context),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      PostDetail.navigate(widget.post);
                    },
                    child: thumbNail),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        PostDetail.navigate(widget.post);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.content.trim().length > 0
                                ? widget.post.content.trim()[0].toUpperCase() +
                                    widget.post.content
                                        .trim()
                                        .substring(1)
                                        .replaceAll('\n', ' ')
                                        .replaceAll('  ', '')
                                : '',
                            style: ptTitle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3),
                          Text(
                            '${widget.post.like} thích • ${widget.post.commentIds.length} bình luận',
                            style: ptBody().copyWith(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 3),
                          Text.rich(
                            TextSpan(children: [
                              // TextSpan(text: 'Đăng bởi '),
                              TextSpan(
                                  text: '${widget.post.user.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54)),
                              TextSpan(
                                  text:
                                      ' • ${Formart.timeByDayVi(DateTime.tryParse(widget.post.updatedAt)).replaceAll(' trước', '')}'),
                            ]),
                            style: ptTiny().copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      )),
                ),
                Center(
                  child: PopupMenuButton(
                      key: moreBtnKey,
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                            PopupMenuItem(
                              child: Text('Bỏ lưu'),
                              value: 'Bỏ lưu',
                            ),
                          ],
                      onSelected: (val) async {
                        if (val == 'Bỏ lưu') {
                          final res = await _postBloc.unsavePost(widget.post);
                          if (res.isSuccess) {
                          } else {
                            showToast(res.errMessage, context);
                          }
                          navigatorKey.currentState.maybePop();
                        }
                      },
                      child: SizedBox(width: 30, child: Icon(Icons.more_vert))),
                )
              ],
            )),
      ),
    );
  }

  showComment(PostModel postModel) {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
              height: deviceHeight(context) - kToolbarHeight - 15,
              child: CommentPage(
                  post: postModel,
                  keyboardPadding: MediaQuery.of(context).viewInsets.bottom));
        });
  }
}
