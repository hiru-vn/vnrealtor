import 'package:vnrealtor/modules/bloc/notification_bloc.dart';
import 'package:vnrealtor/share/import.dart';
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

  @override
  Widget build(BuildContext context) {
    _notificationBloc = Provider.of<NotificationBloc>(context);
    final List<BottomNavigationBarItem> bottomNavBarItems = widget.list
        .map(
          (e) => BottomNavigationBarItem(
            label: e.title,
            icon: Stack(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Icon(
                      e.icon,
                    ),
                  ),
                ),
                if (_notificationBloc.notifications
                        .any((element) => (!element.seen)) &&
                    e.isNoti)
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
                  if (_notificationBloc.notifications
                          .any((element) => (!element.seen)) &&
                      e.isNoti)
                    Positioned(
                      top: 0,
                      left: deviceWidth(context) / 8 + 5,
                      child: Container(
                        padding: EdgeInsets.all(2.4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            _notificationBloc.notifications
                                .where((element) => (!element.seen))
                                .toList()
                                .length
                                .toString(),
                            style: TextStyle(
                              color: ptPrimaryColor(context),
                              fontSize: 10,
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
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ptSecondaryColor(context)),
                  child: Center(
                    child: Icon(
                      e.iconActive,
                    ),
                  ),
                ),
                if (_notificationBloc.notifications
                        .any((element) => (!element.seen)) &&
                    e.isNoti)
                  Positioned(
                    top: 2,
                    left: deviceWidth(context) / 8 + 6,
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
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconSize: 24,
      selectedItemColor: ptPrimaryColor(context),
      unselectedItemColor: ptPrimaryColor(context),
      type: BottomNavigationBarType.fixed,
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
