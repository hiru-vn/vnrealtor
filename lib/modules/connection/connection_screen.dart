import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_app_bar.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with SingleTickerProviderStateMixin {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  GroupBloc _groupBloc;
  TabController _tabController;
  int currentTab = 0;

  List<UserModel> _usersSuggest = [];
  List<GroupModel> _groupsSuggest = [];
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc.suggestFollow();
    }
    if (_groupBloc == null) {
      _groupBloc = Provider.of<GroupBloc>(context);
      _groupBloc.getSuggestGroup();
    }

    super.didChangeDependencies();
  }

  // _getUserSuggest() async {
  //   final res = await _userBloc.suggestFollow();
  //   if (!res.isSuccess) {
  //     showToast(res.errMessage, context);
  //   } else {
  //     _usersSuggest = res.data;
  //     setState(() {});
  //   }
  // }

  // _getGroupSuggest() async {
  //   final res = await _groupBloc.getSuggestGroup();
  //   if (!res.isSuccess) {
  //     showToast(res.errMessage, context);
  //   } else {
  //     _groupsSuggest = res.data;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor.fromHex("#E5E5E5"),
          appBar: PostPageAppBar(_authBloc.userModel.messNotiCount ?? 0),
          body: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ConnectionItem(
                        preIcon: Image.asset(
                          "assets/image/connection_icon.png",
                          width: 24,
                        ),
                        text: "Quản lý các mối liên kết",
                        subIcon: Image.asset(
                          "assets/image/right_icon.png",
                          width: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ConnectionItem(
                        preIcon: Image.asset(
                          "assets/image/invite_icon.png",
                          width: 24,
                        ),
                        text: "Lời mời",
                        subIcon: Image.asset(
                          "assets/image/right_icon.png",
                          width: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        child: TabBar(
                          tabs: [
                            Align(
                              alignment: Alignment.center,
                              child: Text("Người dùng / Nhóm"),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Trang"))
                          ],
                          indicatorSize: TabBarIndicatorSize.tab,
                          onTap: (value) {
                            setState(() {
                              currentTab = value;
                            });
                          },
                          indicatorWeight: 3,
                          indicatorColor: ptSecondColor(),
                          labelPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          controller: _tabController,
                          labelColor: ptSecondColor(),
                          unselectedLabelColor: Colors.black54,
                          unselectedLabelStyle:
                              TextStyle(fontSize: 14, color: Colors.black12),
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                    animation: _tabController.animation,
                    builder: (ctx, child) {
                      if (_tabController.index == 0) {
                        return Column(
                          children: [
                            _userBloc.suggestFollowUsers.length > 0
                                ? ListUserConnection(
                                    users: _userBloc.suggestFollowUsers,
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 10,
                            ),
                            _groupBloc.suggestGroup.length > 0
                                ? ListGroupConnection(
                                    groups: _groupBloc.suggestGroup,
                                  )
                                : SizedBox(),
                          ],
                        );
                      } else
                        return ListPageConnection();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListGroupConnection extends StatelessWidget {
  final List<GroupModel> groups;
  const ListGroupConnection({
    Key key,
    this.groups,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: HexColor.fromHex("#F0F6FB"),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/image/team_icon.png",
                      width: 30,
                    ),
                  ),
                  Text(
                    "Nhóm mà bạn có thể quan tâm",
                    style: roboto().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
              child: GridView.count(
            crossAxisCount: (MediaQuery.of(context).size.width / 200).round(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: .8,
            children: List.generate(
                groups.length,
                (index) => GroupSuggestItem(
                      group: groups[index],
                    )),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto().copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListPageConnection extends StatelessWidget {
  const ListPageConnection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              child: GridView.count(
            crossAxisCount: (MediaQuery.of(context).size.width / 200).round(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: .8,
            children: List.generate(100, (index) => PageSuggestItem()),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto().copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListUserConnection extends StatelessWidget {
  final List<UserModel> users;
  const ListUserConnection({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: HexColor.fromHex("#F0F6FB"),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/image/team_icon.png",
                      width: 30,
                    ),
                  ),
                  Text(
                    "Gợi ý bạn có thể kết nối",
                    style: roboto().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 240,
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => UserSuggestItem(
                user: users[index],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto().copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}

class UserSuggestItem extends StatelessWidget {
  final UserModel user;
  const UserSuggestItem({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      audioCache.play('tab3.mp3');
                      ProfileOtherPage.navigate(user);
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: user.avatar != null
                          ? CachedNetworkImageProvider(user.avatar)
                          : AssetImage('assets/image/default_avatar.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    audioCache.play('tab3.mp3');
                    ProfileOtherPage.navigate(user);
                  },
                  child: Text(
                    user.name,
                    style: roboto().copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: HexColor.fromHex("#505050")),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nhà môi giới"),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          user.totalPoint.toString(),
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/link_icon.png",
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${user.followerIds.length} Kết nối",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Kết nối"),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset(
                "assets/image/close_icon.png",
                width: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupSuggestItem extends StatelessWidget {
  final GroupModel group;
  const GroupSuggestItem({
    Key key,
    this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  group.name,
                  style: roboto().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: HexColor.fromHex("#505050")),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("14000 thành viên"),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Kết nối"),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 30,
              left: 60,
              child: Image.asset(
                "assets/image/datcao_logo.png",
                width: 60,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset(
                "assets/image/close_icon.png",
                width: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageSuggestItem extends StatelessWidget {
  const PageSuggestItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  "DAT CAO PAGE",
                  style: roboto().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: HexColor.fromHex("#505050")),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("344 follow"),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          AuthBloc.instance.userModel.totalPoint.toString(),
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
                  height: 10,
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Theo dõi"),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 30,
              left: 60,
              child: Image.asset(
                "assets/image/datcao_logo.png",
                width: 60,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset(
                "assets/image/close_icon.png",
                width: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ConnectionItem extends StatelessWidget {
  final Widget preIcon;
  final Widget subIcon;
  final String text;
  const ConnectionItem({
    Key key,
    this.preIcon,
    this.subIcon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Row(
          children: [
            preIcon,
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: roboto().copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            subIcon
          ],
        ),
      ),
    );
  }
}
