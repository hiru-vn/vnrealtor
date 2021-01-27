
import 'base_graphql.dart';

class NotificationSrv extends BaseService {
  NotificationSrv()  : super(module: 'Notification', fragment: ''' 
id: String
type: String
title: String
body: String
html: String
seen: Boolean
seenAt: DateTime
data: Mixed
image: String
toUserId: ID
fromUserId: ID
createdAt: DateTime
updatedAt: DateTime
  ''');
}