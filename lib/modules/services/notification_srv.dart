import 'base_graphql.dart';

class NotificationSrv extends BaseService {
  NotificationSrv() : super(module: 'Notification', fragment: ''' 
id: String
tag: String
title: String
body: String
html: String
seen: Boolean
seenAt: DateTime
data: Mixed
image: String
toUserId: ID
fromUserId: String
modelId: String
fromUser {
id: String
name: String
phone: String
uid: String
email: String
role: String
reputationScore: Int
friendIds: [ID]
createdAt: DateTime
updatedAt: DateTime
}
toUser {
id: String
name: String
phone: String
uid: String
email: String
role: String
reputationScore: Int
friendIds: [ID]
createdAt: DateTime
updatedAt: DateTime
}
createdAt: DateTime
updatedAt: DateTime
  ''');
}
