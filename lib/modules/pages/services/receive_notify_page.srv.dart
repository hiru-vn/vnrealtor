import 'package:datcao/modules/services/base_graphql.dart';

class ReceiveNotifyPageSrv extends BaseService {
  ReceiveNotifyPageSrv() : super(module: 'reciveNotiPage', fragment: ''' 
    id
    description
    avartar
    coverImage
  ''');
}
