import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_bottom_navigation_bar.dart' as cbn;
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class BottomTabModel {
  final bool isNoti;
  final String title;
  final IconData icon;
  final IconData iconActive;

  BottomTabModel(this.isNoti, this.title, this.icon, this.iconActive);
}

class BottomNavigator extends StatefulWidget {
  final int selectedIndex;
  final List<BottomTabModel> list;
  final Function(int) onSelect;

  BottomNavigator(
      {Key key,
      @required this.selectedIndex,
      @required this.list,
      @required this.onSelect})
      : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  NotificationBloc _notificationBloc;
  AuthBloc _authBloc;

  @override
  Widget build(BuildContext context) {
    _notificationBloc = Provider.of<NotificationBloc>(context);
    _authBloc = Provider.of(context);
    final List<BottomNavigationBarItem> bottomNavBarItems = widget.list
        .map(
          (e) => BottomNavigationBarItem(
            // label: e.title,
            title: SizedBox.shrink(),
            icon: Stack(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      e.icon,
                    ),
                  ),
                ),
                // if (_notificationBloc.notifications
                //         .any((element) => (!element.seen)) &&
                //     e.isNoti)
                // Positioned(
                //   top: 2,
                //   left: deviceWidth(context) / 8 + 6,
                //   child: Container(
                //     width: 8,
                //     height: 8,
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       shape: BoxShape.circle,
                //     ),
                //   ),
                // ),
                if ((_authBloc?.userModel?.notiCount ?? 0) > 0 && e.isNoti)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      child: Center(
                        child: Text(
                          _authBloc?.userModel?.notiCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            activeIcon: Stack(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.transparent),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      e.iconActive,
                    ),
                  ),
                ),
                if ((_authBloc?.userModel?.notiCount ?? 0) > 0 && e.isNoti)
                  Positioned(
                    top: 2,
                    right: 3,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        )
        .toList();
    return cbn.BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconSize: 23,
      selectedFontSize: 24,
      selectedItemColor: ptPrimaryColor(context),
      unselectedItemColor: ptPrimaryColor(context),
      type: cbn.BottomNavigationBarType.fixed,
      items: bottomNavBarItems,
      currentIndex: widget.selectedIndex,
      onTap: widget.onSelect,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedLabelStyle: ptTiny(),
      unselectedLabelStyle: ptTiny(),
    );
  }
}
