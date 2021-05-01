import 'package:datcao/modules/services/base_graphql.dart';

class PagesSrv extends BaseService {
  PagesSrv() : super(module: 'Page', fragment: ''' 
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
  isOwner
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
