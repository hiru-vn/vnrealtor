import 'base_graphql.dart';

class ChatBotSrv extends BaseService {
  ChatBotSrv() : super(module: 'ChatBot', fragment: ''' 
id: String
name: String
createdAt: DateTime
updatedAt: DateTime
  ''');
}
