import 'base_graphql.dart';

class CommentSrv extends BaseService {
  CommentSrv() : super(module: 'Comment', fragment: '''
id: String
userTags
userId: ID
postId: ID
mediaPostId: ID
like: Int
userLikeIds: [ID]
content: String
replyIds: [ID]
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
