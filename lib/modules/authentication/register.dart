import 'dart:async';

import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/share/import.dart';

class RegisterPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(RegisterPage()));
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameC = TextEditingController();
  TextEditingController _emailC = TextEditingController();
  TextEditingController _phoneC = TextEditingController();
  TextEditingController _passC = TextEditingController();
  TextEditingController _repassC = TextEditingController();
  AuthBloc _authBloc;
  StreamSubscription listener;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      listener = _authBloc.authStatusStream.listen((event) {
        if (event == AuthStatus.authFail) {
          showToast('Đăng kí thất bại, vui lòng thử lại', context);
        }
        if (event == AuthStatus.authSucces) {
          showToast('Đăng kí thất bại, vui lòng thử lại', context);
        }
        if (event == AuthStatus.otpSent) {
          showToast('Mã otp đã được gửi', context);
        }
        if (event == AuthStatus.authSucces) {
          HomePage.navigate();
        }
      });
    }
    super.didChangeDependencies();
  }

  dispose() {
    super.dispose();
    listener.cancel();
  }

  _submit() {
    _authBloc.requestOtp(_nameC.text, _emailC.text, _passC.text, _phoneC.text);
    // HomePage.navigate();
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
        child: Column(children: [
          SpacingBox(h: 1.5),
          Center(
              child: SizedBox(
                  width: deviceWidth(context) / 2,
                  child: Image.asset('assets/image/logo_full.png'))),
          SpacingBox(h: 3),
          _buildFormField(context, 'Tên người dùng', _nameC),
          SpacingBox(h: 2),
          _buildFormField(context, 'Email', _emailC),
          SpacingBox(h: 2),
          _buildFormField(context, 'Số điện thoại', _phoneC),
          SpacingBox(h: 2),
          _buildFormField(context, 'Mật khẩu', _passC),
          SpacingBox(h: 2),
          _buildFormField(context, 'Nhập lại mật khẩu', _repassC),
          SpacingBox(h: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {},
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
                    TextSpan(text: 'của VNRealtor'),
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
    );
  }

  _buildFormField(BuildContext context, String text,
          TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: ptBackgroundColor(context)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
            child: TextField(
              controller: controller,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: text),
            ),
          ),
        ),
      );
}
