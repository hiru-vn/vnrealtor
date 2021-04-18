import 'package:datcao/modules/services/base_graphql.dart';

class PagesSrv extends BaseService {
  PagesSrv() : super(module: 'getPageCreate', fragment: ''' 
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
