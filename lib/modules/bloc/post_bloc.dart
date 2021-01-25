import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/modules/repo/post_repo.dart';
import 'package:vnrealtor/share/import.dart';

class PostBloc extends ChangeNotifier {
  PostBloc._privateConstructor();
  static final PostBloc instance = PostBloc._privateConstructor();

  Future<BaseResponse> getListPost({GraphqlFilter filter}) async {
    try {
      final res = await PostRepo().getListPost(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    } finally {
      // notifyListeners();
    }
  }
}
