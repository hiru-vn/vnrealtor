import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry/sentry.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/splash.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/bloc/verification_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/themes/lightTheme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:datcao/utils/app_internalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';

final _sentry = SentryClient(
    dsn:
        "https://ab7fbe46a1634b98b918535d535962ea@o396604.ingest.sentry.io/5596357");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stackTrace) async {
      await _sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

Image splash = Image.asset(
  'assets/image/bg_splash.png',
  fit: BoxFit.fill,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(splash.image, context);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Responsive.init(constraints, orientation);
        return GestureDetector(
          onTap: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
          child: ThemeProvider(
            initTheme: lightTheme,
            child: Builder(builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => AuthBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => InboxBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => UserBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => PostBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => NotificationBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => VerificationBloc.instance,
                  ),
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    const AppInternalizationlegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('vi', 'VN'),
                  ],
                  theme: ThemeProvider.of(context),
                  navigatorKey: navigatorKey,
                  home: SplashPage(),
                ),
              );
            }),
          ),
        );
      });
    });
  }
}
