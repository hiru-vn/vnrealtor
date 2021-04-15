import 'package:datcao/modules/services/base_graphql.dart';

class CreatePageSrv extends BaseService {
  CreatePageSrv() : super(module: 'CreatePage', fragment: ''' 
id
name
ownerId
categoryIds
avartar
coverImage
category{
  id
  name
}

owner{
  id
  name
  email
}
  ''');
}

class CategoriesPageSrv extends BaseService {
  CategoriesPageSrv() : super(module: 'CategoriesPage', fragment: ''' 
id
name
  ''');
}
