import 'package:datcao/share/import.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(AboutPage()));
  }

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        title: 'Về ứng dụng Datcao',
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          WebView(
            initialUrl:
                'https://sites.google.com/view/rebixappvnrealtorabout/trang-ch%E1%BB%A7',
            onPageStarted: (str) {},
            onPageFinished: (str) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: kLoadingSpinner,
              ),
            )
        ],
      ),
    );
  }
}
