import 'package:datcao/modules/services/base_graphql.dart';

class UpdatePageSrv extends BaseService {
  UpdatePageSrv() : super(module: 'Page', fragment: ''' 
    avartar
    coverImage
  ''');
}
