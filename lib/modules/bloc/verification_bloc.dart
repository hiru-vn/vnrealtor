import 'package:datcao/modules/repo/verification_repo.dart';
import 'package:datcao/share/import.dart';

class VerificationBloc extends ChangeNotifier {
  VerificationBloc._privateConstructor();
  static final VerificationBloc instance =
      VerificationBloc._privateConstructor();

  String name;
  String dateOfBirth;
  String idCard;
  String imageFront;
  String imageBehind;
  String currentAddress;
  String phone;
  String website;
  String socialNetwork;
  String taxCode;
  String phoneCom;
  String email;

  Future<BaseResponse> createVerification() async {
    try {
      final res = await VerificationRepo().createVerification(
          name,
          dateOfBirth,
          idCard,
          imageFront,
          imageBehind,
          currentAddress,
          phone,
          website,
          socialNetwork);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<BaseResponse> createCompanyVerification() async {
    try {
      final res = await VerificationRepo().createCompanyVerification(
          name, taxCode, currentAddress, email, phoneCom, website);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    } finally {
      notifyListeners();
    }
  }
}
