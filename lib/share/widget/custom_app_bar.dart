import 'package:datcao/share/import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  const CustomAppBar(
      {Key key, this.leading, this.title, this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ptMainColor(), ptSecondColor()],
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [leading, title, ...actions],
      ),
    );
  }
}
