import 'dart:async';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/setting/policy_page.dart';
import 'package:datcao/share/import.dart';

class RegisterPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(RegisterPage()));
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameC = TextEditingController(text: 'huy nguyen');
  TextEditingController _emailC = TextEditingController(text: 'huy@gmail.com');
  TextEditingController _phoneC = TextEditingController(text: '0987654321');
  TextEditingController _passC = TextEditingController(text: '123123');
  TextEditingController _repassC = TextEditingController(text: '123123');
  TextEditingController _otpC = TextEditingController(text: '');
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
    _authBloc.requestOtpRegister(_nameC.text, _emailC.text, _passC.text, _phoneC.text);
    // HomePage.navigate();
  }

  _codeSubmit() {
    _authBloc.submitOtpRegister(
        _nameC.text, _emailC.text, _passC.text, _phoneC.text, _otpC.text);
    _otpC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Đăng kí',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SpacingBox(h: 1.5),
            Center(
                child: SizedBox(
                    width: deviceWidth(context) / 2,
                    child: Image.asset('assets/image/logo_full.png'))),
            SpacingBox(h: 3),
            _buildFormField(context, 'Tên người dùng', _nameC,
                validator: TextFieldValidator.notEmptyValidator),
            SpacingBox(h: 2),
            _buildFormField(
              context,
              'Email',
              _emailC,
              validator: TextFieldValidator.emailValidator,
            ),
            SpacingBox(h: 2),
            _buildFormField(context, 'Số điện thoại', _phoneC,
                validator: TextFieldValidator.phoneValidator),
           
            SpacingBox(h: 2),
            _buildFormField(
              context,
              'Mật khẩu',
              _passC,
              validator: TextFieldValidator.passValidator,
              obscureText: true,
            ),
            SpacingBox(h: 2),
            _buildFormField(
              context,
              'Nhập lại mật khẩu',
              _repassC,
              validator: (str) {
                if (str != _passC.text) return 'Mật khẩu không trùng khớp';
              },
              obscureText: true,
            ),
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
                    style: ptTitle(),
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

  _buildOtpDialog() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: Responsive.heightMultiplier * 10),
        child: Material(
          child: Container(
            width: deviceWidth(context) / 1.4,
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
                        onChanged: (str) {
                          if (str.length == 6) {
                            _codeSubmit();
                          }
                        },
                        style: ptBigTitle().copyWith(letterSpacing: 10),
                        controller: _otpC,
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
                          child: kLoadingSpinner,
                        );
                      return SizedBox.shrink();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildFormField(
    BuildContext context,
    String text,
    TextEditingController controller, {
    Function(String) validator,
    bool obscureText = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: ptBackgroundColor(context)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
            child: TextFormField(
              obscureText: obscureText,
              controller: controller,
              validator: validator ??
                  (str) {
                    return null;
                  },
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: text),
            ),
          ),
        ),
      );
}
