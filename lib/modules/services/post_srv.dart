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
storyImages
polygon {
  paths {
    lat
    lng
  }
}
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
halfUrl
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
   isPage
    page{
       	id
        name
        ownerId
        categoryIds
        avartar
        coverImage
        phone
        address
        website
        createdAt
        updatedAt
       followerIds
        followers{
          id
          name
        }
        category{
          id
          name
        }

        owner{
          id
          name
          email
        }
    }
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
halfUrl
updatedAt
  ''');
}
