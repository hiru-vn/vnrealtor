import 'base_graphql.dart';

class ReportSrv extends BaseService {
  ReportSrv() : super(module: 'Report', fragment: ''' 
id: String
postId: String
content: [String]
userIds: [String]
count: Int
type: String
post: Post
users: [User]
createdAt: DateTime
updatedAt: DateTime
  ''');
}
