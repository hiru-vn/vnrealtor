import 'base_graphql.dart';

class ValuationHcmStreetSrv extends BaseService {
  ValuationHcmStreetSrv() : super(module: 'ValuationHcmStreet', fragment: ''' 
    id
    wardId
    wardName
    streetName
    prevAvgPrice
		avgPrice
    priceChangedPercentage
    totalAssets
  ''');
}
