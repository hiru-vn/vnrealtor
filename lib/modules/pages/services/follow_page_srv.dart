import 'package:datcao/modules/services/base_graphql.dart';

class FollowPageSrv extends BaseService {
  FollowPageSrv() : super(module: 'FollowPage', fragment: ''' 
    id
    followerIds

    followers{
      id
      name
    }
  ''');
}
