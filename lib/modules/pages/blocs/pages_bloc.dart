import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/repos/pages_repo.dart';
import 'package:datcao/share/import.dart';

class PagesBloc extends ChangeNotifier {
  PagesBloc._privateConstructor();
  static final PagesBloc instance = PagesBloc._privateConstructor();

  List<PagesCreate> _pageCreated = [];

  bool _isOwnPageLoading = false;

  bool get isOwnPageLoading => _isOwnPageLoading;

  List<PagesCreate> get pageCreated => _pageCreated;

  Future<BaseResponse> getPageCreate({GraphqlFilter filter}) async {
    try {
      _isOwnPageLoading = true;
      final res = await PagesRepo()
          .getPageCreate(filter: filter);
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

}