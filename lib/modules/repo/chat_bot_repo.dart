import 'package:datcao/modules/services/verificatetion_srv.dart';

class ChatBotRepo {
  Future sendMessCB(String? message) async {
    String data = '''
      message: "$message"
    ''';
    final res = await VerificateSrv()
        .mutate('sendMessCB', data, fragment: ' text image linkTo postId ');
    return res['sendMessCB'];
  }
}
