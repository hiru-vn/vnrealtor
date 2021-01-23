
import 'base_graphql.dart';

class UserSrv extends BaseService {
  UserSrv()  : super(module: 'User', fragment: ''' 
id: String
name: String
phone: String
uid: String
email: String
role: String
reputationScore: Int
friendShipId: [ID]
createdAt: DateTime
updatedAt: DateTime
  ''');
}