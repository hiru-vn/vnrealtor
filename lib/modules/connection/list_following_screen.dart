import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/connection/widgets/user_connect_item.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/load_more.dart';

class ListFollowingScreen extends StatefulWidget {
  final List<String> userFollowing;
  const ListFollowingScreen({Key key, this.userFollowing}) : super(key: key);
  static Future navigate({List<String> userFollowing}) {
    return navigatorKey.currentState.push(pageBuilder(ListFollowingScreen(
      userFollowing: userFollowing,
    )));
  }

  @override
  _ListFollowingScreenState createState() => _ListFollowingScreenState();
}

class _ListFollowingScreenState extends State<ListFollowingScreen> {
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc.getUserFollowed();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ptBackgroundColor(context),
          appBar: SecondAppBar(
            actions: [
              IconButton(icon: Icon(Icons.more_vert), onPressed: null),
            ],
            title: "Theo dõi",
          ),
          body: LoadMoreScrollView(
            scrollController: _userBloc.usersFollowedScrollController,
            onLoadMore: () {
              // _groupBloc.loadMoreNewFeedGroup();
            },
            list: RefreshIndicator(
              color: ptPrimaryColor(context),
              onRefresh: () async {
                audioCache.play('tab3.mp3');
                _userBloc.getUserFollowed();
              },
              child: ListView.separated(
                controller: _userBloc.usersFollowedScrollController,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                ),
                itemCount: _userBloc.isLoadingUsersIn
                    ? 10
                    : _userBloc.usersFollowed.length,
                itemBuilder: (context, index) => _userBloc.isLoadingUsersIn
                    ? UserConnectItemLoading()
                    : UserConnectItem(
                        user: _userBloc.usersFollowed[index],
                        actions: [],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
