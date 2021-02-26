import 'base_graphql.dart';

class PostSrv extends BaseService {
  PostSrv() : super(module: 'Post', fragment: ''' 
id
content
mediaPostIds
commentIds
userId
like
userLikeIds
share
userShareIds
locationLat
locationLong
expirationDate
publicity
isUserLike
isUserShare
hashTag
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
  friendIds
  avatar
  totalPost
  facebookUrl
  description
}
rawContent
mediaPosts {
id
userId
type
like
userLikeIds
commentIds

description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
}
province
district
ward
createdAt
updatedAt
  ''');
}

class MediaPostSrv extends BaseService {
  MediaPostSrv() : super(module: 'MediaPost', fragment: ''' 
id
userId
type
like
userLikeIds
commentIds
description
url
locationLat
locationLong
expirationDate
publicity
createdAt
updatedAt
}
createdAt
updatedAt
  ''');
}
