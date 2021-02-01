import 'package:vnrealtor/main.dart';
import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/authentication/introduce.dart';
import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/modules/services/firebase_service.dart';
import 'package:vnrealtor/share/import.dart';

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
          final isLog = await _authBloc.checkToken();
          if (!isLog)
            IntroducePage.navigate();
          else {
            FirebaseService.instance.init();
            final res = await _authBloc.getUserInfo();
            if (res.isSuccess)
              HomePage.navigate();
            else
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
        fit: StackFit.expand,
        children: [
          Container(
            height: deviceHeight(context),
            width: deviceWidth(context),
            child: splash,
          ),
          Center(
            child: SizedBox(
              width: deviceWidth(context) / 3.2,
              child: ShowUp(
                child: Image.asset('assets/image/logo_full_white.png'),
                delay: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
