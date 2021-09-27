import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/share/import.dart';

class PageInviteReceivedItem extends StatefulWidget {
  final PagesCreate page;
  final UserModel user;

  const PageInviteReceivedItem({Key key, this.page, this.user})
      : super(key: key);

  @override
  _PageInviteReceivedItemState createState() => _PageInviteReceivedItemState();
}

class _PageInviteReceivedItemState extends State<PageInviteReceivedItem> {
  void onFollowPage(String id) {
    PagesBloc.instance.followPage(id);
    PagesBloc.instance.suggestFollow();
    PagesBloc.instance.deleteSuggestPage(id);
  }

  void onUnFollowPage(String id) {
    PagesBloc.instance.unFollowPage(id);
    PagesBloc.instance.suggestFollow();
    PagesBloc.instance.deleteSuggestPage(id);
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthBloc.instance.userModel.id;
    return GestureDetector(
      onTap: () => PageDetail.navigate(widget.page),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: ptPrimaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/image/anhbia.png",
                    height: 60,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image(
                      image: widget.page.avartar != null
                          ? CachedNetworkImageProvider(widget.page.avartar)
                          : AssetImage('assets/image/default_avatar.png'),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.page.name,
                    style: roboto(context).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Được mời bởi ${widget.user.name}',
                    style: roboto(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.page.followers.length} follow"),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "7",
                          ),
                          Image.asset(
                            "assets/image/guarantee.png",
                            width: 18,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.page.followerIds.contains(userId)
                      ? GestureDetector(
                          onTap: () {
                            onUnFollowPage(widget.page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text("Bỏ theo dõi"),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            onFollowPage(widget.page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Theo dõi",
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    //onDeletePage(page.id);
                  },
                  child: Image.asset(
                    "assets/image/close_icon.png",
                    width: 22,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageInviteSentItem extends StatefulWidget {
  final UserModel user;
  final List<Widget> actions;
  final PagesCreate page;
  final Function onDeleteInvite;

  const PageInviteSentItem({
    Key key,
    this.user,
    this.actions,
    this.page,
    this.onDeleteInvite,
  }) : super(key: key);

  @override
  _PageInviteSentItemState createState() => _PageInviteSentItemState();
}

class _PageInviteSentItemState extends State<PageInviteSentItem> {
  void onFollowPage(String id) {
    PagesBloc.instance.followPage(id);
    PagesBloc.instance.suggestFollow();
    PagesBloc.instance.deleteSuggestPage(id);
  }

  void onUnFollowPage(String id) {
    PagesBloc.instance.unFollowPage(id);
    PagesBloc.instance.suggestFollow();
    PagesBloc.instance.deleteSuggestPage(id);
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthBloc.instance.userModel.id;
    return GestureDetector(
      onTap: () => PageDetail.navigate(widget.page),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: ptPrimaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/image/anhbia.png",
                    height: 60,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image(
                      image: widget.page.avartar != null
                          ? CachedNetworkImageProvider(widget.page.avartar)
                          : AssetImage('assets/image/default_avatar.png'),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.page.name,
                    style: roboto(context).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Đã gửi tới ${widget.user.name}',
                    style: roboto(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.page.followers.length} follow"),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "7",
                          ),
                          Image.asset(
                            "assets/image/guarantee.png",
                            width: 18,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.page.followerIds.contains(userId)
                      ? GestureDetector(
                          onTap: () {
                            onUnFollowPage(widget.page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text("Bỏ theo dõi"),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            onFollowPage(widget.page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Theo dõi",
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onDeleteInvite();
                    },
                    child: Container(
                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Thu hồi lời mời",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    widget.onDeleteInvite();
                  },
                  child: Image.asset(
                    "assets/image/close_icon.png",
                    width: 22,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroupInviteItem extends StatelessWidget {
  final GroupModel group;
  final UserModel user;
  final bool isSent;
  final Function onDeleteInvite;

  const GroupInviteItem(
      {Key key,
      this.group,
      this.user,
      this.isSent = false,
      this.onDeleteInvite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        audioCache.play('tab3.mp3');
        DetailGroupPage.navigate(null, groupId: group.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: ptPrimaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Container(
                child: Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      image: group.coverImage != null
                          ? CachedNetworkImageProvider(group.coverImage)
                          : AssetImage('assets/image/default_avatar.png'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 35,
                      child: AutoSizeText(
                        group.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: roboto(context).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${group.countMember} thành viên"),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${isSent ? 'Đã gửi đến' : 'Được mời bởi'}  ${user.name}',
                    style: roboto(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    onDeleteInvite();
                  },
                  child: Image.asset(
                    "assets/image/close_icon.png",
                    width: 22,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}