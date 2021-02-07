import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/post/post_widget.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/share/widget/empty_widget.dart';

class ProfileOtherPage extends StatefulWidget {
  final UserModel user;

  const ProfileOtherPage(this.user);
  static Future navigate(UserModel user) {
    return navigatorKey.currentState.push(pageBuilder(ProfileOtherPage(user)));
  }

  @override
  _ProfileOtherPageState createState() => _ProfileOtherPageState();
}

class _ProfileOtherPageState extends State<ProfileOtherPage> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of<UserBloc>(context);
      _postBloc = Provider.of<PostBloc>(context);
      _postBloc.getMyPost().then((value) {
        if (!value.isSuccess) showToast(value.errMessage, context);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar1(
        title: widget.user.name,
        automaticallyImplyLeading: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: ProfileCard(
                user: widget.user,
              ),
            ),
          ];
        },
        body: Container(
          child: _postBloc.myPosts == null
              ? kLoadingSpinner
              : (_postBloc.myPosts.length == 0
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
                      content: widget.user.name + ' chưa có bài đăng nào.',
                    )),
        ),
      ),
    );
  }
}

class ProfileOtherPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  ProfileOtherPageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            GestureDetector(
              onTap: () {
                showAlertDialog(context, 'Đang phát triển',
                    navigatorKey: navigatorKey);
              },
              child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(
                    MdiIcons.menu,
                    size: 26,
                  )),
            )
          ],
        ),
      ),
      color: ptSecondaryColor(context),
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
  bool initFetchStatus = false;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
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
          elevation: 3,
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
                            backgroundImage: widget.user.avatar != null
                                ? NetworkImage(widget.user.avatar)
                                : AssetImage('assets/image/avatar.jpeg'),
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
                                Text(
                                  widget.user.name ?? '',
                                  style: ptBigTitle(),
                                ),
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
                                        '200',
                                        style: ptTitle(),
                                      ),
                                      Text(
                                        'bài viết',
                                        style: ptBody(),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '200',
                                        style: ptTitle(),
                                      ),
                                      Text(
                                        'follower',
                                        style: ptBody(),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '200',
                                        style: ptTitle(),
                                      ),
                                      Text(
                                        'following',
                                        style: ptBody(),
                                      )
                                    ],
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
                  Text(
                      'Chuyên cung cấp dịch vụ nhà đất, căn hộ cho thuê ở quận Tân Phú, Hồ Chí Minh'),
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
                      SizedBox(
                          width: 31,
                          height: 31,
                          child: Image.asset('assets/image/facebook_icon.png')),
                      SizedBox(width: 15),
                      SizedBox(
                          width: 35,
                          height: 35,
                          child: Image.asset('assets/image/gmail_icon.png'))
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: ptPrimaryColor(context))),
                          child: Center(
                            child: Text(
                              'Theo dõi',
                              style: ptTitle(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: ptPrimaryColor(context))),
                          child: Center(
                            child: Text(
                              'Nhắn tin',
                              style: ptTitle(),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  SizedBox(height: 10),
                ]),
          )),
    );
  }
}
