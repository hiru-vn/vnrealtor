import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/connection/connect_screen.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';

class ListFollowingScreen extends StatefulWidget {
  const ListFollowingScreen({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(ListFollowingScreen()));
  }

  @override
  _ListFollowingScreenState createState() => _ListFollowingScreenState();
}

class _ListFollowingScreenState extends State<ListFollowingScreen> {
  UserBloc _userBloc;
  List<UserModel> _users;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc
          .getListUserIn(AuthBloc.instance.userModel.followingIds)
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
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
                icon: Image.asset(
                  "assets/image/back_icon.png",
                  color: Colors.grey,
                  width: 30,
                ),
                onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(icon: Icon(Icons.more_vert), onPressed: null),
            ],
            title: Center(
                child: AutoSizeText("Theo dõi",
                    maxLines: 1,
                    style: roboto().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey,
                    ))),
          ),
          body: Container(
            height: deviceHeight(context),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _users != null
                            ? Row(
                                children: [
                                  Container(
                                    height: 40,
                                    child: Text(
                                      "${_users.length} đang theo dõi",
                                      style: roboto().copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Spacer(),
                                  // IconButton(
                                  //     icon: Container(
                                  //       width: 32,
                                  //       height: 32,
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: HexColor.fromHex("#F5F9FF"),
                                  //       ),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Image.asset(
                                  //           "assets/image/icon_search.png",
                                  //           width: 15,
                                  //           height: 15,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     onPressed: () => showUndoneFeature(
                                  //         context, ["Tìm kiếm"])),
                                  // IconButton(
                                  //   icon: Container(
                                  //     width: 32,
                                  //     height: 32,
                                  //     decoration: BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       color: HexColor.fromHex("#F5F9FF"),
                                  //     ),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Image.asset(
                                  //         "assets/image/icon_filter.png",
                                  //         width: 15,
                                  //         height: 15,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   onPressed: () => showModalBottomSheet(
                                  //     backgroundColor: Colors.transparent,
                                  //     context: context,
                                  //     builder: (context) => FilterConnectUser(
                                  //       onFilter: (value) => _filterUser(value),
                                  //     ),
                                  //   ),
                                  // )
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
