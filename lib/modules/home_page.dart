import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/bloc/notification_bloc.dart';
import 'package:vnrealtor/modules/inbox/inbox_bloc.dart';
import 'package:vnrealtor/modules/notification/notification_page.dart';
import 'package:vnrealtor/modules/post/post_page.dart';
import 'package:vnrealtor/modules/setting/setting_page.dart';
import 'package:vnrealtor/modules/inbox/inbox_list.dart';
import 'package:vnrealtor/share/import.dart';

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
      InboxList(),
      NotificationPage(),
      SettingPage(),
    ]);

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
          listIcons: [
            MdiIcons.homeOutline,
            MdiIcons.chatOutline,
            MdiIcons.bellOutline,
            Icons.settings_outlined
          ],
          onSelect: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) //message
              InboxBloc.instance
                  .getList20InboxGroup(AuthBloc.instance.userModel.id);
            if (index == 2)
              NotificationBloc.instance.getListNotification(
                  filter: GraphqlFilter(order: '{createdAt: -1}'));
          },
        ),
      ),
    );
  }
}
