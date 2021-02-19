import 'package:datcao/share/import.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBar1 extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  final List<Widget> actions;
  final Color textColor;
  final Color bgColor;
  final Widget leading;
  final String title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;

  AppBar1(
      {this.actions,
      this.bgColor,
      this.leading,
      this.textColor,
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
        style: ptTitle().copyWith(
            color: textColor != null
                ? textColor
                : ((bgColor != null && bgColor != Colors.white)
                    ? Colors.white
                    : Colors.black87),
            fontSize: 15.5),
      ),
      actions: actions,
    );
  }
}

class AppBar2 extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final String title;
  final List<Widget> actions;

  AppBar2(this.title, {this.actions});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 12, bottom: 10, right: 10),
          child: Row(
            children: [
              SizedBox(width: 40, child: BackButton(color: Colors.white)),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: ptBigTitle().copyWith(color: Colors.white),
                  ),
                ),
              ),
              if (actions != null) ...actions else SizedBox(width: 40)
            ],
          )),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HexColor('#0c818e'), HexColor('#37d0bb')],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

innerAppBar(BuildContext context, String title,
        {List<Widget> actions, final Color bgColor}) =>
    AppBar(
      elevation: 0,
      backgroundColor: bgColor ?? ptPrimaryColor(context),
      title: Text(
        title,
        style: GoogleFonts.nunito(
            color: Colors.white, fontWeight: FontWeight.w400),
      ),
      leading: GestureDetector(
        onTap: () {
          navigatorKey.currentState.maybePop();
        },
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
              child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
