import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/media_post_widget.dart';
import 'package:datcao/modules/post/post_google_map.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/modules/profile/profile_page.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/import.dart';
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
  PostBloc _postBloc;

  @override
  void initState() {
    _isLike = widget.post.isUserLike;

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
                      radius: 25,
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
                          Text(
                            widget.post?.user?.reputationScore.toString(),
                            style: ptTitle().copyWith(color: Colors.yellow),
                          ),
                          SizedBox(width: 2),
                          Image.asset('assets/image/coin.png'),
                        ],
                      ),
                      SizedBox(height: 3),
                      Text(
                        Formart.formatToDate(
                                DateTime.tryParse(widget.post?.createdAt)) ??
                            '',
                        style: ptSmall().copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                  Spacer(),
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
                widget.post?.content ?? '',
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
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            //           '${widget.post?.commentIds?.length.toString() ?? '0'} comments',
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
                          size: 23,
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
                  onTap: () => shareTo(context),
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
                GestureDetector(
                  onTap: () => showAlertDialog(context, 'Đang phát triển',
                      navigatorKey: navigatorKey),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.bookmarkOutline,
                          color: ptPrimaryColor(context),
                          size: 24,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {} ,
                          child: Text('Lưu',
                              style: ptTiny()
                                  .copyWith(color: ptPrimaryColor(context))),
                        ),
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
    menu = PopupMenu(
        items: [
          if (widget.post.userId != AuthBloc.instance.userModel.id) ...[
            MenuItem(
                title: 'Contact',
                image: Icon(
                  Icons.post_add,
                  color: Colors.white,
                )),
            MenuItem(
                title: 'Report',
                image: Icon(
                  Icons.report,
                  color: Colors.white,
                )),
          ] else
            MenuItem(
                title: 'Delete',
                image: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
        ],
        onClickMenu: (val) async {
          if (val.menuTitle == 'Contact') {}
          if (val.menuTitle == 'Report') {}
          if (val.menuTitle == 'Delete') {
            final res = await _postBloc.deletePost(widget.post.id);
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
