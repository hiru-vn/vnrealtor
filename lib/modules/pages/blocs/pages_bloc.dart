import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/models/followModel.dart';
import 'package:datcao/modules/pages/models/pages_category_model.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/repos/pages_repo.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class PagesBloc extends ChangeNotifier {
  PagesBloc._privateConstructor();
  static final PagesBloc instance = PagesBloc._privateConstructor();

  DateTime _lastFetchPostPage;

  int _postPage = 1;

  bool _isOwnPageLoading = false;

  bool _isCreatePostLoading = false;

  bool _isGetPostPageLoading = false;

  bool _isEndPostPage = false;

  bool _isFollowPageLoading = false;

  bool _isUnFollowPageLoading = false;

  List<PagesCreate> _pageCreated = [];

  List<PagesCreate> get pageCreated => _pageCreated;

  List<PostModel> _listPagePost = [];

  List<dynamic> hasTags = [];

  List<PostModel> get listPagePost => _listPagePost;

  bool get isOwnPageLoading => _isOwnPageLoading;

  bool get isCreatePostLoading => _isCreatePostLoading;

  bool get isGetPostPageLoading => _isGetPostPageLoading;

  bool get isEndPostPage => _isEndPostPage;

  bool get isFollowPageLoading => _isFollowPageLoading;

  bool get isUnFollowPageLoading => _isUnFollowPageLoading;

  ScrollController pagePostsScrollController;


  bool _isLoadingSubmitCreatePage = false;

  bool _isLoading = false;

  bool _isLoadingUploadCover = false;

  bool _isLoadingUploadAvatar = false;

  List<String> _listCategories = [];

  List<PagesCategoriesModel> _listModelCategories = [];

  List<String> _listCategoriesSelected = [];

  List<String> _listCategoriesId = [];

  String _phone;

  String _urlCover;

  String _urlAvatar;

  String _currentAddress;

  String _website;

  String get phone => _phone;

  String get currentAddress => _currentAddress;

  String get website => _website;

  bool get isLoading => _isLoading;

  bool get isLoadingSubmitCreatePage => _isLoadingSubmitCreatePage;

  bool get isLoadingUploadCover => _isLoadingUploadCover;

  bool get isLoadingUploadAvatar => _isLoadingUploadAvatar;

  List<String> get listCategoriesId => _listCategoriesId;

  List<String> get listCategoriesSelected => _listCategoriesSelected;

  String get urlCover => _urlCover;

  String get urlAvatar => _urlAvatar;

  set listCategoriesSelected(List<String> listCategoriesSelected) {
    _listCategoriesSelected = listCategoriesSelected;
    notifyListeners();
  }


  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  set website(String website) {
    _website = website;
    notifyListeners();
  }

  set currentAddress(String currentAddress) {
    _currentAddress = currentAddress;
    notifyListeners();
  }

  set listCategoriesId(List<String> listCategoriesId) {
    _listCategoriesId = _listCategoriesId;
    notifyListeners();
  }

  set isLoadingSubmitCreatePage(bool isLoadingSubmitCreatePage) {
    _isLoadingSubmitCreatePage = isLoadingSubmitCreatePage;
    notifyListeners();
  }

  set urlAvatar(String urlAvatar) {
    _urlAvatar = urlAvatar;
    notifyListeners();
  }

  set urlCover(String urlCover) {
    _urlCover = urlCover;
    notifyListeners();
  }

  set isLoadingUploadAvatar(bool isLoading) {
    _isLoadingUploadAvatar = isLoading;
    notifyListeners();
  }

  set isLoadingUploadCover(bool isLoading) {
    _isLoadingUploadCover = isLoading;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set isCreatePostLoading(bool isCreatePostLoading) {
    _isCreatePostLoading = isCreatePostLoading;
    notifyListeners();
  }

  set isFollowPageLoading(bool isFollowPageLoading) {
    _isFollowPageLoading = isFollowPageLoading;
    notifyListeners();
  }

  set isUnFollowPageLoading(bool isUnFollowPageLoading) {
    _isUnFollowPageLoading = isUnFollowPageLoading;
    notifyListeners();
  }


  Future<BaseResponse> getAllPage({GraphqlFilter filter}) async {
    try {
      _pageCreated = [];
      _isOwnPageLoading = true;
      final res = await PagesRepo().getPageCreate(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PagesCreate.fromJson(e)).toList();
      _pageCreated = list;
      notifyListeners();
      return BaseResponse.success(list);
    } catch (e) {
      _isOwnPageLoading = false;
      notifyListeners();
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

  Future<BaseResponse> followPage(
      String pageId
      ) async {
    try {
      final res = await PagesRepo().followPage(pageId);
      return BaseResponse.success(FollowPagesModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> unFollowPage(
      String pageId
      ) async {
    try {
      final res = await PagesRepo().unFollowPage(pageId);
      return BaseResponse.success(FollowPagesModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }


  removeCategory(int index) {
    _listCategoriesId.removeAt(index);
    notifyListeners();
  }

  void addSelectedCategories(String val) => _handleAddCategoriesGroup(
    val: val,
    listFull: _listCategories,
    listSelected: _listCategoriesSelected,
    listModel: _listModelCategories,
    listId: _listCategoriesId,
  );

  void _handleAddCategoriesGroup({
    String val,
    List<String> listFull,
    List<String> listSelected,
    List<PagesCategoriesModel> listModel,
    List<String> listId,
  }) {
    if (val.trim().isNotEmpty) {
      var res = listFull.indexWhere((element) => element == val);
      if (res != -1) {
        if (!listSelected.contains(val)) {
          listSelected.add(val);
          var index = listFull.indexWhere((element) => element == val);
          listId.add(listModel[index].id);
          notifyListeners();
        }
      } else
        getCategoriesByKeyword(
            filter: GraphqlFilter(search: '', order: '{createdAt: -1}'));
    }
  }

  Future<List<String>> getCategoriesByKeyword({GraphqlFilter filter}) async {
    List<String> _listTmp = [];
    final res = await PagesRepo().getCategories(filter: filter);
    final List listRaw = res['data'];
    List<PagesCategoriesModel> listModel =
    listRaw.map((e) => PagesCategoriesModel.fromJson(e)).toList();
    listModel.forEach((element) => _listTmp.add(element.name));
    return _listTmp;
  }

  Future<void> getAllCategories() async {
    _isLoading = true;
    List<String> _listTmp = [];
    final res = await PagesRepo().getCategories(
        filter: GraphqlFilter(search: '', order: '{createdAt: -1}'));
    final List listRaw = res['data'];
    List<PagesCategoriesModel> listModel =
    listRaw.map((e) => PagesCategoriesModel.fromJson(e)).toList();
    listModel.forEach((element) => _listTmp.add(element.name));
    _listCategories = _listTmp;
    _listModelCategories = listModel;
    _isLoading = false;
    notifyListeners();
  }

  Future<BaseResponse> createPage(
      String name,
      String description,
      String avatar,
      String coverImage,
      List<String> categoryIds,
      String address,
      String website,
      String phone
      ) async {
    try {
      final res = await PagesRepo().createPage(
          name, description, avatar, coverImage, categoryIds, address, website, phone);
      _pageCreated.add(PagesCreate.fromJson(res));
      notifyListeners();
      return BaseResponse.success(PagesCreate.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

}
