import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/model/friendship.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/post/post_widget.dart';
import 'package:vnrealtor/modules/post/people_widget.dart';
import 'package:vnrealtor/modules/profile/update_profile_page.dart';
import 'package:vnrealtor/share/import.dart';

enum RelationShip {
  PENDING,
  DECLINE,
  ACCEPTED,
}

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage(this.user);
  static Future navigate(UserModel user) {
    return navigatorKey.currentState.push(pageBuilder(ProfilePage(user)));
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _pageController;
  AuthBloc _authBloc;
  UserBloc _userBloc;
  bool isOtherUserProfile;

  @override
  void initState() {
    _pageController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of<UserBloc>(context);
    }
    if (widget.user == null || widget.user.id == _authBloc.userModel.id) {
      isOtherUserProfile = false;
    } else {
      isOtherUserProfile = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2(
        isOtherUserProfile ? 'Thông tin người dùng' : 'Thông tin cá nhân',
        // actions: (!isOtherUserProfile)
        //     ? [
        //         GestureDetector(
        //           onTap: () {
        //             // UpdateProfilePage.navigate();
        //           },
        //           child: SizedBox(
        //             width: 40,
        //             child: Icon(
        //               Icons.settings,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ]
        //     : null,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: ProfileCard(
                  user: isOtherUserProfile ? widget.user : _authBloc.userModel),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateTo(0);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: Text(
                        'Bài viết',
                        style: ptBigTitle().copyWith(
                            color: _pageController.index == 0
                                ? Colors.black
                                : Colors.black38),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateTo(1);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: Text(
                        'Bạn bè',
                        style: ptBigTitle().copyWith(
                            color: _pageController.index == 1
                                ? Colors.black
                                : Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListView(
                children: [PostWidget(), PostWidget(), PostWidget()],
              ),
              ListView(
                children: [PeopleWidget(AuthBloc.instance.userModel)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  final UserModel user;

  const ProfileCard({Key key, this.user}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  UserBloc _userBloc;
  FriendshipModel friendshipModel;
  bool initFetchStatus = false;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _getFriendShip();
    }
    super.didChangeDependencies();
  }

  _addFriend() async {
    if (friendshipModel == null)
      friendshipModel = FriendshipModel(
          user1Id: AuthBloc.instance.userModel.id,
          user2Id: widget.user.id,
          status: FriendShipStatus.PENDING);
    setState(() {
      friendshipModel.status = FriendShipStatus.PENDING;
    });
    final res = await _userBloc.sendFriendInvite(widget.user.id);
    if (res.isSuccess) {
      setState(() {
        friendshipModel = res.data;
      });
      showToast('Đã gửi lời mời kết bạn', context, isSuccess: true);
    } else
      showToast(res.errMessage, context);
  }

  Future _getFriendShip() async {
    if (widget.user.id == AuthBloc.instance.userModel.id) return;
    final res = await _userBloc.getMyFriendShipWith(widget.user.id);
    if (res.isSuccess) {
      setState(() {
        friendshipModel = res.data;
        initFetchStatus = true;
      });
    } else {
      // no friendship
      setState(() {
        initFetchStatus = true;
      });
    }
  }

  Widget _getBtnWidget() {
    if (!initFetchStatus)
      return SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          backgroundColor: ptPrimaryColor(context),
        ),
      );
    if (widget.user.id == AuthBloc.instance.userModel.id)
      return Center(
        child: RaisedButton(
          color: Colors.blueAccent,
          padding: EdgeInsets.all(0),
          child: Text(
            'Cập nhật',
            style: ptBody().copyWith(color: Colors.white),
          ),
          onPressed: () {
            UpdateProfilePage.navigate();
          },
        ),
      );
    if (friendshipModel == null)
      return Center(
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          child: Text(
            'Kết bạn',
            style: ptBody().copyWith(color: Colors.white),
          ),
          onPressed: _addFriend,
        ),
      );
    if (friendshipModel.status == FriendShipStatus.ACCEPTED) {
      return Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Bạn bè',
                  style: ptBody().copyWith(color: Colors.black),
                ),
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.check,
                  color: ptPrimaryColor(context),
                  size: 17,
                ),
              ],
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                setState(() {
                  friendshipModel.status = FriendShipStatus.DECLINE;
                });
                final res =
                    await _userBloc.declineFriendInvite(friendshipModel.id);
                if (res.isSuccess) {
                  setState(() {
                    friendshipModel = res.data;
                  });
                } else {
                  showToast(res.errMessage, context);
                  setState(() {
                    friendshipModel.status = FriendShipStatus.ACCEPTED;
                  });
                }
              },
              child: Text(
                'Hủy kết bạn',
                style: ptBody().copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }
    if (friendshipModel.status == FriendShipStatus.DECLINE) {
      return Center(
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          child: Text(
            'Kết bạn',
            style: ptBody().copyWith(color: Colors.white),
          ),
          onPressed: _addFriend,
        ),
      );
    }
    if (friendshipModel.status == FriendShipStatus.PENDING) {
      if (friendshipModel.user1Id == AuthBloc.instance.userModel.id)
        return Center(
          child: RaisedButton(
            color: Colors.red[200],
            padding: EdgeInsets.all(0),
            child: Text(
              'Hủy lời mời',
              style: ptBody().copyWith(color: Colors.white),
            ),
            onPressed: () async {
              setState(() {
                friendshipModel.status = FriendShipStatus.DECLINE;
              });
              final res =
                  await _userBloc.declineFriendInvite(friendshipModel.id);
              if (res.isSuccess) {
                setState(() {
                  friendshipModel = res.data;
                });
              } else {
                showToast(res.errMessage, context);
                setState(() {
                  friendshipModel.status = FriendShipStatus.PENDING;
                });
              }
            },
          ),
        );
      else if (initFetchStatus)
        return Center(
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Xác nhận\nkết bạn',
              style: ptBody().copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              setState(() {
                friendshipModel.status = FriendShipStatus.ACCEPTED;
              });
              final res =
                  await _userBloc.acceptFriendInvite(friendshipModel.id);
              if (res.isSuccess) {
                setState(() {
                  friendshipModel = res.data;
                });
              } else {
                showToast(res.errMessage, context);
                setState(() {
                  friendshipModel.status = FriendShipStatus.PENDING;
                });
              }
            },
          ),
        );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
          borderRadius: BorderRadius.circular(5),
          elevation: 3,
          child: Container(
            width: deviceWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14)
                .copyWith(right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: widget.user.avatar != null
                            ? NetworkImage(widget.user.avatar)
                            : AssetImage('assets/image/avatar.jpeg'),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              widget.user.name ?? '',
                              style:
                                  ptBigTitle().copyWith(color: Colors.black87),
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Điểm uy tín: ${widget.user.reputationScore.toString()}',
                                  style:
                                      ptBody().copyWith(color: Colors.black54),
                                ),
                                SizedBox(width: 2),
                                Image.asset('assets/image/coin.png'),
                              ],
                            ),
                            SizedBox(height: 3),
                            Text(
                              widget.user.role.toLowerCase() == 'agency'
                                  ? 'Nhà môi giới'
                                  : 'Người dùng cơ bản',
                              style: ptSmall().copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      _getBtnWidget()
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: 70,
                    child: Center(
                      child: Text(
                        '3 bài viết',
                        style: ptSmall().copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Row(children: [
                    SizedBox(
                      width: 70,
                      child: friendshipModel?.status == FriendShipStatus.ACCEPTED
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.chatOutline,
                                    color: ptPrimaryColor(context),
                                  ),
                                  Text(
                                    'Nhắn tin',
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 70,
                                child: Center(
                                  child: Icon(
                                    Icons.phone,
                                    color: ptPrimaryColor(context),
                                    size: 28,
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 35,
                              color: ptLineColor(context),
                            ),
                            SizedBox(width: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Số điện thoại',
                                  style:
                                      ptBody().copyWith(color: Colors.black54),
                                ),
                                Text(
                                  widget.user.phone,
                                  style: ptBody().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 70,
                                child: Center(
                                  child: Icon(
                                    Icons.email,
                                    color: ptPrimaryColor(context),
                                    size: 28,
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 35,
                              color: ptLineColor(context),
                            ),
                            SizedBox(width: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style:
                                      ptBody().copyWith(color: Colors.black54),
                                ),
                                Text(
                                  widget.user.email,
                                  style: ptBody().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ])
                ]),
          )),
    );
  }
}
