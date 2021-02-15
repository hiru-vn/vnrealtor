import 'package:vnrealtor/modules/bloc/notification_bloc.dart';
import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/model/notification.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/profile/profile_other_page.dart';
import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/share/widget/empty_widget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  UserBloc _userBloc;
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _notificationBloc = Provider.of<NotificationBloc>(context);
      _notificationBloc.getListNotification(
          filter: GraphqlFilter(order: '{createdAt: -1}'));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        title: 'Thông báo',
        actions: [
          Center(child: AnimatedSearchBar()),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                indicatorColor: ptPrimaryColor(context),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black87,
                unselectedLabelStyle:
                    TextStyle(fontSize: 14, color: Colors.black54),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
                tabs: [
                  SizedBox(
                    height: 40,
                    width: deviceWidth(context) / 2 - 45,
                    child: Tab(
                      text: 'Thông báo mới',
                    ),
                  ),
                  SizedBox(
                      height: 40,
                      width: deviceWidth(context) / 2 - 45,
                      child: Tab(text: 'Người theo dõi')
                      //'Lời mời kết bạn (${_userBloc.friendRequestFromOtherUsers.length})'),
                      ),
                ]),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              NotificationTab(
                list: _notificationBloc.notifications,
              ),
              //FriendRequestTab()
              FollowTab(list: _userBloc.followersIn7Days,)
            ]),
          )
        ],
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  final List<NotificationModel> list;

  const NotificationTab({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return list.length > 0
        ? RefreshIndicator(
            color: ptPrimaryColor(context),
            onRefresh: () async {
              await NotificationBloc.instance.getListNotification(
                  filter: GraphqlFilter(order: '{createdAt: -1}'));
              return;
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => ListTile(
                tileColor: ptBackgroundColor(context),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      (list[index].image == null || list[index].image == '')
                          ? AssetImage('assets/image/logo.png')
                          : NetworkImage(list[index].image),
                ),
                title: Text(
                  list[index].body,
                  style: ptBody(),
                ),
                subtitle: Text(
                  Formart.timeAgo(DateTime.tryParse(list[index].createdAt)) ??
                      '',
                  style: ptTiny(),
                ),
              ),
            ),
          )
        : EmptyWidget(
            assetImg: 'assets/image/no_notification.png',
            title: 'Bạn chưa có thông báo mới',
          );
  }
}

class FriendRequestTab extends StatefulWidget {
  @override
  _FriendRequestTabState createState() => _FriendRequestTabState();
}

class _FriendRequestTabState extends State<FriendRequestTab> {
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _userBloc.friendRequestFromOtherUsers.length != 0
        ? RefreshIndicator(
            onRefresh: () async {
              await _userBloc.getFriendRequestFromOtherUsers();
              return;
            },
            child: ListView.builder(
              itemCount: _userBloc.friendRequestFromOtherUsers.length,
              itemBuilder: (context, index) {
                final item = _userBloc.friendRequestFromOtherUsers[index];
                return ListTile(
                  onTap: () {
                    ProfileOtherPage.navigate(item.user1);
                  },
                  tileColor: ptBackgroundColor(context),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage: item.user1.avatar != null
                        ? NetworkImage(item.user1.avatar)
                        : AssetImage('assets/image/avatar.jpeg'),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        '${item.user1.name} đã gửi lời mời kết bạn',
                        style: ptBody(),
                      ),
                      Text(
                        Formart.timeAgo(
                                DateTime.tryParse(item.createdAt ?? '')) ??
                            '',
                        style: ptTiny().copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      FlatButton(
                        height: 32,
                        padding: EdgeInsets.all(0),
                        color: ptPrimaryColor(context),
                        child: Text(
                          'Đồng ý',
                          style: ptSmall().copyWith(color: Colors.white),
                        ),
                        onPressed: () async {
                          setState(() {
                            _userBloc.friendRequestFromOtherUsers.remove(item);
                          });
                          final res =
                              await _userBloc.acceptFriendInvite(item.id);
                          if (res.isSuccess) {
                            setState(() {
                              _userBloc.friendRequestFromOtherUsers
                                  .remove(item);
                            });
                          } else {
                            showToast(res.errMessage, context);
                            setState(() {
                              _userBloc.friendRequestFromOtherUsers.add(item);
                            });
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                        height: 32,
                        padding: EdgeInsets.all(0),
                        color: Colors.grey[400],
                        child: Text(
                          'Từ chối',
                          style: ptSmall().copyWith(color: Colors.white),
                        ),
                        onPressed: () async {
                          setState(() {
                            _userBloc.friendRequestFromOtherUsers.remove(item);
                          });
                          final res =
                              await _userBloc.declineFriendInvite(item.id);
                          if (res.isSuccess) {
                          } else {
                            showToast(res.errMessage, context);
                            setState(() {
                              _userBloc.friendRequestFromOtherUsers.add(item);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : EmptyWidget(
            assetImg: 'assets/image/no_user.png',
            title: 'Không có người theo dõi mới',
            content: 'Đăng bài có nhiều tương tác để có thêm người theo dõi',
          );
  }
}

class FollowTab extends StatelessWidget {
  final List<UserModel> list;

  const FollowTab({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return list.length > 0
        ? RefreshIndicator(
            color: ptPrimaryColor(context),
            onRefresh: () async {
              await NotificationBloc.instance.getListNotification(
                  filter: GraphqlFilter(order: '{createdAt: -1}'));
              return;
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => ListTile(
                tileColor: ptBackgroundColor(context),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      (list[index].avatar == null || list[index].avatar == '')
                          ? AssetImage('assets/image/logo.png')
                          : NetworkImage(list[index].avatar),
                ),
                title: Text(
                  list[index].name + ' đã theo dõi bạn',
                  style: ptBody(),
                ),
                subtitle: Text(
                  Formart.timeAgo(DateTime.tryParse(list[index].createdAt)) ??
                      '',
                  style: ptTiny(),
                ),
              ),
            ),
          )
        : EmptyWidget(
            assetImg: 'assets/image/no_user.png',
            title: 'Bạn không có lượt theo dõi nào trong 7 ngày qua',
            content: 'Đăng bài và tương tác nhiều để có thêm lượt theo dõi',
          );
  }
}
