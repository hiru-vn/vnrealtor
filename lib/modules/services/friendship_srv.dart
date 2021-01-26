import 'base_graphql.dart';

class FriendshipSrv extends BaseService {
  FriendshipSrv()  : super(module: 'Friendship', fragment: ''' 
id: String
user1Id: ID
user2Id: ID
status: String
user1 {
id: String
name: String
phone: String
uid: String
email: String
password: String
role: String
reputationScore: Int
avatar: String
createdAt: DateTime
updatedAt: DateTime
}
user2 {
id: String
name: String
phone: String
uid: String
email: String
password: String
role: String
reputationScore: Int
avatar: String
createdAt: DateTime
updatedAt: DateTime
}
  ''');
}