import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/loading_widgets/shimmer_widget.dart';
import 'package:datcao/utils/role_user.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(ConnectScreen()));
  }

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  UserBloc _userBloc;
  List<UserModel> _users;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc
          .getListUserIn(AuthBloc.instance.userModel.followerIds)
          .then((value) {
        setState(() {
          _users = value.data;
        });
      });
    }
    super.didChangeDependencies();
  }

  _filterUser(int value) {
    switch (value) {
      case 1:
        setState(() {});
        break;
      case 2:
        setState(() {
          _users.sort((a, b) => a.totalPoint.compareTo(b.totalPoint));
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ptBackgroundColor(context),
          appBar: SecondAppBar(
            leading: IconButton(
              icon: Image.asset(
                "assets/image/back_icon.png",
                color: Colors.grey,
                width: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Center(
              child: AutoSizeText(
                "Kết nối",
                maxLines: 1,
                style: roboto().copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: null)],
          ),
          body: Container(
            height: deviceHeight(context),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    color: ptPrimaryColor(context),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _users != null
                            ? Row(
                                children: [
                                  Text(
                                    "${_users.length} Kết nối",
                                    style: roboto().copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      icon: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: HexColor.fromHex("#F5F9FF"),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/image/icon_search.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => showUndoneFeature(
                                          context, ["Tìm kiếm"])),
                                  IconButton(
                                    icon: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HexColor.fromHex("#F5F9FF"),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          "assets/image/icon_filter.png",
                                          width: 15,
                                          height: 15,
                                        ),
                                      ),
                                    ),
                                    onPressed: () => showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => FilterConnectUser(
                                        onFilter: (value) => _filterUser(value),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox.shrink()),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                    ),
                    itemCount: _userBloc.isLoadingUsersIn ? 10 : _users.length,
                    itemBuilder: (context, index) => _userBloc.isLoadingUsersIn
                        ? UserConnectItemLoading()
                        : UserConnectItem(
                            user: _users[index],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FilterConnectUser extends StatefulWidget {
  final Function(int) onFilter;
  const FilterConnectUser({
    Key key,
    this.onFilter,
  }) : super(key: key);

  @override
  _FilterConnectUserState createState() => _FilterConnectUserState();
}

class _FilterConnectUserState extends State<FilterConnectUser> {
  int _filter;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Spacer(),
                Text(
                  "Sắp xếp theo",
                  style: roboto()
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _filter = null;
                    });
                  },
                  child: SizedBox(
                    width: 50,
                    child: Text(
                      "Reset",
                      style: roboto()
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _filter = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: _filter == 1
                        ? Border.all(color: ptSecondColor())
                        : Border.all(color: Colors.grey),
                    color: _filter == 1 ? ptSecondColor() : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Liên hệ nhiều nhất",
                    style: roboto().copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _filter == 1 ? Colors.white : Colors.grey),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _filter = 2;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: _filter == 2
                        ? Border.all(color: ptSecondColor())
                        : Border.all(color: Colors.grey),
                    color: _filter == 2 ? ptSecondColor() : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        "Điểm uy tín",
                        style: roboto().copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _filter == 2 ? Colors.white : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Center(
            child: ExpandBtn(
              onPress: () {
                widget.onFilter(_filter);
                Navigator.pop(context);
              },
              text: "Kết quả",
              width: 100,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class UserConnectItem extends StatelessWidget {
  final UserModel user;
  const UserConnectItem({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ptPrimaryColor(context),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: user.avatar != null
                  ? CachedNetworkImageProvider(user.avatar)
                  : AssetImage('assets/image/default_avatar.png'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${user.name}",
                    style: roboto()
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "${user.totalPoint}",
                      ),
                      Image.asset(
                        "assets/image/guarantee.png",
                        width: 18,
                      )
                    ],
                  )
                ],
              ),
              Text(
                "${convertRoleUser(user.role)}",
                style: roboto()
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Spacer(),
          IconButton(icon: Icon(Icons.more_vert), onPressed: null),
          IconButton(
              icon: Image.asset(
                "assets/image/icon_send.png",
                width: 20,
              ),
              onPressed: () async {
                audioCache.play('tab3.mp3');
                showWaitingDialog(context);
                await InboxBloc.instance.navigateToChatWith(
                    user.name, user.avatar, DateTime.now(), user.avatar, [
                  AuthBloc.instance.userModel.id,
                  user.id,
                ], [
                  AuthBloc.instance.userModel.avatar,
                  user.avatar,
                ]);
                closeLoading();
              }),
        ],
      ),
    );
  }
}

class UserConnectItemLoading extends StatelessWidget {
  const UserConnectItemLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ptPrimaryColor(context),
      child: Row(
        children: [
          ShimmerWidget.cirular(width: 40, height: 40),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.rectangular(height: 10, width: 250),
              SizedBox(
                height: 10,
              ),
              ShimmerWidget.rectangular(
                height: 10,
                width: deviceWidth(context) / 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
