import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/repo/user_repo.dart';
import 'package:vnrealtor/share/import.dart';

class UserBloc extends ChangeNotifier {
  UserBloc._privateConstructor();
  static final UserBloc instance = UserBloc._privateConstructor();

  Future<BaseResponse> getListUser({GraphqlFilter filter}) async {
    try {
      final res = await UserRepo().getListUser(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => UserModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      // notifyListeners();
    }
  }
}
