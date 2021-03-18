import 'base_graphql.dart';

class ReplySrv extends BaseService {
  ReplySrv() : super(module: 'Reply', fragment: ''' 
id: String
userId: ID
commentId: ID
content: String
user {
  id 
  uid 
  name 
  email 
  phone 
  role 
  reputationScore 
  createdAt 
  updatedAt 
  avatar
  totalPost
  friendIds
  facebookUrl
  description
  isVerify
  followerIds 
  followingIds
}
createdAt: DateTime
updatedAt: DateTime

  ''');
}
