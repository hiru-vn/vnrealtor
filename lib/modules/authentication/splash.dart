import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/introduce.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/home_page.dart';
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
        Duration(milliseconds: 1000),
        () async {
          final firstTime =
              (await SPref.instance.getBool('first_time')) ?? true;
          if (firstTime) {
            IntroducePage.navigate();
            SPref.instance.setBool('first_time', false);
            return;
          }
          final isLog = await _authBloc.checkToken();
          if (!isLog) {
            LoginPage.navigate();
          } else {
            final res = await _authBloc.getUserInfo();
            if (res.isSuccess) {
              await Future.wait([
                FcmService.instance.init(),
                PostBloc.instance.init(),
                UserBloc.instance.init(),
              ]);
              HomePage.navigate();
            } else
              IntroducePage.navigate();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: deviceHeight(context),
            width: deviceWidth(context),
          ),
          Positioned(
            bottom: -150,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(width: deviceWidth(context), child: splash)),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: deviceHeight(context) / 6),
              child: SizedBox(
                width: deviceWidth(context) / 2.5,
                child: ShowUp(
                  child: Image.asset('assets/image/logo_full_white.png'),
                  delay: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
