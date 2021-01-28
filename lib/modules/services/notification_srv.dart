
import 'base_graphql.dart';

class NotificationSrv extends BaseService {
  NotificationSrv()  : super(module: 'Notification', fragment: ''' 
id
type
title
body
html
seen
seenAt
data
image
toUserId
fromUserId
createdAt
updatedAt
  ''');
}