import 'dart:async';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/invite_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/services/firebase_service.dart';
import 'package:datcao/modules/setting/connectivity.dart';
import 'package:datcao/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry/sentry.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/splash.dart';
import 'package:datcao/modules/bloc/notification_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/bloc/verification_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:datcao/utils/app_internalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:flutter/services.dart';
import 'share/widget/empty_widget.dart';
import 'package:bot_toast/bot_toast.dart';

// final _sentry = SentryClient(
//     dsn:
//         "https://ab7fbe46a1634b98b918535d535962ea@o396604.ingest.sentry.io/5596357");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FbdynamicLink.initDynamicLinks();
  // CallKeep.setup();
  ConnectionStatusSingleton.getInstance().initialize();
  runZonedGuarded(() async {
    await Sentry.init(
      (options) {
        options.dsn =
            'https://ab7fbe46a1634b98b918535d535962ea@o396604.ingest.sentry.io/5596357';
      },
    );
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        .then((_) {
      runApp(MyApp());
    });
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

Image splash1 = Image.asset(
  'assets/image/bg_splash_1.png',
  fit: BoxFit.fitWidth,
);
Image splash2 = Image.asset(
  'assets/image/bg_splash_2.png',
  fit: BoxFit.fitWidth,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();
    precacheImage(splash1.image, context);
    precacheImage(splash2.image, context);
    initMarkerIcon();

    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    Future.delayed(Duration(seconds: 2), () {
      // prevent splash no internet when open app
      _connectionChangeStream =
          connectionStatus.connectionChange.listen(connectionChanged);
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  void dispose() {
    _connectionChangeStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Responsive.init(constraints, orientation);
        return GestureDetector(
          onTap: () {
            // if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).requestFocus(FocusNode());
            // }
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
                    create: (context) => InviteBloc.instance,
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
                  ChangeNotifierProvider(
                    create: (context) => PagesBloc.instance,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => GroupBloc.instance,
                  ),
                ],
                child: isOffline
                    ? MaterialApp(
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
                        themeMode: ThemeMode.system,
                        darkTheme: dartTheme,
                        home: Material(
                          child: Center(
                            child: EmptyWidget(
                              assetImg: 'assets/image/no_internet.png',
                              title: 'Không có kết nối mạng',
                              content:
                                  'Ứng dụng đang chờ thiết bị kết nối mạng để hoạt động trở lại',
                            ),
                          ),
                        ),
                      )
                    : OverlaySupport(
                        child: MaterialApp(
                          builder: BotToastInit(), //1. call BotToastInit
                          navigatorObservers: [BotToastNavigatorObserver()],
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
                          themeMode: ThemeMode.system,
                          darkTheme: dartTheme,
                          navigatorKey: navigatorKey,
                          home: SplashPage(),
                        ),
                      ),
              );
            }),
          ),
        );
      });
    });
  }
}
