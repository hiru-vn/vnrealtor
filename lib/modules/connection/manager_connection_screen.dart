import 'package:auto_size_text/auto_size_text.dart';
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
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor.fromHex("#E5E5E5"),
          appBar: AppBar(
            backgroundColor: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/icon_connect.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Kết nối",
                    subIcon: Text("212"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/phonebook_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Danh bạ",
                    subIcon: Text("212"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/group_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Theo dõi",
                    subIcon: Text("212"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/group_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Nhóm",
                    subIcon: Text("212"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/flag_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Trang",
                    subIcon: Text("212"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConnectionItem(
                    preIcon: Image.asset(
                      "assets/image/hastag_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    text: "Hastag",
                    subIcon: Text("212"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
