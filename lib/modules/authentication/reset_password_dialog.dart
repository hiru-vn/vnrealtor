import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/share/import.dart';

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  AuthBloc _authBloc;
  PageController _pageC = PageController();
  TextEditingController _phoneC = TextEditingController(text: '');
  TextEditingController _otpC = TextEditingController(text: '');
  TextEditingController _passC = TextEditingController(text: '');

  bool isLoading = false;

  StreamSubscription listener;
  AuthCredential auth;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      listener = _authBloc.authStatusStream.listen((event) async {
        if (event.status == AuthStatus.authFail) {
          setState(() {
            isLoading = false;
          });
          showToast(event.errMessage, context);
        }
        if (event.status == AuthStatus.successOtp) {
          _pageC.animateToPage(2,
              duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        }
        if (event.status == AuthStatus.authSucces) {
          setState(() {
            isLoading = false;
          });
          showToast('Đổi mật khẩu thành công', context, isSuccess: true);
          navigatorKey.currentState.maybePop();
        }
        if (event.status == AuthStatus.otpSent) {
          setState(() {
            isLoading = false;
          });
          _pageC.animateToPage(1,
              duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        }
        if (event.status == AuthStatus.requestOtp) {
          setState(() {
            isLoading = true;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  _submitPhone() {
    if (!Validator.isPhone(_phoneC.text)) {
      showToast('Số điện thoại không đúng', context);
      return;
    }
    _authBloc.requestOtpResetPassword(_phoneC.text);
  }

  _submitOtp() {
    auth = _authBloc.submitOtpResetPass(_otpC.text);
  }

  _submitPass() {
    if (!Validator.isPassword(_passC.text)) {
      showToast('Mật khẩu không hợp lệ', context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    _authBloc.resetPass(auth, _passC.text);
  }

  @override
  void dispose() {
    listener.cancel();
    _authBloc.authStatusSink.add(AuthResponse.unAuthed());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: Responsive.heightMultiplier * 10),
        child: Material(
          child: Container(
            width: deviceWidth(context) / 1.4,
            height: 195.0,
            padding: EdgeInsets.only(top: 25, bottom: 20),
            child: PageView(
              controller: _pageC,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Vui lòng nhập số điện thoại đăng kí tài khoản',
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
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (str) {},
                            style: ptTitle(),
                            controller: _phoneC,
                            autocorrect: false,
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: ''),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: _submitPhone,
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            )
                          : Text(
                              'Tiếp tục',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
                Column(
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
                                _submitOtp();
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
                    RaisedButton(
                      onPressed: _submitPhone,
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            )
                          : Text(
                              'Tiếp tục',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Nhập mật khẩu mới',
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
                            keyboardType: TextInputType.number,
                            style: ptTitle(),
                            controller: _passC,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: ''),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: _submitPass,
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            )
                          : Text(
                              'Hoàn tất',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
