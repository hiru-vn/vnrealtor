import 'package:datcao/modules/services/base_graphql.dart';

class PagesCreatePostSrv extends BaseService {
  PagesCreatePostSrv() : super(module: 'PostCreate', fragment: ''' 
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

    page{
      id
      name
      avartar
      phone
      address
     }
  ''');
}
