import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/guest/guest_feed_page.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/profile/verify_company.dart';
import 'package:datcao/modules/services/firebase_service.dart';
import 'package:datcao/share/import.dart';

class SplashPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.pushReplacement(pageBuilder(SplashPage()));
  }

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      Future.delayed(
        Duration(milliseconds: 500),
        () async {
          final firstTime =
              (await SPref.instance.getBool('first_time')) ?? true;
          if (firstTime) {
            GuestFeedPage.navigate();
            SPref.instance.setBool('first_time', false);
            return;
          }
          final isLog = await _authBloc.checkToken();
          if (!isLog) {
            //LoginPage.navigate();
            GuestFeedPage.navigate();
            Future.delayed(Duration(milliseconds: 600),
                () => NotificationBloc.handleInitActions());
          } else {
            final res = await _authBloc.getUserInfo();
            if (res.isSuccess) {
              await Future.wait([
                FcmService.instance.init(),
                PostBloc.instance.init(),
                UserBloc.instance.init(),
              ]);
              HomePage.navigate();
              if (_authBloc.userModel.role == 'COMPANY' &&
                  !_authBloc.userModel.isVerify &&
                  _authBloc.userModel.isPendingVerify) VerifyCompany.navigate();
              Future.delayed(Duration(milliseconds: 600),
                  () => NotificationBloc.handleInitActions());
            } else
              GuestFeedPage.navigate();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: deviceHeight(context),
            width: deviceWidth(context),
            color: ptPrimaryColor(context),
          ),
          Positioned(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(width: deviceWidth(context), child: splash2)),
          ),
          Center(
            child: ShowUp(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 200,
                    ),
                    child: Image.asset(isDarkMode
                        ? 'assets/image/vertical_logo_dark.png'
                        : 'assets/image/vertical_logo.png'),
                  ),
                  Text("Uy tín - Nhanh chóng - An toàn",
                      style: roboto_18_700().copyWith(
                          color: isDarkMode
                              ? Colors.white
                              : ptMainColor(context))),
                  Spacer(),
                ],
              ),
              delay: 100,
            ),
          ),
        ],
      ),
    );
  }
}
