import 'package:datcao/modules/services/base_graphql.dart';

class CreatePageSrv extends BaseService {
  CreatePageSrv() : super(module: 'CreatePage', fragment: ''' 
 id
  name
  description
  avartar
  coverImage
  followerIds
  categoryIds
  ownerId
  phone
  address
  website
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
  ''');
}

class CategoriesPageSrv extends BaseService {
  CategoriesPageSrv() : super(module: 'CategoriesPage', fragment: ''' 
id
name
  ''');
}
