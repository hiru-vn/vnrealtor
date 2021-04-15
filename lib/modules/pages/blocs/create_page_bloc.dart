import 'package:datcao/modules/pages/models/pages_category_model.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/repos/create_page_repo.dart';
import 'package:datcao/share/import.dart';

class CreatePageBloc extends ChangeNotifier {
  CreatePageBloc._privateConstructor();
  static final CreatePageBloc instance = CreatePageBloc._privateConstructor();

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
    final res = await CreatePageRepo().getCategories(filter: filter);
    final List listRaw = res['data'];
    List<PagesCategoriesModel> listModel =
        listRaw.map((e) => PagesCategoriesModel.fromJson(e)).toList();
    listModel.forEach((element) => _listTmp.add(element.name));
    return _listTmp;
  }

  Future<void> getAllCategories() async {
    _isLoading = true;
    List<String> _listTmp = [];
    final res = await CreatePageRepo().getCategories(
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
      final res = await CreatePageRepo().createPage(
          name, description, avatar, coverImage, categoryIds, address, website, phone);
      return BaseResponse.success(PagesCreate.fromJson(res));
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      // wait to reload post
      Future.delayed(Duration(seconds: 1), () => notifyListeners());
    }
  }
}
