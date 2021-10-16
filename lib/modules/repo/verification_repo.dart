import 'package:datcao/modules/services/verificatetion_srv.dart';

class VerificationRepo {
  Future createVerification(
      String? name,
      String? dateOfBirth,
      String? idCard,
      String? imageFront,
      String? imageBehind,
      String? currentAddress,
      String? phone,
      String? website,
      String? socialNetwork) async {
    String data = '''
      name: "${name ?? ''}"
    	dateOfBirth: "${dateOfBirth ?? ''}"
      idCard: "${idCard ?? ''}"
      imageFront: "${imageFront ?? ''}"
      imageBehind: "${imageBehind ?? ''}"
      currentAddress: "${currentAddress ?? ''}"
      phone: "${phone ?? ''}"
      website: "${website ?? ''}"
      socialNetwork: "${socialNetwork ?? ''}"
    ''';
    final res = await VerificateSrv().add(data);
    return res;
  }

  Future createCompanyVerification(
    String? name,
    String? taxCode,
    String? address,
    String? email,
    String? comPhone,
    String? website,
  ) async {
    String data = '''
    data : {
      name: "$name"
      taxCode: "${taxCode ?? ''}"
    	address: "${address ?? ''}"
      email: "${email ?? ''}"
      comPhone: "${comPhone ?? ''}"
      website: "${website ?? ''}"
      }
    ''';
    final res = await VerificateSrv()
        .mutate('createCompanyVerification', data, fragment: ' id ');
    return res;
  }
}
