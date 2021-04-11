import 'package:datcao/modules/pages/services/pages_srv.dart';
import 'package:datcao/share/import.dart';

class PagesRepo {
  Future getPageCreate({GraphqlFilter filter}) async {
    if (filter?.filter == null) filter?.filter = "{}";
    if (filter?.search == null) filter?.search = "";
    final data = 'q:{ ${filter?.filter} }';
    final res = await PagesSrv().query('getAllPage', data, fragment: '''
    data {
$pagesFragment
}
    ''');
    return res['getAllPage'];
  }
}

String pagesFragment = '''
   id
      name
      description
            avartar
            coverImage
            followerIds
            categoryIds
            ownerId
            followers{ 
        id
        name
      }
            owner{
        id
        name
        avatar
      }
            category{
        id
        name
      }
            createdAt
            updatedAt
  ''';
