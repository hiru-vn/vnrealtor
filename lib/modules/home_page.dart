import 'dart:io';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/group/group_page.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/notification/notification_page.dart';
import 'package:datcao/modules/pages/pages/pages_page.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/modules/profile/profile_page.dart';
import 'package:datcao/modules/setting/setting_page.dart';
import 'package:datcao/share/import.dart';

import 'bottom_navigator.dart';

class HomePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState
        .pushAndRemoveUntil(pageBuilder(HomePage()), (route) => false);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool flag = await showConfirmDialog(context, 'Thoát ứng dụng?',
            confirmTap: () {}, navigatorKey: navigatorKey);
        return flag;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            PostPage(),
            NotificationPage(),
            GroupPage(),
            PagesPage(),
            ProfilePage(),
            SettingPage(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: BottomNavigator(
          selectedIndex: _selectedIndex,
          list: [
            BottomTabModel(0, 'Trang chủ', MdiIcons.homeOutline, MdiIcons.home),
            BottomTabModel(_authBloc.userModel?.notiCount ?? 0, 'Thông báo',
                MdiIcons.bellOutline, MdiIcons.bell),
            BottomTabModel(
                0, 'Nhóm', MdiIcons.accountGroupOutline, MdiIcons.accountGroup),
            BottomTabModel(0, 'Trang', Icons.flag_outlined, Icons.flag_rounded),
            BottomTabModel(0, 'Hồ sơ', Icons.person_outline, Icons.person),
            BottomTabModel(0, 'Menu', Icons.menu, Icons.menu_outlined),
          ],
          onSelect: (index) {
            if (Platform.isIOS) audioCache.play('tab3.mp3');
            if (index == 0 && _selectedIndex == 0) {
              if (PostBloc.instance.feedScrollController != null) {
                PostBloc.instance.getNewFeed(
                    filter: GraphqlFilter(limit: 10, order: "{updatedAt: -1}"));
                PostBloc.instance.feedScrollController.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              }
            }
            if (index == 1 && _selectedIndex == 1) {
              if (UserBloc.instance.profileScrollController != null) {
                NotificationBloc.instance.notiScrollController.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              }
            }
            if (index == 4 && _selectedIndex == 4) {
              if (UserBloc.instance.profileScrollController != null) {
                UserBloc.instance.profileScrollController.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              }
            }

            setState(() {
              _selectedIndex = index;
            });

            if (index == 1) {
              UserBloc.instance.seenAllNoti();
            }
            // if (index == 1) {
            //   if (AuthBloc.instance.userModel.messNotiCount != 0) {
            //     AuthBloc.instance.userModel.messNotiCount = 0;
            //     UserBloc.instance.seenNotiMess();
            //   }
            // }
          },
        ),
      ),
    );
  }
}
