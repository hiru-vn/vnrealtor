import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/connection/manager_connection_screen.dart';
import 'package:datcao/modules/connection/widgets/connection_item.dart';
import 'package:datcao/modules/connection/widgets/list_suggest_item.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/share/import.dart';

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
  PagesBloc _pagesBloc;
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
    if (_pagesBloc == null) {
      _pagesBloc = Provider.of<PagesBloc>(context);
      _pagesBloc.suggestFollow();
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

  void onDeleteUser(String uID) {
    _userBloc.deleteSuggestFollow(uID);
  }

  void onFolowUser(String uID) {
    _userBloc.followUser(uID);
    _userBloc.deleteSuggestFollow(uID);
  }

  void onDeleteGroup(String id) {
    _groupBloc.deleteSuggestGroup(id);
  }

  void onJoinGroup(String id) {
    _groupBloc.joinGroup(id);
  }

  void onDeletePage(String id) {
    _pagesBloc.deleteSuggestPage(id);
  }

  void onFollowPage(String id) {
    _pagesBloc.followPage(id);
    _pagesBloc.suggestFollow();
  }

  _refresh() async {
    setState(() {
      _userBloc.suggestFollow();
      _groupBloc.getSuggestGroup();
      _pagesBloc.suggestFollow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MainAppBar(
        unReadCount: _authBloc.userModel.messNotiCount ?? 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ConnectionItem(
                      onTap: () => ManagerConnectionScreen.navigate(),
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
                      onTap: () => print("bbb"),
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
                      color: Theme.of(context).primaryColor,
                      height: 50,
                      child: TabBar(
                        tabs: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Người dùng / Nhóm"),
                          ),
                          Align(
                              alignment: Alignment.center, child: Text("Trang"))
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
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                        controller: _tabController,
                        labelColor: ptSecondColor(),
                        unselectedLabelColor: Theme.of(context).accentColor,
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
                      return _userBloc.suggestFollowUsers.length == 0 &&
                              _groupBloc.suggestGroup.length == 0
                          ? Container(
                              child: Center(
                              child: Text("Danh sách trống"),
                            ))
                          : Column(
                              children: [
                                _userBloc.suggestFollowUsers.length > 0
                                    ? ListUserConnection(
                                        users: _userBloc.suggestFollowUsers,
                                        onDeleteUser: (uID) {
                                          onDeleteUser(uID);
                                        },
                                        onConnectUser: (id) {
                                          onFolowUser(id);
                                        },
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                _groupBloc.isLoadGroupSuggest ||
                                        _groupBloc.suggestGroup.length > 0
                                    ? ListGroupConnection(
                                        groups: _groupBloc.suggestGroup,
                                        onDeleteGroup: (id) {
                                          onDeleteGroup(id);
                                        },
                                        onConnectGroup: (id) {
                                          onJoinGroup(id);
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            );
                    } else
                      return (_pagesBloc.isLoadingSuggest ||
                              _pagesBloc.suggestFollowPage.length > 0)
                          ? ListPageConnection(
                              pages: _pagesBloc.suggestFollowPage,
                              onConnectPage: (id) {
                                onFollowPage(id);
                              },
                              onDeletePage: (id) {
                                onDeletePage(id);
                              },
                              pagesBloc: _pagesBloc,
                            )
                          : Container(
                              child: Center(
                                child: Text("Danh sách trống"),
                              ),
                            );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
