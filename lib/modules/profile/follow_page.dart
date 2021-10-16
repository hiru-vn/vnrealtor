import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/people_widget.dart';
import 'package:datcao/share/import.dart';

class FollowPage extends StatefulWidget {
  final UserModel? user;
  final int? page;

  const FollowPage({Key? key, this.user, this.page}) : super(key: key);

  static Future navigate(UserModel? user, int page) {
    return navigatorKey.currentState!
        .push(pageBuilder(FollowPage(user: user, page: page)));
  }

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  UserBloc? _userBloc;
  List<UserModel>? followers;
  List<UserModel>? following;

  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.page!);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc!.getListUserIn(widget.user!.followerIds!).then((value) {
        if (value.isSuccess) {
          setState(() {
            followers = value.data;
          });
        } else {
          showToast(value.errMessage, context);
        }
      });
      _userBloc!.getListUserIn(widget.user!.followingIds!).then((value) {
        if (value.isSuccess) {
          setState(() {
            following = value.data;
          });
        } else {
          showToast(value.errMessage, context);
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        title: widget.user!.name,
        automaticallyImplyLeading: true,
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
                    text: 'Được theo dõi',
                  ),
                ),
                SizedBox(
                    height: 40,
                    width: deviceWidth(context) / 2 - 45,
                    child: Tab(text: 'Đang theo dõi')
                    //'Lời mời kết bạn (${_userBloc.friendRequestFromOtherUsers.length})'),
                    ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              _buildListUser(followers),
              //FriendRequestTab()
              _buildListUser(following),
            ]),
          )
        ],
      ),
    );
  }

  _buildListUser(List<UserModel>? users) {
    if (users == null)
      return ListSkeleton();
    else
      return SingleChildScrollView(
        child: Column(
          children: users.map((e) => PeopleWidget(e)).toList(),
        ),
      );
  }
}
