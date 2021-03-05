import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/post.dart';
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
import 'package:readmore/readmore.dart';
import 'package:popup_menu/popup_menu.dart';

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
  bool _isLike = false;
  bool _isSave = false;
  PostBloc _postBloc;

  @override
  void initState() {
    _isLike = widget.post.isUserLike;
    _isSave =
        AuthBloc.instance.userModel?.savedPostIds?.contains(widget.post.id) ??
            false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      initMenu();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: deviceWidth(context),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ProfileOtherPage.navigate(widget.post?.user);
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.post?.user?.avatar != null
                          ? NetworkImage(widget.post?.user?.avatar)
                          : AssetImage('assets/image/default_avatar.png'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            widget.post?.user?.name ?? '',
                            style: ptTitle(),
                          ),
                          SizedBox(width: 8),
                          if (widget.post?.user?.role == 'AGENT')
                            CustomTooltip(
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
                            )
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            Formart.formatToDate(DateTime.tryParse(
                                    widget.post?.createdAt)) ??
                                '',
                            style: ptSmall().copyWith(color: Colors.black54),
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.post?.user?.reputationScore.toString(),
                            style: ptBody().copyWith(color: Colors.yellow),
                          ),
                          SizedBox(width: 2),
                          Image.asset('assets/image/coin.png'),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  if (AuthBloc.instance.userModel != null)
                    Center(
                      child: IconButton(
                        key: moreBtnKey,
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          menu.show(widgetKey: moreBtnKey);
                        },
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15).copyWith(top: 0, bottom: 5),
              child: ReadMoreText(
                widget.post?.content?.trim() ?? '',
                trimLength: 100,
                style: ptBody().copyWith(color: Colors.black87),
                textAlign: TextAlign.start,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Length,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  Container(
                    height: deviceWidth(context) / 2 - 5,
                    width: deviceWidth(context),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.post?.mediaPosts?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: deviceWidth(context) /
                              (widget.post?.mediaPosts?.length == 1 ? 1 : 2),
                          child: MediaPostWidget(
                            post: widget.post?.mediaPosts[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: 0.8,
                      ),
                    ),
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
                                widget.post.locationLong);
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
                    _isLike = !_isLike;
                    if (_isLike) {
                      widget.post.like++;
                      _postBloc.likePost(widget.post.id);
                    } else {
                      if (widget.post.like > 0) widget.post.like--;
                      _postBloc.unlikePost(widget.post.id);
                    }
                    setState(() {});
                  },
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !_isLike
                            ? Icon(
                                MdiIcons.heartOutline,
                                size: 24,
                                color: ptPrimaryColor(context),
                              )
                            : Icon(
                                MdiIcons.heart,
                                size: 23,
                                color: Colors.red,
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('${widget.post.like} lượt thích',
                            style: ptTiny()
                                .copyWith(color: ptPrimaryColor(context))),
                      ]),
                ),
                SizedBox(
                  width: 15,
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
                          size: 24,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('${widget.post.commentIds.length} bình luận',
                            style: ptTiny()
                                .copyWith(color: ptPrimaryColor(context))),
                      ]),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () => shareTo(context,
                      content: widget.post.content,
                      image: widget.post.mediaPosts
                          .where((element) => element.type == 'PICTURE')
                          .map((e) => e.url)
                          .toList(),
                      video: widget.post.mediaPosts
                          .where((element) => element.type == 'VIDEO')
                          .map((e) => e.url)
                          .toList()),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.shareOutline,
                          color: ptPrimaryColor(context),
                          size: 24,
                        ),
                        SizedBox(
                          height: 5,
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
                      if (_isSave) {
                        showToast('Bài viết đã được lưu', context,
                            isSuccess: true);
                        return;
                      }
                      setState(() {
                        _isSave = true;
                      });
                      final res = await _postBloc.savePost(widget.post);
                      if (res.isSuccess) {
                      } else {
                        setState(() {
                          _isSave = false;
                          _postBloc.myPosts.remove(widget.post);
                        });
                        showToast(res.errMessage, context);
                      }
                    },
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !_isSave
                              ? Icon(
                                  MdiIcons.bookmarkOutline,
                                  color: ptPrimaryColor(context),
                                  size: 24,
                                )
                              : Icon(
                                  MdiIcons.bookmark,
                                  color: ptPrimaryColor(context),
                                  size: 24,
                                ),
                          SizedBox(
                            height: 5,
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
              height: 10,
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
              ));
        });
  }

  initMenu() {
    if (AuthBloc.instance.userModel == null) return;
    menu = PopupMenu(
        items: [
          if (widget.post.userId != AuthBloc.instance.userModel?.id) ...[
            MenuItem(
                title: 'Liên hệ',
                image: Icon(
                  Icons.post_add,
                  color: Colors.white,
                )),
            MenuItem(
                title: 'Báo cáo',
                image: Icon(
                  Icons.report,
                  color: Colors.white,
                )),
          ] else ...[
            MenuItem(
                title: 'Xóa bài',
                image: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
            MenuItem(
                title: 'Sửa bài',
                image: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          ]
        ],
        onClickMenu: (val) async {
          if (val.menuTitle == 'Liên hệ') {
            showSimpleLoadingDialog(context);
            await InboxBloc.instance.navigateToChatWith(
                widget.post.user.name,
                widget.post.user.avatar,
                DateTime.now(),
                widget.post.user.avatar, [
              AuthBloc.instance.userModel.id,
              widget.post.user.id,
            ]);
            navigatorKey.currentState.maybePop();
          }
          if (val.menuTitle == 'Báo cáo') {
            showReport(widget.post, context);
          }
          if (val.menuTitle == 'Xóa bài') {
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
          if (val.menuTitle == 'Sửa bài') {
            final res = await UpdatePostPage.navigate(widget.post);
            if (res == true) {
              await _postBloc.getNewFeed(
                  filter: GraphqlFilter(limit: 10, order: "{updatedAt: -1}"));
              return;
            }
          }
        },
        stateChanged: (val) {},
        onDismiss: () {});
  }

  PopupMenu menu;
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
      initMenu();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
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
            child: Image.network(
              url,
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
        padding: const EdgeInsets.only(top: 20, left: 25, right: 15),
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
                            widget.post.content.trim()[0].toUpperCase() +
                                widget.post.content
                                    .trim()
                                    .substring(1)
                                    .replaceAll('\n', ' ')
                                    .replaceAll('  ', ''),
                            style: ptTitle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3),
                          Text(
                            '${widget.post.mediaPosts.where((element) => element.type == 'VIDEO').length} Video • ${widget.post.mediaPosts.where((element) => element.type == 'PICTURE').length} Image',
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
                  child: GestureDetector(
                      key: moreBtnKey,
                      onTap: () {
                        menu.show(widgetKey: moreBtnKey);
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
              ));
        });
  }

  initMenu() {
    if (AuthBloc.instance.userModel == null) return;
    menu = PopupMenu(
        items: [
          MenuItem(
              title: 'Bỏ lưu',
              image: Icon(
                Icons.remove_circle_outline,
                color: Colors.white,
              )),
        ],
        onClickMenu: (val) async {
          if (val.menuTitle == 'Bỏ lưu') {
            final res = await _postBloc.unsavePost(widget.post);
            if (res.isSuccess) {
            } else {
              showToast(res.errMessage, context);
            }
          }
        },
        stateChanged: (val) {},
        onDismiss: () {});
  }

  PopupMenu menu;
}
