import 'base_graphql.dart';

class VerificateSrv extends BaseService {
  VerificateSrv() : super(module: 'BrokerVerification', fragment: ''' 
id: String
name: String
dateOfBirth: DateTime
idCard: String
dateOfIssue: DateTime
placeOfIssue: String
imageFront: String
imageBehind: String
currentAddress: String
phone: String
website: String
socialNetwork: String
userId: ID
createdAt: DateTime
updatedAt: DateTime
  ''');
}
