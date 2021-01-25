import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
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
    }
    if (widget.user == null || widget.user.id == _authBloc.userModel.id) {
      isOtherUserProfile = false;
    } else {
      isOtherUserProfile = true;
    }

    super.didChangeDependencies();
  }

  // Future _getRelationShip() async {
  //   if ()
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2(
        isOtherUserProfile ? 'Thông tin người dùng' : 'Thông tin cá nhân',
        actions: [
          GestureDetector(
            onTap: () {
              UpdateProfilePage.navigate();
            },
            child: SizedBox(
              width: 40,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
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

class ProfileCard extends StatelessWidget {
  final UserModel user;

  const ProfileCard({Key key, this.user}) : super(key: key);
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
                        backgroundImage: user.avatar != null
                            ? NetworkImage(user.avatar)
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
                              user.name ?? '',
                              style:
                                  ptBigTitle().copyWith(color: Colors.black87),
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Điểm uy tín: ${user.reputationScore.toString()}',
                                  style:
                                      ptBody().copyWith(color: Colors.black54),
                                ),
                                SizedBox(width: 2),
                                Image.asset('assets/image/coin.png'),
                              ],
                            ),
                            SizedBox(height: 3),
                            Text(
                              user.role.toLowerCase() == 'agency'
                                  ? 'Nhà môi giới'
                                  : 'Người dùng cơ bản',
                              style: ptSmall().copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      if (user.id != AuthBloc.instance.userModel.id)
                        Center(
                          child: RaisedButton(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              'Kết bạn',
                              style: ptBody().copyWith(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        )
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
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
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
                            style: ptBody().copyWith(color: Colors.black54),
                          ),
                          Text(
                            user.phone,
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
                        width: 60,
                      ),
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
                            style: ptBody().copyWith(color: Colors.black54),
                          ),
                          Text(
                            user.email,
                            style: ptBody().copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
          )),
    );
  }
}
