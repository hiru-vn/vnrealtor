import 'dart:async';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/setting/policy_page.dart';
import 'package:datcao/share/import.dart';

class RegisterPage extends StatefulWidget {
  final bool isCompany;

  const RegisterPage({Key key, this.isCompany = false}) : super(key: key);
  static Future navigate({bool isCompany = false}) {
    return navigatorKey.currentState
        .push(pageBuilder(RegisterPage(isCompany: isCompany)));
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameC = TextEditingController(text: '');
  TextEditingController _emailC = TextEditingController(text: '');
  TextEditingController _phoneC = TextEditingController(text: '');
  TextEditingController _passC = TextEditingController(text: '');
  TextEditingController _repassC = TextEditingController(text: '');
  TextEditingController _otpC = TextEditingController(text: '');
  TextEditingController _ownerName = TextEditingController(text: '');

  AuthBloc _authBloc;
  StreamSubscription listener;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      listener = _authBloc.authStatusStream.listen((event) async {
        if (event.status == AuthStatus.authFail) {
          showToast(event.errMessage, context);
          navigatorKey.currentState.maybePop();
        }
        if (event.status == AuthStatus.authSucces) {
          HomePage.navigate();
        }
        if (event.status == AuthStatus.otpSent) {
          await navigatorKey.currentState.maybePop();
          showDialog(
              useRootNavigator: true,
              barrierDismissible: false,
              context: context,
              builder: (context) => _buildOtpDialog());
        }
        if (event.status == AuthStatus.requestOtp) {
          showSimpleLoadingDialog(context);
        }
      });
    }
    super.didChangeDependencies();
  }

  dispose() {
    super.dispose();
    listener.cancel();
    _authBloc.authStatusSink.add(AuthResponse.unAuthed());
  }

  _submit() {
    if (!_formKey.currentState.validate()) return;
    _authBloc.requestOtpRegister(
        _nameC.text, _emailC.text, _passC.text, _phoneC.text);
    // HomePage.navigate();
  }

  _codeSubmit() async {
    if (!widget.isCompany) {
      await _authBloc.submitOtpRegister(
          _nameC.text, _emailC.text, _passC.text, _phoneC.text, _otpC.text);
    } else {
      await _authBloc.submitOtpRegisterCompany(_nameC.text, _ownerName.text,
          _emailC.text, _passC.text, _phoneC.text, _otpC.text);
    }
    _otpC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Đăng kí${widget.isCompany ? ' doanh nghiệp' : ''}',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SpacingBox(h: 1.5),
            Center(
                child: widget.isCompany
                    ? SizedBox(
                        width: deviceWidth(context) / 4,
                        child: Image.asset('assets/image/company.png'))
                    : SizedBox(
                        width: deviceWidth(context) / 2,
                        child: Image.asset('assets/image/logo_full.png'))),
            SpacingBox(h: 3),
            if (!widget.isCompany)
              ..._buildUserForm()
            else
              ..._buildCompanyForm(),
            SpacingBox(h: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTap: () {
                  PolicyPage.navigate();
                },
                child: RichText(
                  maxLines: null,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: ptBody().copyWith(fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Bằng việc đăng kí tài khoản, bạn đồng ý với',
                      ),
                      TextSpan(
                        text: ' Điều kiện và điều khoản ',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(text: 'của Datcao'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Responsive.heightMultiplier * 15,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ExpandBtn(
                    text: 'Đăng kí',
                    onPress: _submit,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildCompanyForm() {
    return [
      _buildFormField(context, 'Tên công ty', _nameC,
          validator: TextFieldValidator.notEmptyValidator,
          icon: MdiIcons.officeBuilding),
      SpacingBox(h: 2),
      _buildFormField(context, 'Tên quản trị', _ownerName,
          validator: TextFieldValidator.notEmptyValidator, icon: Icons.person),
      SpacingBox(h: 2),
      _buildFormField(context, 'Email quản trị', _emailC,
          validator: TextFieldValidator.emailValidator, icon: Icons.mail),
      SpacingBox(h: 2),
      _buildFormField(context, 'Số điện thoại', _phoneC,
          validator: TextFieldValidator.phoneValidator, icon: Icons.phone),
      SpacingBox(h: 2),
      _buildFormField(context, 'Mật khẩu', _passC,
          validator: TextFieldValidator.passValidator,
          obscureText: true,
          icon: Icons.lock),
      SpacingBox(h: 2),
      _buildFormField(context, 'Nhập lại mật khẩu', _repassC, validator: (str) {
        if (str != _passC.text) return 'Mật khẩu không trùng khớp';
      }, obscureText: true, icon: Icons.lock),
    ];
  }

  List<Widget> _buildUserForm() {
    return [
      _buildFormField(context, 'Tên người dùng', _nameC,
          validator: TextFieldValidator.notEmptyValidator, icon: Icons.person),
      SpacingBox(h: 2),
      _buildFormField(context, 'Email', _emailC,
          validator: TextFieldValidator.emailValidator, icon: Icons.mail),
      SpacingBox(h: 2),
      _buildFormField(context, 'Số điện thoại', _phoneC,
          validator: TextFieldValidator.phoneValidator, icon: Icons.phone),
      SpacingBox(h: 2),
      _buildFormField(context, 'Mật khẩu', _passC,
          validator: TextFieldValidator.passValidator,
          obscureText: true,
          icon: Icons.lock),
      SpacingBox(h: 2),
      _buildFormField(context, 'Nhập lại mật khẩu', _repassC, validator: (str) {
        if (str != _passC.text) return 'Mật khẩu không trùng khớp';
      }, obscureText: true, icon: Icons.lock),
    ];
  }

  _buildOtpDialog() {
    return OtpDialog(codeSubmit: _codeSubmit, otpC: _otpC);
  }

  _buildFormField(
          BuildContext context, String text, TextEditingController controller,
          {Function(String) validator,
          bool obscureText = false,
          IconData icon}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(color: ptSecondaryColor(context)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 25)
                .copyWith(left: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 38,
                  child: Icon(
                    icon,
                    color: ptPrimaryColor(context),
                    size: 21,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextFormField(
                    obscureText: obscureText,
                    controller: controller,
                    validator: validator ??
                        (str) {
                          return null;
                        },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class OtpDialog extends StatefulWidget {
  final Function codeSubmit;
  final TextEditingController otpC;

  const OtpDialog({Key key, this.codeSubmit, this.otpC}) : super(key: key);

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  AuthBloc _authBloc;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: Responsive.heightMultiplier * 10),
        child: Stack(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Material(
                child: Container(
                  color: Colors.white,
                  width: deviceWidth(context) / 1.4,
                  height: 220,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Nhập OTP chúng tôi gửi qua tin nhắn cho bạn',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SpacingBox(h: 2),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: ptBackgroundColor(context)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              maxLength: 6,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (str) async {
                                if (str.length == 6) {
                                  widget.codeSubmit();
                                }
                              },
                              style: ptBigTitle().copyWith(letterSpacing: 10),
                              controller: widget.otpC,
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: ''),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: _authBloc.authStatusStream,
                          builder: (context, snap) {
                            if (snap.hasData &&
                                (snap.data as AuthResponse).status ==
                                    AuthStatus.successOtp)
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: kLoadingBubbleSpinner,
                              );
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Mã OTP gồm 6 chữ số\nmã sẽ hết hạn sau 60 giây',
                                textAlign: TextAlign.center,
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right:
                  (deviceWidth(context) - deviceWidth(context) / 1.4) / 2 - 25,
              top: (deviceHeight(context) - Responsive.heightMultiplier * 10) /
                      2 -
                  180,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    navigatorKey.currentState.maybePop();
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: ptPrimaryColor(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
