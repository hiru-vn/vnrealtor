import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/notification/notification_page.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/modules/profile/profile_page.dart';
import 'package:datcao/modules/setting/setting_page.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/share/import.dart';

import 'bottom_navigator.dart';

class HomePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.pushReplacement(pageBuilder(HomePage()));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    _pages.addAll([
      PostPage(),
      NotificationPage(),
      ProfilePage(),
      SettingPage(),
    ]);
    InboxBloc.instance.createUser(AuthBloc.instance.userModel.id,
        AuthBloc.instance.userModel.name, AuthBloc.instance.userModel.avatar);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool flag = await showConfirmDialog(context, 'Close the app?',
            confirmTap: () {}, navigatorKey: navigatorKey);
        return flag;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        extendBody: true,
        bottomNavigationBar: BottomNavigator(
          selectedIndex: _selectedIndex,
          list: [
            BottomTabModel(
                false, 'Trang chủ', MdiIcons.homeOutline, MdiIcons.home),
            BottomTabModel(
                true, 'Thông báo', MdiIcons.bellOutline, MdiIcons.bell),
            BottomTabModel(false, 'Hồ sơ', Icons.person_outline, Icons.person),
            BottomTabModel(
                false, 'Menu', Icons.menu, Icons.menu_outlined)
          ],
          onSelect: (index) {
            setState(() {
              _selectedIndex = index;
            });
            // if (index == 1) //message
            //   InboxBloc.instance
            //       .getList20InboxGroup(AuthBloc.instance.userModel.id);
            if (index == 1) {
              UserBloc.instance.seenAllNoti();
            }
          },
        ),
      ),
    );
  }
}
