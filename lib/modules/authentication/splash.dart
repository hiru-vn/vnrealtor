import 'package:vnrealtor/main.dart';
import 'package:vnrealtor/modules/authentication/introduce.dart';
import 'package:vnrealtor/share/import.dart';

class SplashPage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState.pushReplacement(pageBuilder(SplashPage()));
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => IntroducePage.navigate());
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
