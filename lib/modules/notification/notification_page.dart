import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/import.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  UserBloc _userBloc;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
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
                      text: 'Thông báo mới (3)',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: deviceWidth(context) / 2 - 45,
                    child: Tab(
                        text:
                            'Lời mời kết bạn (${_userBloc.friendRequestFromOtherUsers.length})'),
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [NotificationTab(), FriendRequestTab()]),
          )
        ],
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          tileColor: ptBackgroundColor(context),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/image/avatar.jpg'),
          ),
          title: Text(
            'Cuti pit đã chia sẻ bài viết của bạn',
            style: ptBody(),
          ),
          subtitle: Text(
            '1 tháng trước',
            style: ptTiny(),
          ),
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          tileColor: ptBackgroundColor(context),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/image/avatar.jpeg'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hung Nguyen đã comment:',
                style: ptBody(),
              ),
              Text(
                '"Dự án này còn hoạt động không bạn?. Mình..."',
                style: ptSmall(),
              )
            ],
          ),
          subtitle: Text(
            '1 tháng trước',
            style: ptTiny(),
          ),
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          tileColor: ptBackgroundColor(context),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/image/avatar.jpeg'),
          ),
          title: Text(
            'Hung Nguyen đã thích bài viết của bạn',
            style: ptBody(),
          ),
          subtitle: Text(
            '1 tháng trước',
            style: ptTiny(),
          ),
        ),
      ],
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
    return ListView.builder(
      itemCount: _userBloc.friendRequestFromOtherUsers.length,
      itemBuilder: (context, index) {
        final item = _userBloc.friendRequestFromOtherUsers[index];
        return ListTile(
          onTap: () {
            ProfilePage.navigate(item.user1);
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
                Formart.timeAgo(DateTime.tryParse(item.createdAt ?? '')) ?? '',
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
                  final res = await _userBloc.acceptFriendInvite(item.id);
                  if (res.isSuccess) {
                    setState(() {
                      _userBloc.friendRequestFromOtherUsers.remove(item);
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
                  final res = await _userBloc.declineFriendInvite(item.id);
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
    );
  }
}
