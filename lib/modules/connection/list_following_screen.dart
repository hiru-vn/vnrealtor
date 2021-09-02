import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/connection/connect_screen.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';

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
  List<UserModel> _users;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _userBloc.getListUserIn(widget.userFollowing).then((value) {
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
          ),
        ),
      ),
    );
  }
}
