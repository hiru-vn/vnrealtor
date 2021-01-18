import 'package:vnrealtor/share/import.dart';

class AppBar1 extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  final List<Widget> actions;
  final Color bgColor;
  final Widget leading;
  final String title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;

  AppBar1(
      {this.actions,
      this.bgColor,
      this.leading,
      this.title,
      this.centerTitle = false,
      this.automaticallyImplyLeading = false});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: centerTitle,
      title: Text(
        title ?? 'VNRealtor',
        style: ptBigTitle().copyWith(
            color: (bgColor != null && bgColor != Colors.white)
                ? Colors.white
                : Colors.black87),
      ),
      actions: actions,
    );
  }
}
