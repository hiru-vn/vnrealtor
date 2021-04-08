import 'package:datcao/modules/services/base_graphql.dart';

class CategoriesPageSrv extends BaseService {
  CategoriesPageSrv() : super(module: 'CategoriesPage', fragment: ''' 
id
name
  ''');
}
