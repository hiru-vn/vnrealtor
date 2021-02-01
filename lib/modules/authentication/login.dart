import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/authentication/register.dart';
import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/share/widget/appbar.dart';

class LoginPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.pushReplacement(pageBuilder(LoginPage()));
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc _authBloc;
  TextEditingController _nameC = TextEditingController(text: '0123123123');
  TextEditingController _passC = TextEditingController(text: '123123');
  TextEditingController _otpC = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
  }

  _otpSubmit() {
    final res = _authBloc.checkOtp(_otpC.text);
    if (res) {
      navigatorKey.currentState.maybePop();
      _otpC.clear();
    } else {}
  }

  _submit() async {
    if (!_formKey.currentState.validate()) return;
    showSimpleLoadingDialog(context);
    try {
      final res = await _authBloc.signIn(_nameC.text, _passC.text);
      if (res.isSuccess) {
        navigatorKey.currentState
            .maybePop()
            .then((value) => HomePage.navigate());
      } else {
        showToast(res.errMessage, context);
        navigatorKey.currentState.maybePop();
      }
    } catch (e) {} finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Đăng nhập',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SpacingBox(h: 1.5),
            Center(
                child: SizedBox(
                    width: deviceWidth(context) / 3,
                    child: Image.asset('assets/image/logo.png'))),
            SpacingBox(h: 1.5),
            Text(
              'Chào mừng bạn đến với VN Realtor App',
              style: ptTitle(),
            ),
            SpacingBox(h: 1.5),
            DropdownButton(
                underline: SizedBox.shrink(),
                elevation: 0,
                icon: Icon(Icons.keyboard_arrow_down),
                value: 'vi',
                items: [
                  DropdownMenuItem(
                    child: Padding(
                      padding: const EdgeInsets.all(5).copyWith(right: 0),
                      child: Row(
                        children: [
                          Image.asset('assets/image/vn_flag.png'),
                          SizedBox(width: 8),
                          Text('VI'),
                        ],
                      ),
                    ),
                    value: 'vi',
                  )
                ],
                onChanged: (val) {}),
            SpacingBox(h: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    child: TextFormField(
                      validator: TextFieldValidator.notEmptyValidator,
                      controller: _nameC,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Email hoặc SĐT'),
                    ),
                  )),
            ),
            SpacingBox(h: 2.5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25)
                          .copyWith(right: 10),
                  child: TextFormField(
                      obscureText: obscurePassword,
                      controller: _passC,
                      validator: TextFieldValidator.passValidator,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Mật khẩu',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: Icon(
                            obscurePassword ? MdiIcons.eye : MdiIcons.eyeOff,
                          ),
                        ),
                      )),
                ),
              ),
            ),
            SpacingBox(h: 3),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 30),
                child: GestureDetector(
                  onTap: () {
                    // if (TextF _nameC.text)
                    showDialog(
                        context: context,
                        builder: (context) => _buildOtpDialog());
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: ptTitle().copyWith(color: Colors.black54),
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
                    text: 'Đăng nhập',
                    onPress: _submit,
                  ),
                ),
              ),
            ),
            SpacingBox(h: 2.5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Chưa có tài khoản?',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () => RegisterPage.navigate(),
                child: Text(
                  'Đăng kí ngay',
                  style: TextStyle(
                      color: Colors.orange,
                      decoration: TextDecoration.underline),
                ),
              ),
            ]),
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
                            _otpSubmit();
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
}
