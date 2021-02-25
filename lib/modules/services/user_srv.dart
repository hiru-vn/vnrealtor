
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
avatar
friendIds: [ID]
createdAt: DateTime
updatedAt: DateTime
followerIds: [ID]
followingIds: [ID]
savedPostIds: [ID]
totalPost
notiCount
description
facebookUrl
  ''');
}