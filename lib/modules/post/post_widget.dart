import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/modules/post/media_post_widget.dart';
import 'package:vnrealtor/modules/post/post_google_map.dart';
import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/function/share_to.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:readmore/readmore.dart';
import 'package:popup_menu/popup_menu.dart';

import 'comment_page.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  PostWidget(this.post);
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
    initMenu();
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
    PopupMenu.context = context;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
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
                      ProfilePage.navigate(widget.post?.user);
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
              padding: const EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
              child: ReadMoreText(
                widget.post?.content ?? '',
                trimLines: 2,
                textAlign: TextAlign.start,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.post.locationLat != null &&
                widget.post.locationLong != null)
              Container(
                width: deviceWidth(context),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await showGoogleMapPoint(context,
                            widget.post.locationLat, widget.post.locationLong);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: SizedBox(
                        height: 30,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              'Xem vị trí',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                    )),
              ),
            if ((widget.post?.mediaPosts?.length ?? 0) > 0)
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
            SizedBox(height: 10),
            Padding(
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
                    style: ptSmall(),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showComment(widget.post);
                    },
                    child: Text(
                      '${widget.post?.commentIds?.length.toString() ?? '0'} comments',
                      style: ptSmall(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.thumbUpOutline,
                            size: 19,
                            color: _isLike
                                ? ptPrimaryColor(context)
                                : Colors.black54,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                                color: _isLike
                                    ? ptPrimaryColor(context)
                                    : Colors.black54),
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
                          color: Colors.black54,
                          size: 19,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            showComment(widget.post);
                          },
                          child: Text(
                            'Comment',
                            style: TextStyle(color: Colors.black54),
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
                          color: Colors.black54,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => shareTo(context),
                          child: Text(
                            'Share',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ]),
                )
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
        ],
        onClickMenu: (val) {
          if (val.menuTitle == 'Voice call') {}
          if (val.menuTitle == 'Video call') {}
        },
        stateChanged: (val) {},
        onDismiss: () {});
  }

  PopupMenu menu;
}
