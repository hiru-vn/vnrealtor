import 'package:datcao/modules/pages/services/create_page_srv.dart';
import 'package:datcao/share/import.dart';

class CreatePageRepo {
  Future getCategories(
      {GraphqlFilter filter, String timestamp, String timeSort}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{search: "${filter?.search}"}';
    final res = await CategoriesPageSrv()
        .query('getAllCategoryPage', data, fragment: '''
    data {
$categoriesPageFragment
}
    ''');
    return res['getAllCategoryPage'];
  }

  String categoriesPageFragment = '''
id
name
  ''';
}
