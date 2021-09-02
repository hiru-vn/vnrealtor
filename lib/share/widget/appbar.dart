import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/profile/profile_page.dart';
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
      backgroundColor: bgColor ?? Colors.white,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      brightness: Brightness.light,
      centerTitle: centerTitle,
      title: Text(
        title ?? 'Datcao',
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
          audioCache.play('tab3.mp3');
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

class SecondAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final String title;
  final List<Widget> actions;
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const SecondAppBar({
    Key key,
    this.leading,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ptPrimaryColor(context),
      brightness: Theme.of(context).brightness,
      leading: leading,
      actions: actions,
      title: Center(
          child: AutoSizeText(
        title,
        style: ptBigTitle(),
      )),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int unReadCount;
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  const MainAppBar({
    Key key,
    this.unReadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = unReadCount > 9 ? '9+' : unReadCount.toString();
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      brightness: Theme.of(context).brightness,
      leading: GestureDetector(
        child: Icon(
          Icons.account_circle_outlined,
          size: 32,
        ),
        onTap: () {
          audioCache.play('tab3.mp3');
          ProfilePage.navigate();
        },
      ),
      title: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(30),
            color: ptPrimaryColor(context)),
        child: TextFormField(
            decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: 'Tìm kiếm',
          hintStyle: roboto(),
          suffixIcon: GestureDetector(
            child: Icon(
              Icons.qr_code,
            ),
            onTap: () => print("QR code"),
          ),
        )),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            audioCache.play('tab3.mp3');
            AuthBloc.instance.userModel.messNotiCount = 0;
            UserBloc.instance.seenNotiMess();
            InboxList.navigate();
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 10, right: 12),
                child: Container(
                    width: 42,
                    height: 42,
                    child: Icon(
                      MdiIcons.chatProcessingOutline,
                      size: 32,
                    )),
              ),
              if (unReadCount > 0)
                Positioned(
                  top: 9,
                  right: 11,
                  child: Container(
                    padding: EdgeInsets.all(count.length == 2 ? 3.5 : 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(count,
                        style: ptTiny().copyWith(
                            fontSize: 10.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
