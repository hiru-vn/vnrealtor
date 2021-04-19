import 'package:datcao/modules/services/base_graphql.dart';

class SuggestFollowSrv extends BaseService {
  SuggestFollowSrv() : super(module: 'SuggestFollow', fragment: ''' 
   id
    name
    avartar
    coverImage
    description
    address
    phone
    email
    website
    followerIds
    followers{
      id
      name
    }
    owner{
      id
      name
    }
  ''');
}
