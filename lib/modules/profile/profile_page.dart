import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/modules/profile/follow_page.dart';
import 'package:datcao/modules/profile/update_profile_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();
  static Future navigate(UserModel user) {
    return navigatorKey.currentState.push(pageBuilder(ProfilePage()));
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AuthBloc _authBloc;
  UserBloc _userBloc;
  PostBloc _postBloc;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of<UserBloc>(context);
      _postBloc = Provider.of<PostBloc>(context);
      _postBloc.getMyPost();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: ProfilePageAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: ProfileCard(
                user: _authBloc.userModel,
                tabC: _tabController,
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _postBloc.myPosts == null
                  ? kLoadingSpinner
                  : (_postBloc.myPosts.length != 0
                      ? ListView.separated(
                          itemCount: _postBloc.myPosts.length,
                          itemBuilder: (context, index) {
                            final post = _postBloc.myPosts[index];
                            return PostWidget(post);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                        )
                      : EmptyWidget(
                          assetImg: 'assets/image/no_post.png',
                          content: 'Bạn chưa có bài đăng nào.',
                        )),
              _postBloc.savePosts == null
                  ? kLoadingSpinner
                  : (_postBloc.savePosts.length != 0
                      ? ListView.separated(
                          itemCount: _postBloc.savePosts.length,
                          itemBuilder: (context, index) {
                            final post = _postBloc.savePosts[index];
                            return PostWidget(post);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15),
                        )
                      : EmptyWidget(
                          assetImg: 'assets/image/no_post.png',
                          content: 'Kho lưu trữ trống.',
                        )),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  ProfilePageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            navigatorKey.currentState.canPop()
                ? BackButton()
                : SizedBox(
                    width: 15,
                  ),
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            // GestureDetector(
            //   onTap: () {
            //     showAlertDialog(context, 'Đang phát triển',
            //         navigatorKey: navigatorKey);
            //   },
            //   child: SizedBox(
            //       width: 42,
            //       height: 42,
            //       child: Icon(
            //         MdiIcons.menu,
            //         size: 26,
            //       )),
            // )
          ],
        ),
      ),
      color: ptSecondaryColor(context),
    );
  }
}

class ProfileCard extends StatefulWidget {
  final UserModel user;
  final TabController tabC;

  const ProfileCard({Key key, this.user, this.tabC}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  UserBloc _userBloc;
  AuthBloc _authBloc;
  bool initFetchStatus = false;
  Uri _emailLaunchUri;

  @override
  void initState() {
    super.initState();
    _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: widget.user.email,
    );
  }

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _authBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8).copyWith(top: 0, bottom: 0),
      child: Material(
          borderRadius: BorderRadius.circular(5),
          // elevation: 3,
          child: Container(
            width: deviceWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14)
                .copyWith(bottom: 0, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2.5, color: ptPrimaryColor(context)),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 37.5,
                            backgroundColor: Colors.white,
                            backgroundImage: widget.user.avatar != null
                                ? NetworkImage(widget.user.avatar)
                                : AssetImage('assets/image/default_avatar.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Icon(
                                  Icons.star_outline,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                ...[
                                  Text(
                                    widget.user.name ?? '',
                                    style: ptBigTitle(),
                                  ),
                                  SizedBox(width: 8),
                                  if (AuthBloc.instance.userModel?.role ==
                                      'AGENT')
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
                                ]
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AuthBloc.instance.userModel.totalPost
                                            .toString(),
                                        style: ptTitle(),
                                      ),
                                      Text(
                                        'Số lượt\nthích',
                                        style: ptSmall(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  width: 4,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      FollowPage.navigate(widget.user);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AuthBloc.instance.userModel
                                              .followerIds.length
                                              .toString(),
                                          style: ptTitle(),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Người theo\ndõi',
                                            style: ptSmall(),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 4,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      FollowPage.navigate(widget.user);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AuthBloc.instance.userModel
                                              .followingIds.length
                                              .toString(),
                                          style: ptTitle(),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            'Đang theo\ndõi',
                                            style: ptSmall(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Text(
                  //   widget.user.role.toLowerCase() == 'agency'
                  //       ? 'Nhà môi giới'
                  //       : 'Người dùng cơ bản',
                  //   style: ptSmall().copyWith(color: Colors.blue),
                  // ),
                  if (_authBloc.userModel.description != null)
                    Text(_authBloc.userModel.description),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Điểm uy tín: ${widget.user.reputationScore.toString()}',
                        style: ptBody().copyWith(color: Colors.black54),
                      ),
                      SizedBox(width: 5),
                      Image.asset('assets/image/coin.png'),
                      Spacer(),
                      if (widget.user.facebookUrl != null)
                        FutureBuilder(
                            future: canLaunch(widget.user.facebookUrl),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return SizedBox.shrink();
                              if (snapshot.data == false)
                                return SizedBox.shrink();
                              if (snapshot.data == true)
                                return GestureDetector(
                                  onTap: () {
                                    launch(widget.user.facebookUrl);
                                  },
                                  child: SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: Image.asset(
                                          'assets/image/facebook_icon.png')),
                                );
                              return SizedBox.shrink();
                            }),
                      SizedBox(width: 15),
                      if (widget.user.email != null)
                        GestureDetector(
                          onTap: () {
                            launch(_emailLaunchUri.toString());
                          },
                          child: SizedBox(
                              width: 26,
                              height: 26,
                              child:
                                  Image.asset('assets/image/gmail_icon.png')),
                        ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Row(children: [
                  //   Expanded(
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         UpdateProfilePage.navigate();
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(6),
                  //             border:
                  //                 Border.all(color: ptPrimaryColor(context))),
                  //         child: Center(
                  //           child: Text(
                  //             'Sửa thông tin cá nhân',
                  //             style: ptTitle(),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // SizedBox(height: 10),
                  Center(
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 4,
                        indicatorColor: ptPrimaryColor(context),
                        controller: widget.tabC,
                        isScrollable: true,
                        labelColor: Colors.black87,
                        unselectedLabelStyle: ptTitle(),
                        labelStyle: ptTitle(),
                        tabs: [
                          SizedBox(
                            height: 35,
                            width: deviceWidth(context) / 2 - 60,
                            child: Tab(
                              child: Icon(
                                MdiIcons.postOutline,
                                color: ptPrimaryColor(context),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: deviceWidth(context) / 2 - 60,
                            child: Tab(
                              child: Icon(
                                MdiIcons.bookmarkOutline,
                                color: ptPrimaryColor(context),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ]),
          )),
    );
  }
}

// import 'package:datcao/modules/authentication/auth_bloc.dart';
// import 'package:datcao/modules/bloc/user_bloc.dart';
// import 'package:datcao/modules/inbox/inbox_bloc.dart';
// import 'package:datcao/modules/model/friendship.dart';
// import 'package:datcao/modules/model/user.dart';
// import 'package:datcao/modules/post/people_widget.dart';
// import 'package:datcao/modules/profile/update_profile_page.dart';
// import 'package:datcao/share/import.dart';

// enum RelationShip {
//   PENDING,
//   DECLINE,
//   ACCEPTED,
// }

// class ProfilePage extends StatefulWidget {
//   final UserModel user;

//   const ProfilePage(this.user);
//   static Future navigate(UserModel user) {
//     return navigatorKey.currentState.push(pageBuilder(ProfilePage(user)));
//   }

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage>
//     with SingleTickerProviderStateMixin {
//   TabController _pageController;
//   AuthBloc _authBloc;
//   UserBloc _userBloc;
//   bool isOtherUserProfile;

//   @override
//   void initState() {
//     _pageController = TabController(length: 2, vsync: this);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_authBloc == null) {
//       _authBloc = Provider.of<AuthBloc>(context);
//       _userBloc = Provider.of<UserBloc>(context);
//     }
//     if (widget.user == null || widget.user.id == _authBloc.userModel.id) {
//       isOtherUserProfile = false;
//     } else {
//       isOtherUserProfile = true;
//     }

//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ptBackgroundColor(context),
//       appBar: AppBar2(
//         isOtherUserProfile ? 'Thông tin người dùng' : 'Thông tin cá nhân',
//         // actions: (!isOtherUserProfile)
//         //     ? [
//         //         GestureDetector(
//         //           onTap: () {
//         //             // UpdateProfilePage.navigate();
//         //           },
//         //           child: SizedBox(
//         //             width: 40,
//         //             child: Icon(
//         //               Icons.settings,
//         //               color: Colors.white,
//         //             ),
//         //           ),
//         //         ),
//         //       ]
//         //     : null,
//       ),
//       body: NestedScrollView(
//         headerSliverBuilder: (context, value) {
//           return [
//             SliverToBoxAdapter(
//               child: ProfileCard(
//                   user: isOtherUserProfile ? widget.user : _authBloc.userModel),
//             ),
//             SliverToBoxAdapter(
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _pageController.animateTo(0);
//                       setState(() {});
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15).copyWith(bottom: 0),
//                       child: Text(
//                         'Bài viết',
//                         style: ptBigTitle().copyWith(
//                             color: _pageController.index == 0
//                                 ? Colors.black
//                                 : Colors.black38),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _pageController.animateTo(1);
//                       setState(() {});
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(15).copyWith(bottom: 0),
//                       child: Text(
//                         'Bạn bè',
//                         style: ptBigTitle().copyWith(
//                             color: _pageController.index == 1
//                                 ? Colors.black
//                                 : Colors.black38),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ];
//         },
//         body: Container(
//           child: TabBarView(
//             controller: _pageController,
//             physics: NeverScrollableScrollPhysics(),
//             children: [
//               ListView(
//                 children: [
//                   //PostWidget(), PostWidget(), PostWidget()
//                 ],
//               ),
//               ListView(
//                 children: [PeopleWidget(AuthBloc.instance.userModel)],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfileCard extends StatefulWidget {
//   final UserModel user;

//   const ProfileCard({Key key, this.user}) : super(key: key);

//   @override
//   _ProfileCardState createState() => _ProfileCardState();
// }

// class _ProfileCardState extends State<ProfileCard> {
//   UserBloc _userBloc;
//   FriendshipModel friendshipModel;
//   bool initFetchStatus = false;

//   @override
//   void didChangeDependencies() {
//     if (_userBloc == null) {
//       _userBloc = Provider.of<UserBloc>(context);
//       _getFriendShip();
//     }
//     super.didChangeDependencies();
//   }

//   _addFriend() async {
//     if (friendshipModel == null)
//       friendshipModel = FriendshipModel(
//           user1Id: AuthBloc.instance.userModel.id,
//           user2Id: widget.user.id,
//           status: FriendShipStatus.PENDING);
//     setState(() {
//       friendshipModel.status = FriendShipStatus.PENDING;
//     });
//     final res = await _userBloc.sendFriendInvite(widget.user.id);
//     if (res.isSuccess) {
//       setState(() {
//         friendshipModel = res.data;
//       });
//       showToast('Đã gửi lời mời kết bạn', context, isSuccess: true);
//     } else
//       showToast(res.errMessage, context);
//   }

//   Future _getFriendShip() async {
//     if (widget.user.id == AuthBloc.instance.userModel.id) return;
//     final res = await _userBloc.getMyFriendShipWith(widget.user.id);
//     if (res.isSuccess) {
//       setState(() {
//         friendshipModel = res.data;
//         initFetchStatus = true;
//       });
//     } else {
//       // no friendship
//       setState(() {
//         initFetchStatus = true;
//       });
//     }
//   }

//   Widget _getBtnWidget() {
//     if (!initFetchStatus && widget.user.id != AuthBloc.instance.userModel.id)
//       return SizedBox(
//         height: 25,
//         width: 25,
//         child: CircularProgressIndicator(
//           backgroundColor: ptPrimaryColor(context),
//         ),
//       );
//     if (widget.user.id == AuthBloc.instance.userModel.id)
//       return Center(
//         child: RaisedButton(
//           color: Colors.blueAccent,
//           padding: EdgeInsets.all(0),
//           child: Text(
//             'Cập nhật',
//             style: ptBody().copyWith(color: Colors.white),
//           ),
//           onPressed: () {
//             UpdateProfilePage.navigate();
//           },
//         ),
//       );
//     if (friendshipModel == null)
//       return Center(
//         child: RaisedButton(
//           padding: EdgeInsets.all(0),
//           child: Text(
//             'Kết bạn',
//             style: ptBody().copyWith(color: Colors.white),
//           ),
//           onPressed: _addFriend,
//         ),
//       );
//     if (friendshipModel.status == FriendShipStatus.ACCEPTED) {
//       return Center(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Bạn bè',
//                   style: ptBody().copyWith(color: Colors.black),
//                 ),
//                 SizedBox(
//                   width: 3,
//                 ),
//                 Icon(
//                   Icons.check,
//                   color: ptPrimaryColor(context),
//                   size: 17,
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             GestureDetector(
//               onTap: () async {
//                 setState(() {
//                   friendshipModel.status = FriendShipStatus.DECLINE;
//                 });
//                 final res =
//                     await _userBloc.declineFriendInvite(friendshipModel.id);
//                 if (res.isSuccess) {
//                   setState(() {
//                     friendshipModel = res.data;
//                   });
//                 } else {
//                   showToast(res.errMessage, context);
//                   setState(() {
//                     friendshipModel.status = FriendShipStatus.ACCEPTED;
//                   });
//                 }
//               },
//               child: Text(
//                 'Hủy kết bạn',
//                 style: ptBody().copyWith(color: Colors.blue),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     if (friendshipModel.status == FriendShipStatus.DECLINE) {
//       return Center(
//         child: RaisedButton(
//           padding: EdgeInsets.all(0),
//           child: Text(
//             'Kết bạn',
//             style: ptBody().copyWith(color: Colors.white),
//           ),
//           onPressed: _addFriend,
//         ),
//       );
//     }
//     if (friendshipModel.status == FriendShipStatus.PENDING) {
//       if (friendshipModel.user1Id == AuthBloc.instance.userModel.id)
//         return Center(
//           child: RaisedButton(
//             color: Colors.red[200],
//             padding: EdgeInsets.all(0),
//             child: Text(
//               'Hủy lời mời',
//               style: ptBody().copyWith(color: Colors.white),
//             ),
//             onPressed: () async {
//               setState(() {
//                 friendshipModel.status = FriendShipStatus.DECLINE;
//               });
//               final res =
//                   await _userBloc.declineFriendInvite(friendshipModel.id);
//               if (res.isSuccess) {
//                 setState(() {
//                   friendshipModel = res.data;
//                 });
//               } else {
//                 showToast(res.errMessage, context);
//                 setState(() {
//                   friendshipModel.status = FriendShipStatus.PENDING;
//                 });
//               }
//             },
//           ),
//         );
//       else if (initFetchStatus)
//         return Center(
//           child: RaisedButton(
//             padding: EdgeInsets.symmetric(vertical: 5),
//             child: Text(
//               'Xác nhận\nkết bạn',
//               style: ptBody().copyWith(color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//             onPressed: () async {
//               setState(() {
//                 friendshipModel.status = FriendShipStatus.ACCEPTED;
//               });
//               final res =
//                   await _userBloc.acceptFriendInvite(friendshipModel.id);
//               if (res.isSuccess) {
//                 setState(() {
//                   friendshipModel = res.data;
//                 });
//               } else {
//                 showToast(res.errMessage, context);
//                 setState(() {
//                   friendshipModel.status = FriendShipStatus.PENDING;
//                 });
//               }
//             },
//           ),
//         );
//     }
//     return SizedBox.shrink();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Material(
//           borderRadius: BorderRadius.circular(5),
//           elevation: 3,
//           child: Container(
//             width: deviceWidth(context),
//             padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14)
//                 .copyWith(right: 20),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 35,
//                         backgroundImage: widget.user.avatar != null
//                             ? NetworkImage(widget.user.avatar)
//                             : AssetImage('assets/image/default_avatar.png'),
//                       ),
//                       SizedBox(
//                         width: 14,
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 6),
//                             Text(
//                               widget.user.name ?? '',
//                               style:
//                                   ptBigTitle().copyWith(color: Colors.black87),
//                             ),
//                             SizedBox(height: 3),
//                             Row(
//                               children: [
//                                 Text(
//                                   'Điểm uy tín: ${widget.user.reputationScore.toString()}',
//                                   style:
//                                       ptBody().copyWith(color: Colors.black54),
//                                 ),
//                                 SizedBox(width: 2),
//                                 Image.asset('assets/image/coin.png'),
//                               ],
//                             ),
//                             SizedBox(height: 3),
//                             Text(
//                               widget.user.role.toLowerCase() == 'agency'
//                                   ? 'Nhà môi giới'
//                                   : 'Người dùng cơ bản',
//                               style: ptSmall().copyWith(color: Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ),
//                       _getBtnWidget()
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                     width: 70,
//                     child: Center(
//                       child: Text(
//                         '3 bài viết',
//                         style: ptSmall().copyWith(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                   Row(children: [
//                     SizedBox(
//                       width: 70,
//                       child: friendshipModel?.status ==
//                               FriendShipStatus.ACCEPTED
//                           ? Center(
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   showSimpleLoadingDialog(context);
//                                   await InboxBloc.instance.navigateToChatWith(
//                                       widget.user.name,
//                                       widget.user.avatar,
//                                       DateTime.now(),
//                                       widget.user.avatar, [
//                                     AuthBloc.instance.userModel.id,
//                                     widget.user.id,
//                                   ], [
//                                     AuthBloc.instance.userModel.name,
//                                     widget.user.name
//                                   ]);
//                                   navigatorKey.currentState.maybePop();
//                                 },
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       MdiIcons.chatOutline,
//                                       color: ptPrimaryColor(context),
//                                     ),
//                                     Text(
//                                       'Nhắn tin',
//                                       style: TextStyle(
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : SizedBox.shrink(),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                                 width: 60,
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.phone,
//                                     color: ptPrimaryColor(context),
//                                     size: 28,
//                                   ),
//                                 )),
//                             Container(
//                               width: 2,
//                               height: 35,
//                               color: ptLineColor(context),
//                             ),
//                             SizedBox(width: 20),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Số điện thoại',
//                                   style:
//                                       ptBody().copyWith(color: Colors.black54),
//                                 ),
//                                 Text(
//                                   widget.user.phone,
//                                   style: ptBody().copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           children: [
//                             SizedBox(
//                                 width: 60,
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.email,
//                                     color: ptPrimaryColor(context),
//                                     size: 28,
//                                   ),
//                                 )),
//                             Container(
//                               width: 2,
//                               height: 35,
//                               color: ptLineColor(context),
//                             ),
//                             SizedBox(width: 20),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Email',
//                                   style:
//                                       ptBody().copyWith(color: Colors.black54),
//                                 ),
//                                 Text(
//                                   widget.user.email,
//                                   style: ptBody().copyWith(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     )
//                   ])
//                 ]),
//           )),
//     );
//   }
// }
