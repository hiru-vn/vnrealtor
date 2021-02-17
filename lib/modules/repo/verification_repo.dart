import 'package:datcao/modules/services/verificatetion_srv.dart';

class VerificationRepo {
  Future createVerification(
      String name,
      String dateOfBirth,
      String idCard,
      String imageFront,
      String imageBehind,
      String currentAddress,
      String phone,
      String website,
      String socialNetwork) async {
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
}
