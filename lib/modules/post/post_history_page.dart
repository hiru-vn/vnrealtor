import 'package:vnrealtor/modules/post/post_widget.dart';
import 'package:vnrealtor/share/import.dart';

class PostHistoryPage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(PostHistoryPage()));
  }

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
