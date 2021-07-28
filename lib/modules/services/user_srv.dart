import 'base_graphql.dart';

class UserSrv extends BaseService {
  UserSrv() : super(module: 'User', fragment: ''' 
id: String
name: String
tagName: String
phone: String
uid: String
groupIds
email: String
role: String
reputationScore: Int
avatar
dynamicLink {
  shortLink
  previewLink
}
isMod
postNoti
friendIds: [ID]
createdAt: DateTime
updatedAt: DateTime
followerIds: [ID]
messNotiCount
followingIds: [ID]
savedPostIds: [ID]
totalPost
notiCount
description
facebookUrl
isVerify
isPendingVerify 
settings {
likeNoti
shareNoti
commentNoti
}
  ''');
}
