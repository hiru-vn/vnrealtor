import 'package:datcao/modules/pages/models/pages_category_model.dart';
import 'package:datcao/modules/pages/repos/create_page_repo.dart';
import 'package:datcao/share/import.dart';

class CreatePageBloc extends ChangeNotifier {
  CreatePageBloc._privateConstructor();
  static final CreatePageBloc instance = CreatePageBloc._privateConstructor();

  bool _isLoading = false;

  List<String> _listCategories = [];

  List<PagesCategoriesModel> _listModelCategories = [];

  List<String> _listCategoriesSelected = [];

  List<String> _listCategoriesId = [];

  bool get isLoading => _isLoading;

  List<String> get listCategoriesSelected => _listCategoriesSelected;

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
        getCategories(
            filter: GraphqlFilter(search: '', order: '{createdAt: -1}'));
    }
  }

  Future<List<PagesCategoriesModel>> getCategories(
      {GraphqlFilter filter}) async {
    try {
      List<String> _listTmp = [];
      final res = await CreatePageRepo().getCategories(filter: filter);
      final List listRaw = res['data'];
      List<PagesCategoriesModel> listModel =
          listRaw.map((e) => PagesCategoriesModel.fromJson(e)).toList();
      listModel.forEach((element) {
        _listTmp.add(element.name);
      });
      _listCategories = _listTmp;
      _listModelCategories = listModel;
      return listModel;
    } catch (e) {
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
