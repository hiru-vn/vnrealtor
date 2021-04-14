import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/repos/pages_repo.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class PagesBloc extends ChangeNotifier {
  PagesBloc._privateConstructor();
  static final PagesBloc instance = PagesBloc._privateConstructor();

  // PostBloc _postBloc;

  DateTime _lastFetchPostPage;

  int _postPage = 1;

  bool _isOwnPageLoading = false;

  bool _isCreatePostLoading = false;

  bool _isGetPostPageLoading = false;

  bool _isEndPostPage = false;

  List<PagesCreate> _pageCreated = [];

  List<PagesCreate> get pageCreated => _pageCreated;

  List<PostModel> _listPagePost = [];

  List<dynamic> hasTags = [];

  List<PostModel> get listPagePost => _listPagePost;

  bool get isOwnPageLoading => _isOwnPageLoading;

  bool get isCreatePostLoading => _isCreatePostLoading;

  bool get isGetPostPageLoading => _isGetPostPageLoading;

  bool get isEndPostPage => _isEndPostPage;

  ScrollController pagePostsScrollController;


  set isCreatePostLoading(bool isCreatePostLoading) {
    _isCreatePostLoading = isCreatePostLoading;
    notifyListeners();
  }

  Future<BaseResponse> getPageCreate({GraphqlFilter filter}) async {
    try {
      _isOwnPageLoading = true;
      final res = await PagesRepo().getPageCreate(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PagesCreate.fromJson(e)).toList();
      _pageCreated = list;
      return BaseResponse.success(list);
    } catch (e) {
      _isOwnPageLoading = false;
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      _isOwnPageLoading = false;
      notifyListeners();
    }
  }

  Future<BaseResponse> createPagePost(
      String pageId,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos) async {
    try {
      final res = await PagesRepo().createPagePost(pageId, content,
          expirationDate, publicity, lat, long, images, videos);
      _listPagePost.insert(0, PostModel.fromJson(res));
      return BaseResponse.success(PostModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }


  Future<BaseResponse> getAllHashTagTP() async {
    try {
      final res = await PostRepo().getAllHashTagTP();
      hasTags = res as List<dynamic>;
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      // notifyListeners();
    }
  }

  Future<BaseResponse> getPostsOfPage({GraphqlFilter filter}) async {
    try {
      _isGetPostPageLoading = true;
      final res = await PagesRepo().getPostOfPage(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PostModel.fromJson(e)).toList();
     // if (list.length < filter.limit) _isEndPostPage = true;
      _listPagePost = list;
      _lastFetchPostPage = DateTime.now();
      _postPage = 1;
      notifyListeners();
      return BaseResponse.success(list);
    } catch (e) {
      _isGetPostPageLoading = false;
      notifyListeners();
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      _isGetPostPageLoading = false;
      notifyListeners();
    }
  }
}
