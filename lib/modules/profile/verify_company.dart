import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/verification_bloc.dart';
import 'package:datcao/modules/profile/verify_account_page2.dart';
import 'package:datcao/share/import.dart';

class VerifyCompany extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(VerifyCompany()));
  }

  @override
  _VerifyCompanyState createState() => _VerifyCompanyState();
}

class _VerifyCompanyState extends State<VerifyCompany> {
  VerificationBloc _verificationBloc;
  AuthBloc _authBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_verificationBloc == null) {
      _verificationBloc = Provider.of(context);
      _authBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  Future _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState.validate()) return;
    showSimpleLoadingDialog(context);
    final res = await _verificationBloc.createCompanyVerification();
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      showToast('Gửi yêu cầu xác minh thành công', context, isSuccess: true);
      await navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2('Xác minh doanh nghiệp'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            SizedBox(
              width: 90,
              child: Image.asset('assets/image/company.png'),
            ),
            // SpacingBox(h: 3),
            // Text(
            //   'Cung cấp thông tin cơ bản',
            //   style: ptBigTitle(),
            // ),
            // SpacingBox(h: 2),
            // SizedBox(
            //   width: deviceWidth(context) / 1.3,
            //   child: Text(
            //     'Chúng tôi cần ảnh để đối chiếu với thông tin cá nhân mà bạn cung cấp',
            //     style: ptBigBody().copyWith(color: Colors.black54),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            SpacingBox(h: 3),
            Container(
              width: deviceWidth(context),
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Tên công ty', _verificationBloc.name,
                        (val) => _verificationBloc.name = val,
                        validator: TextFieldValidator.notEmptyValidator,
                        icon: MdiIcons.officeBuilding),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Địa chỉ công ty',
                        _verificationBloc.currentAddress,
                        (val) => _verificationBloc.currentAddress = val,
                        validator: TextFieldValidator.notEmptyValidator,
                        icon: MdiIcons.mapMarker),
                    SizedBox(height: 15),
                    _buildTextField('Mã số thuế', _verificationBloc.taxCode,
                        (val) => _verificationBloc.taxCode = val,
                        validator: TextFieldValidator.notEmptyValidator,
                        icon: MdiIcons.fax),
                    SizedBox(height: 15),
                    _buildTextField('Email công ty', _verificationBloc.email,
                        (val) => _verificationBloc.email = val,
                        validator: TextFieldValidator.emailValidator,
                        icon: MdiIcons.email),
                    SizedBox(height: 15),
                    _buildTextField('SĐT công ty', _verificationBloc.phoneCom,
                        (val) => _verificationBloc.phoneCom = val,
                        validator: TextFieldValidator.notEmptyValidator,
                        icon: MdiIcons.phone),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Website công ty',
                        _verificationBloc.website,
                        (val) => _verificationBloc.website = val,
                        validator: TextFieldValidator.notEmptyValidator,
                        icon: MdiIcons.web),
                    SizedBox(height: 25),
                    RoundedBtn(
                      height: 45,
                      text: 'Hoàn tất',
                      onPressed: _submit,
                      width: 150,
                      color: ptPrimaryColor(context),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTextField(String hint, String initialValue, Function(String) onChange,
          {TextInputType type = TextInputType.text,
          Function(String) validator,
          IconData icon}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
            // elevation: 4,
            // borderRadius: BorderRadius.circular(10),
            color: ptSecondaryColor(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 25)
                  .copyWith(left: 15),
              child: Row(
                children: [
                  Icon(icon),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: validator,
                      keyboardType: type,
                      initialValue: initialValue,
                      onChanged: onChange,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
}
