import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_bottom_navigation_bar.dart' as cbn;
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class BottomTabModel {
  final int counter;
  final String title;
  final IconData icon;
  final IconData iconActive;

  BottomTabModel(this.counter, this.title, this.icon, this.iconActive);
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
  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavBarItems = widget.list
        .map(
          (e) => BottomNavigationBarItem(
            // label: e.title,

            label: e.title,
            icon: Stack(
              children: [
                Center(
                  child: Icon(
                    e.icon,
                    color: HexColor.fromHex("#BBBBBB"),
                  ),
                ),
                if (e.counter > 0)
                  Positioned(
                    top: 0,
                    right: 15,
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
                          e.counter.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
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
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    e.iconActive,
                    // color: ptMainColor(context),
                  ),
                ),
                // if (e.counter > 0)
                //   Positioned(
                //     top: 2,
                //     right: 3,
                //     child: Container(
                //       width: 8,
                //       height: 8,
                //       decoration: BoxDecoration(
                //         color: Colors.red,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        )
        .toList();
    return cbn.BottomNavigationBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      iconSize: 24,
      selectedIconTheme: Theme.of(context).iconTheme,
      selectedFontSize: 25,
      selectedItemColor: Theme.of(context).iconTheme.color,
      unselectedItemColor: HexColor.fromHex("#BBBBBB"),
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
