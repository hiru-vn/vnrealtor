import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/modules/post/media_post_widget.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/post/post_google_map.dart';
import 'package:datcao/modules/post/report_post_page.dart';
import 'package:datcao/modules/post/search_post_page.dart';
import 'package:datcao/modules/post/share_post.dart';
import 'package:datcao/modules/post/update_post_page.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/function/time_ago.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comment_page.dart';

class PostWidget extends StatefulWidget {
  final Function commentCallBack;
  final bool isSharedPost;
  final PostModel post;
  final bool isInDetailPage;
  PostWidget(this.post,
      {this.commentCallBack,
      this.isSharedPost = false,
      this.isInDetailPage = false});
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final GlobalKey<State<StatefulWidget>> moreBtnKey =
      GlobalKey<State<StatefulWidget>>();
  PostBloc _postBloc;
  PostModel _sharePost;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      if (widget.post.postShareId != null) {
        _postBloc.getOnePost(widget.post.postShareId).then((res) {
          if (res.isSuccess)
            setState(() {
              _sharePost = res.data;
            });
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PostWidget oldWidget) {
    if (widget.post.postShareId != null && _sharePost == null) {
      _postBloc.getOnePost(widget.post.postShareId).then((res) {
        if (res.isSuccess)
          setState(() {
            _sharePost = res.data;
          });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.isSharedPost ? 0 : 8),
      child: Container(
        width: deviceWidth(context),
        color: ptPrimaryColor(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.all(12).copyWith(
                    bottom: widget.post.postShareId != null ? 0 : 8,
                    top: widget.isSharedPost ? 0 : 12),
                child: widget.post.group == null
                    ? _buildUserOrPageTile()
                    : _buildGroupTile()),
            if (widget.post.isBlock)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: deviceWidth(context),
                height: 150,
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                  child: Text(
                    'Bài viết đã bị xoá do vi phạm quy chuẩn cộng đồng',
                    style: ptBigBody().copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.all(15).copyWith(
                    top: 0, bottom: widget.post.postShareId != null ? 0 : 5),
                child: Container(
                  width: deviceWidth(context),
                  child: GestureDetector(
                    onTap: () {
                      audioCache.play('tab3.mp3');
                      if (!widget.isInDetailPage)
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
                      style: roboto(context)
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 15),
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
              ),
              if (widget.post.tagUsers != null &&
                  widget.post.tagUsers.length > 0)
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
                          style:
                              ptSmall().copyWith(fontStyle: FontStyle.italic)),
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
                                audioCache.play('tab3.mp3');
                                SearchPostPage.navigate(hashTag: e);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(5).copyWith(top: 0),
                                child: Text(e),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              if (widget.post.postShareId != null && _sharePost == null)
                SizedBox(
                    width: deviceWidth(context),
                    height: 170,
                    child: kLoadingSpinner)
              else if (widget.post.postShareId != null && _sharePost != null)
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5)),
                    child: Transform.scale(
                        scale: 0.95,
                        child: PostWidget(_sharePost, isSharedPost: true)))
              else if ((widget.post?.mediaPosts?.length ?? 0) > 0)
                Stack(
                  children: [
                    GroupMediaPostWidget(
                      posts: widget.post?.mediaPosts,
                      autoPlayVideo: true,
                    ),
                    if (widget.post.locationLat != null &&
                        widget.post.locationLong != null)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              audioCache.play('tab3.mp3');
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
              if (!widget.isSharedPost)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/image/like.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${widget.post.like}',
                                style: roboto_18_700().copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.post.numberOfComment} bình luận',
                            style: roboto_18_700().copyWith(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: deviceWidth(context) / 4,
                            child: GestureDetector(
                              onTap: () {
                                audioCache.play('tab3.mp3');
                                if (AuthBloc.instance.userModel == null) {
                                  LoginPage.navigatePush();
                                  return;
                                }
                                widget.post.isUserLike =
                                    !widget.post.isUserLike;

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
                                        ? Image.asset(
                                            "assets/image/unlike_icon.png",
                                            width: 30,
                                          )
                                        : Image.asset(
                                            "assets/image/like_icon.png",
                                            width: 30,
                                          ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text('Thích',
                                        style: ptTiny().copyWith(
                                          color: Colors.grey,
                                        )),
                                  ]),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: deviceWidth(context) / 4,
                            child: GestureDetector(
                              onTap: () {
                                audioCache.play('tab3.mp3');
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
                                    Image.asset(
                                      "assets/image/message_circle_icon.png",
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Bình luận',
                                      style: ptTiny().copyWith(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: deviceWidth(context) / 4,
                            child: GestureDetector(
                              onTap: () {
                                audioCache.play('tab3.mp3');
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return SharePost(widget.post);
                                    });
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/image/navigation_icon.png",
                                      width: 30,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text('Chia sẻ',
                                        style: ptTiny()
                                            .copyWith(color: Colors.grey)),
                                  ]),
                            ),
                          ),
                        ),
                        if (AuthBloc.instance.userModel != null)
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: deviceWidth(context) / 4,
                              child: GestureDetector(
                                onTap: () async {
                                  audioCache.play('tab3.mp3');
                                  if (AuthBloc.instance.userModel?.savedPostIds
                                          ?.contains(widget.post.id) ??
                                      false) {
                                    showToast('Bài viết đã được lưu', context,
                                        isSuccess: true);
                                    return;
                                  }

                                  final res =
                                      await _postBloc.savePost(widget.post);
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
                                      !(AuthBloc.instance.userModel
                                                  ?.savedPostIds
                                                  ?.contains(widget.post.id) ??
                                              false)
                                          ? Image.asset(
                                              "assets/image/bookmark_icon.png",
                                              width: 30,
                                            )
                                          : Image.asset(
                                              "assets/image/bookmark_a_icon.png",
                                              width: 30,
                                            ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text('Lưu',
                                          style: ptTiny()
                                              .copyWith(color: Colors.grey)),
                                    ]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              if (!widget.isSharedPost)
                SizedBox(
                  height: 8,
                ),
            ]
          ],
        ),
      ),
    );
  }

  _buildGroupTile() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            audioCache.play('tab3.mp3');
            widget.post.isPage
                ? PageDetail.navigate(widget.post?.page)
                : ProfileOtherPage.navigate(widget.post?.user);
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage:
                widget.post?.user?.id == AuthBloc.instance?.userModel?.id
                    ? ((AuthBloc.instance.userModel.avatar != null &&
                            AuthBloc.instance.userModel.avatar != 'null')
                        ? CachedNetworkImageProvider(
                            AuthBloc.instance.userModel.avatar)
                        : AssetImage('assets/image/default_avatar.png'))
                    : ((widget.post?.user?.avatar != null &&
                            widget.post?.user?.avatar != 'null')
                        ? CachedNetworkImageProvider(widget.post?.user?.avatar)
                        : AssetImage('assets/image/default_avatar.png')),
            child: VerifiedIcon(
              widget.post?.user?.role,
              10,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: widget.post?.user?.name ?? '',
                  style: ptTitle(),
                  recognizer: new TapGestureRecognizer()
                    ..onTap =
                        () => ProfileOtherPage.navigate(widget.post?.user),
                ),
                TextSpan(
                  text: '  ▶  ',
                  style: ptTitle(),
                ),
                TextSpan(
                  text: widget.post?.group?.name ?? '',
                  style: ptTitle(),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => DetailGroupPage.navigate(null,
                        groupId: widget.post?.group?.id),
                ),
              ])),
              Row(
                children: [
                  Text(
                    DateTime.tryParse(widget.post?.createdAt)
                                .add(Duration(days: 1))
                                .compareTo(DateTime.now()) <
                            0
                        ? (Formart.formatToDateTime(
                                DateTime.tryParse(widget.post?.createdAt)) ??
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
                            shape: BoxShape.circle, color: Colors.black26)),
                    SizedBox(width: 5),
                    Text(
                      widget.post.distance.toStringAsFixed(1) + ' km',
                      style: ptTiny().copyWith(color: Colors.black54),
                    ),
                  ]
                ],
              ),
              if ([
                widget.post.area,
                widget.post.action,
                widget.post.price,
                widget.post.category
              ].any((item) => item != null)) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(children: [
                    if (widget.post.area != null)
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
                        child: Text('${widget.post.area} m2',
                            style: ptTiny()
                                .copyWith(color: Colors.white, fontSize: 10.5)),
                      ),
                    if (widget.post.action != null)
                      Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0.5),
                          child: Text(widget.post.action,
                              style: ptTiny().copyWith(
                                  color: Colors.white, fontSize: 10.5))),
                    if (widget.post.category != null)
                      Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.orange,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0.5),
                          child: Text(widget.post.category,
                              style: ptTiny().copyWith(
                                  color: Colors.white, fontSize: 10.5))),
                    if (widget.post.price != null)
                      Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0.5),
                          child: Text(
                              Formart.toVNDPrice(widget.post.price.toDouble()),
                              style: ptTiny().copyWith(
                                  color: Colors.white, fontSize: 10.5)))
                  ]),
                ),
              ]
            ],
          ),
        ),
        if (AuthBloc.instance.userModel != null && !widget.isSharedPost)
          Center(
            child: PopupMenuButton(
                padding: EdgeInsets.zero,
                child: SizedBox(width: 30, child: Icon(Icons.more_vert)),
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
                        ].contains(
                                UserBloc.getRole(AuthBloc.instance.userModel)))
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
                        if (widget.post.postShareId == null)
                          PopupMenuItem(
                              child: Text('Sửa bài'), value: 'Sửa bài'),
                      ],
                      PopupMenuItem(
                          child: Text('Copy link'), value: 'Copy link'),
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
                    closeLoading();
                  }
                  if (val == 'Báo cáo') {
                    showReport(widget.post, context);
                  }
                  if (val == 'Xóa bài') {
                    final confirm = await showConfirmDialog(
                        context, 'Vui lòng xác nhận xóa bài viết này.',
                        confirmTap: () {}, navigatorKey: navigatorKey);
                    if (!confirm) return;
                    final res = await _postBloc.deletePost(widget.post.id);
                    if (res.isSuccess) {
                    } else {
                      showToast(res.errMessage, context);
                    }
                  }
                  if (val == 'Ẩn bài') {
                    final res = await _postBloc.hidePost(widget.post.id);
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
                    final res = await UpdatePostPage.navigate(widget.post);
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
    );
  }

  _buildUserOrPageTile() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            audioCache.play('tab3.mp3');
            widget.post.isPage
                ? PageDetail.navigate(widget.post?.page)
                : ProfileOtherPage.navigate(widget.post?.user);
          },
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: widget.post.isPage
                ? widget.post.page.avartar != null
                    ? CachedNetworkImageProvider(widget.post.page.avartar)
                    : AssetImage('assets/image/default_avatar.png')
                : widget.post?.user?.id == AuthBloc.instance?.userModel?.id
                    ? ((AuthBloc.instance.userModel.avatar != null &&
                            AuthBloc.instance.userModel.avatar != 'null')
                        ? CachedNetworkImageProvider(
                            AuthBloc.instance.userModel.avatar)
                        : AssetImage('assets/image/default_avatar.png'))
                    : ((widget.post?.user?.avatar != null &&
                            widget.post?.user?.avatar != 'null')
                        ? CachedNetworkImageProvider(widget.post?.user?.avatar)
                        : AssetImage('assets/image/default_avatar.png')),
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
                    audioCache.play('tab3.mp3');
                    widget.post.isPage
                        ? PageDetail.navigate(widget.post?.page)
                        : ProfileOtherPage.navigate(widget.post?.user);
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
                      child: Image.asset(
                        'assets/image/ip.png',
                        color: ptMainColor(context),
                      ),
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
            Row(
              children: [
                Text(
                  TimeAgo.timeAgoSinceDate(
                      DateTime.tryParse(widget.post?.createdAt)),
                  // DateTime.tryParse(widget.post?.createdAt)
                  //             .add(Duration(days: 1))
                  //             .compareTo(DateTime.now()) <
                  //         0
                  //     ? (Formart.formatToDateTime(
                  //             DateTime.tryParse(widget.post?.createdAt)) ??
                  //         '')
                  //     : Formart.timeByDayVi(
                  //         DateTime.tryParse(widget.post?.createdAt)),
                  style: roboto(context)
                      .copyWith(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                SizedBox(width: 5),
                if (widget.post.distance != null) ...[
                  Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black26)),
                  SizedBox(width: 5),
                  Text(
                    widget.post.distance.toStringAsFixed(1) + ' km',
                    style: roboto(context)
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ],
              ],
            ),
            if ([
              widget.post.area,
              widget.post.action,
              widget.post.price,
              widget.post.category
            ].any((item) => item != null)) ...[
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(children: [
                  if (widget.post.category != null)
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.orange,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        child: Text(widget.post.category,
                            style: ptTiny().copyWith(
                                color: Colors.white, fontSize: 10.5))),
                  if (widget.post.action != null)
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        child: Text(widget.post.action,
                            style: ptTiny().copyWith(
                                color: Colors.white, fontSize: 10.5))),
                  if (widget.post.area != null)
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      child: Text('${widget.post.area.floor()} m2',
                          style: ptTiny()
                              .copyWith(color: Colors.white, fontSize: 10.5)),
                    ),
                  if (widget.post.price != null)
                    Container(
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        child: Text(
                            Formart.toVNDPrice(widget.post.price.toDouble()),
                            style: ptTiny()
                                .copyWith(color: Colors.white, fontSize: 10.5)))
                ]),
              ),
              SizedBox(height: 10),
            ],
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
        if (AuthBloc.instance.userModel != null && !widget.isSharedPost)
          Center(
            child: PopupMenuButton(
                padding: EdgeInsets.zero,
                child: SizedBox(width: 30, child: Icon(Icons.more_vert)),
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
                        ].contains(
                                UserBloc.getRole(AuthBloc.instance.userModel)))
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
                        if (widget.post.postShareId == null)
                          PopupMenuItem(
                              child: Text('Sửa bài'), value: 'Sửa bài'),
                      ],
                      PopupMenuItem(
                          child: Text('Copy link'), value: 'Copy link'),
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
                    closeLoading();
                  }
                  if (val == 'Báo cáo') {
                    showReport(widget.post, context);
                  }
                  if (val == 'Xóa bài') {
                    final confirm = await showConfirmDialog(
                        context, 'Vui lòng xác nhận xóa bài viết này.',
                        confirmTap: () {}, navigatorKey: navigatorKey);
                    if (!confirm) return;
                    final res = await _postBloc.deletePost(widget.post.id);
                    if (res.isSuccess) {
                    } else {
                      showToast(res.errMessage, context);
                    }
                  }
                  if (val == 'Ẩn bài') {
                    final res = await _postBloc.hidePost(widget.post.id);
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
                    final res = await UpdatePostPage.navigate(widget.post);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 15, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ptPrimaryColor(context),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Container(
            width: deviceWidth(context),
            color: ptPrimaryColor(context),
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
                        audioCache.play('tab3.mp3');
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
                            style: ptBody(),
                          ),
                          SizedBox(height: 3),
                          Text.rich(
                            TextSpan(children: [
                              // TextSpan(text: 'Đăng bởi '),
                              TextSpan(
                                  text: '${widget.post.user.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  )),
                              TextSpan(
                                  text:
                                      ' • ${Formart.timeByDayVi(DateTime.tryParse(widget.post.updatedAt)).replaceAll(' trước', '')}'),
                            ]),
                            style: ptTiny(),
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
