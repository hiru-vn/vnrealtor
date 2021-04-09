import 'package:datcao/modules/pages/services/create_page_srv.dart';
import 'package:datcao/modules/services/graphql_helper.dart';
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

  Future createPage(String name, String description, String avatar,
      String coverImage, List<String> categoryIds) async {
    String data = '''
name: $name
description: $description,
avatar: $avatar,
coverImage: $coverImage,
categoryIds: ${GraphqlHelper.listStringToGraphqlString(categoryIds)}
    ''';

    final res = await CreatePageSrv()
        .mutate('createPage', 'data: {$data}', fragment: '''
$pageFragment
    ''');
    return res["createPage"];
  }

  String pageFragment = '''
id
name
ownerId
categoryIds
category{
  id
  name
}

owner{
  id
  name
  email
}
  ''';

  String categoriesPageFragment = '''
id
name
  ''';
}
