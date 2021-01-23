
import 'package:vnrealtor/modules/services/user_srv.dart';

class UserRepo {
  Future registerWithPhone({String name, String email, String password, String phone, String idToken}) async {
    final res = await UserSrv().mutate(
        'registerWithPhone',
        '''
name: "$name"
email: "$email"
password: "$password"
phone: "$phone"
idToken: "$idToken"
    ''',
        fragment: 'token user { id uid name email phone avatar}');
    return res['register'];
  }

  Future login({String idToken}) async {
    final res = await UserSrv().mutate(
        'loginEmail',
        '''
idToken: "$idToken"
    ''',
        fragment: 'token user { id uid name email phone avatar}');
    return res['loginEmail'];
  }

  Future getOneUser({String id}) async {
    final res = await UserSrv().getItem(id);
    return res;
  }
}
