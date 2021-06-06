import 'base_graphql.dart';

class GroupSrv extends BaseService {
  GroupSrv() : super(module: 'Group', fragment: ''' 
id: String
name: String
privacy: Boolean
description: String
coverImage: String
address: String
censor
locationLat: Float
locationLong: Float
addressByLatLon: String
ownerId: ID
memberIds: [ID]
adminIds
location: Mixed
isMember: Boolean
isOwner: Boolean
isAdmin
owner {
  id: String
  name: String
  avatar
  isMod
}
memberIn24h
postIn24h
totalPost
countMember: Int
createdAt: DateTime
updatedAt: DateTime
  ''');
}
