import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/connection/connect_screen.dart';
import 'package:datcao/modules/connection/list_following_screen.dart';
import 'package:datcao/modules/connection/widgets/connection_item.dart';
import 'package:datcao/share/import.dart';

class ManagerConnectionScreen extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState
        .push(pageBuilder(ManagerConnectionScreen()));
  }

  const ManagerConnectionScreen({Key key}) : super(key: key);

  @override
  _ManagerConnectionScreenState createState() =>
      _ManagerConnectionScreenState();
}

class _ManagerConnectionScreenState extends State<ManagerConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ptBackgroundColor(context),
          appBar: AppBar(
            elevation: 0,
            brightness: ptBrightness(context),
            leading: IconButton(
                icon: Image.asset(
                  "assets/image/back_icon.png",
                  color: Colors.grey,
                  width: 30,
                ),
                onPressed: () => Navigator.pop(context)),
            actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: null)],
            title: Center(
                child: AutoSizeText("Quản lý các mối liên kết",
                    maxLines: 1,
                    style: roboto().copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.grey,
                    ))),
          ),
          body: Container(
            child: Column(
              children: [
                ConnectionItem(
                  onTap: () => ConnectScreen.navigate(),
                  preIcon: Image.asset(
                    "assets/image/icon_connect.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Kết nối",
                  subIcon:
                      Text("${AuthBloc.instance.userModel.followerIds.length}"),
                ),
                Divider(
                  height: 1,
                ),
                ConnectionItem(
                  onTap: () => showUndoneFeature(context, ["Danh bạ"]),
                  preIcon: Image.asset(
                    "assets/image/phonebook_icon.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Danh bạ",
                  subIcon: Text("0"),
                ),
                Divider(
                  height: 1,
                ),
                ConnectionItem(
                  onTap: () => ListFollowingScreen.navigate(),
                  preIcon: Image.asset(
                    "assets/image/group_icon.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Theo dõi",
                  subIcon: Text(
                      "${AuthBloc.instance.userModel.followingIds.length}"),
                ),
                Divider(
                  height: 1,
                ),
                ConnectionItem(
                  preIcon: Image.asset(
                    "assets/image/group_icon.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Nhóm",
                  subIcon: Text("212"),
                ),
                Divider(
                  height: 1,
                ),
                ConnectionItem(
                  preIcon: Image.asset(
                    "assets/image/flag_icon.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Trang",
                  subIcon: Text("212"),
                ),
                Divider(
                  height: 1,
                ),
                ConnectionItem(
                  preIcon: Image.asset(
                    "assets/image/hastag_icon.png",
                    width: 30,
                    height: 30,
                  ),
                  text: "Hastag",
                  subIcon: Text("212"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
