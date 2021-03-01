import 'package:datcao/share/import.dart';

class PostHistoryPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(PostHistoryPage()));
  }

  @override
  _PostHistoryPageState createState() => _PostHistoryPageState();
}

class _PostHistoryPageState extends State<PostHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2(
        'Lịch sử đăng bài',
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(15).copyWith(bottom: 0),
            child: Text(
              'Bài viết',
              style: ptBigTitle(),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              // PostWidget(),
              // PostWidget(),
              // PostWidget(),
            ],
          )
        ]),
      ),
    );
  }
}
