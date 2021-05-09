import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/pages/models/followModel.dart';
import 'package:datcao/modules/pages/models/pages_category_model.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/models/suggestModel.dart';
import 'package:datcao/modules/pages/repos/pages_repo.dart';
import 'package:datcao/modules/repo/post_repo.dart';
import 'package:datcao/share/import.dart';

class PagesBloc extends ChangeNotifier {
  PagesBloc._privateConstructor();
  static final PagesBloc instance = PagesBloc._privateConstructor();

  DateTime _lastFetchPostPage;

  DateTime _lastFetchPageFollow;

  int _postPage = 1;

  int _pageFollow = 1;

  bool _isOwnPageLoading = false;

  bool _isPageFollowLoading = false;

  bool _isCreatePostLoading = false;

  bool _isGetPostPageLoading = false;

  bool _isEndPostPage = false;

  bool _isFollowPageLoading = false;

  bool _isFollowed = false;

  bool _isSuggestFollowPage = false;

  bool _isSuggestFollowLoading = false;

  List<PagesCreate> _pageCreated = [];

  List<String> _followingPageIds = [];

  List<PagesCreate> get pageCreated => _pageCreated;

  List<PostModel> _listPagePost = [];

  List<PagesCreate> _listPageFollow = [];

  List<dynamic> hasTags = [];

  List<PostModel> get listPagePost => _listPagePost;

  List<PagesCreate> get listPageFollow => _listPageFollow;

  List<PagesCreate> _suggestFollowPage = [];

  bool get isOwnPageLoading => _isOwnPageLoading;

  bool get isPageFollowLoading => _isPageFollowLoading;

  bool get isCreatePostLoading => _isCreatePostLoading;

  bool get isGetPostPageLoading => _isGetPostPageLoading;

  bool get isEndPostPage => _isEndPostPage;

  bool get isFollowPageLoading => _isFollowPageLoading;

  bool get isFollowed => _isFollowed;

  bool get isSuggestFollowPage => _isSuggestFollowPage;

  bool get isSuggestFollowLoading => _isSuggestFollowLoading;

  List<String> get followingPageIds => _followingPageIds;

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

  List<PagesCreate> get suggestFollowPage => _suggestFollowPage;

  String get urlCover => _urlCover;

  String get urlAvatar => _urlAvatar;

  PagesCreate _pageDetail;

  PagesCreate get pageDetail => _pageDetail;

  Future init() async {
    final token = await SPref.instance.get('token');
    final id = await SPref.instance.get('id');
    if (token != null && id != null) {
      suggestFollow();
    }
  }

  set isSuggestFollowLoading(bool isSuggestFollowLoading) {
    _isSuggestFollowLoading = isSuggestFollowLoading;
    notifyListeners();
  }

  set isSuggestFollowPage(bool isSuggestFollowPage) {
    _isSuggestFollowPage = isSuggestFollowPage;
    notifyListeners();
  }

  set pageDetail(PagesCreate pageDetail) {
    _pageDetail = pageDetail;
    notifyListeners();
  }

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

  void updatePageFollowed(String userId) {
    if (_pageDetail.followerIds.contains(userId)) {
      _isFollowed = true;
    } else {
      _isFollowed = false;
    }
    notifyListeners();
  }

  void addToListFollowPageIds(String pageId) {
    _followingPageIds.add(pageId);
    notifyListeners();
  }

  void addItemToListFollowPage(PagesCreate page) {
    _listPageFollow.add(page);
    notifyListeners();
  }

  void removeItemOutOfListFollowPage(PagesCreate page) {
    _listPageFollow.remove(page);
    notifyListeners();
  }

  Future<BaseResponse> getListPage({GraphqlFilter filter}) async {
    try {
      final res = await PagesRepo().getListPage(filter: filter);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PagesCreate.fromJson(e)).toList();
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getMyPage() async {
    try {
      _pageCreated = [];
      _isOwnPageLoading = true;
      final res = await PagesRepo().getPageCreate(
          filter: GraphqlFilter(
        filter: 'filter:{ ownerId: "${AuthBloc.instance.userModel.id}"}',
        order: "{updatedAt: -1}",
      ));
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

  Future<BaseResponse> getPagesFollow(
      {GraphqlFilter filter, String userId}) async {
    try {
      _listPageFollow = [];
      final res =
          await PagesRepo().getPostFollower(filter: filter, userId: userId);
      final List listRaw = res['data'];
      final list = listRaw.map((e) => PagesCreate.fromJson(e)).toList();
      // if (list.length < filter.limit) _isEndPostPage = true;
      _listPageFollow = list;
      _lastFetchPageFollow = DateTime.now();
      _pageFollow = 1;
      return BaseResponse.success(list);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {}
  }

  Future<BaseResponse> createPagePost(
      String pageId,
      String content,
      String expirationDate,
      bool publicity,
      double lat,
      double long,
      List<String> images,
      List<String> videos,
      List<LatLng> polygon) async {
    try {
      final res = await PagesRepo().createPagePost(pageId, content,
          expirationDate, publicity, lat, long, images, videos, polygon);
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

  Future<BaseResponse> getPostsOfPageByGuess({GraphqlFilter filter}) async {
    try {
      _isGetPostPageLoading = true;
      final res = await PagesRepo().getPostOfPageByGuest(filter: filter);
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

  Future<BaseResponse> followPage(String pageId) async {
    try {
      addToListFollowPageIds(pageId);
      isSuggestFollowLoading = true;
      final res = await PagesRepo().followPage(pageId);
      notifyListeners();
      return BaseResponse.success(FollowPagesModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      _isFollowed = true;
      isSuggestFollowLoading = false;
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }

  Future<BaseResponse> unFollowPage(String pageId) async {
    try {
      final res = await PagesRepo().unFollowPage(pageId);
      notifyListeners();
      return BaseResponse.success(FollowPagesModel.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      _isFollowed = false;
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
    List<String> _listTmpName = [];
    _listCategories = [];
    _listModelCategories = [];
    _listCategoriesSelected = [];
    _listCategoriesId = [];
    final res = await PagesRepo().getCategories(
        filter: GraphqlFilter(search: '', order: '{createdAt: -1}'));
    final List listRaw = res['data'];
    List<PagesCategoriesModel> listModel =
        listRaw.map((e) => PagesCategoriesModel.fromJson(e)).toList();
    listModel.forEach((element) => _listTmpName.add(element.name));
    _listCategories = _listTmpName;
    _listModelCategories = listModel;
    _listCategoriesSelected.addAll([listModel[0].name, listModel[1].name]);
    _listCategoriesId.addAll([listModel[0].id, listModel[1].id]);
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
      String phone) async {
    try {
      final res = await PagesRepo().createPage(name, description, avatar,
          coverImage, categoryIds, address, website, phone);
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

  Future<BaseResponse> getOnePage(String pageId) async {
    try {
      final res = await PagesRepo().getOnePage(pageId);
      if (res == null)
        return BaseResponse.fail('Trang không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(PagesCreate.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> getOnePageGuess(String pageId) async {
    try {
      final res = await PagesRepo().getOnePageGuess(pageId);
      if (res == null)
        return BaseResponse.fail('Trang không tồn tại hoặc đã bị xóa');
      return BaseResponse.success(PagesCreate.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> updatePage(
      String id, String avatar, String cover) async {
    try {
      final res = await PagesRepo().updatePage(id, avatar, cover);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
      PagesBloc.instance.notifyListeners();
    }
  }

  Future<BaseResponse> suggestFollow() async {
    try {
      final res = await PagesRepo().suggestFollowPage();
      final listRaw = res;
      List<PagesCreate> listModel =
          (listRaw.map((e) => PagesCreate.fromJson(e)).toList() as List)
              .cast<PagesCreate>();
      _suggestFollowPage = listModel;
      notifyListeners();
      return BaseResponse.success(_suggestFollowPage);
    } catch (e) {
      return BaseResponse.fail(e.message ?? e.toString());
    } finally {
      notifyListeners();
    }
  }
}
