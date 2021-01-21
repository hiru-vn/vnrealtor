import 'package:vnrealtor/share/import.dart';

class PointPage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(PointPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Điểm uy tín của bạn : 23'),
          Text(
              'Điểm uy tín dùng để tăng số lượng bài đăng mà bạn có thể đăng trong ngày, điểm uy tín được tích lũy bằng việc đăng bài, lượt like, comment tương tác của người khác...')
        ],
      ),
    );
  }
}
