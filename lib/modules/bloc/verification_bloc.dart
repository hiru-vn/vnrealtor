import 'package:vnrealtor/modules/repo/verification_repo.dart';
import 'package:vnrealtor/share/import.dart';

class VerificationBloc extends ChangeNotifier {
  VerificationBloc._privateConstructor();
  static final VerificationBloc instance =
      VerificationBloc._privateConstructor();

  String name;
  String dateOfBirth;
  String idCard;
  String dateOfIssue;
  String placeOfIssue;
  String imageFront;
  String imageBehind;
  String currentAddress;
  String phone;
  String website;
  String socialNetwork;

  Future<BaseResponse> createVerification() async {
    try {
      final res = await VerificationRepo().createVerification(
          name,
          dateOfBirth,
          idCard,
          dateOfIssue,
          placeOfIssue,
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
}
