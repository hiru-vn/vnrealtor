import 'package:vnrealtor/modules/model/post.dart';
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

  @override
  void initState() {
    initMenu();
    super.initState();
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
              padding: const EdgeInsets.all(15).copyWith(top: 0),
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
            if ((widget.post?.mediaPosts?.length ?? 0) > 0)
              Container(
                height: deviceWidth(context) / 2 - 5,
                width: deviceWidth(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.post?.mediaPosts?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: deviceWidth(context) /
                          (widget.post?.mediaPosts?.length == 1 ? 1 : 2),
                      child: ImageViewNetwork(
                        url: widget.post?.mediaPosts[index].url,
                      ),
                    );
                  },
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
                      showComment();
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.thumbUpOutline,
                          size: 19,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
                Expanded(
                  child: Row(
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
                            showComment();
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

  showComment() {
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
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: CommentPage(
                    post: widget.post,
                  )),
                ],
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
