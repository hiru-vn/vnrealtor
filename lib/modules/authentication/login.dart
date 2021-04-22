import 'dart:async';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/register.dart';
import 'package:datcao/modules/authentication/reset_password_dialog.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/share/import.dart';

class LoginPage extends StatefulWidget {
  static Future navigate() async {
    navigatorKey.currentState.popUntil((route) => route.isFirst);
    return navigatorKey.currentState.pushReplacement(pageBuilder(LoginPage()));
  }

  static Future navigatePush() {
    return navigatorKey.currentState.push(pageBuilder(LoginPage()));
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc _authBloc;
  TextEditingController _nameC = TextEditingController(text: '');
  TextEditingController _passC = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: ptSecondaryColor(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom != 0
                  ? kToolbarHeight + 20
                  : 0,
              child: MediaQuery.of(context).viewInsets.bottom != 0
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Đăng nhập',
                        style: ptBigTitle()
                            .copyWith(color: ptPrimaryColor(context)),
                      ),
                    )
                  : null,
            ),
            Stack(
              children: [
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/image/bg_login.png',
                      fit: BoxFit.fitWidth,
                    )),
                Container(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? deviceHeight(context) / 3
                      : 0,
                  //color: ptPrimaryColor(context),
                  child: Stack(
                    children: [
                      Center(
                          child: SizedBox(
                              width: deviceWidth(context) / 5,
                              child:
                                  Image.asset('assets/image/icon_white.png'))),
                      Positioned(
                        bottom: deviceHeight(context) / 6 -
                            deviceWidth(context) / 5,
                        width: deviceWidth(context),
                        child: Center(
                          child: Text(
                            'Chào mừng bạn đến với DATCAO',
                            style: ptTitle().copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SpacingBox(h: 2.5),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.all(18),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Material(
                        elevation: 0,
                        color: ptSecondaryColor(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 25),
                          child: TextFormField(
                            validator: TextFieldValidator.notEmptyValidator,
                            controller: _nameC,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Số điện thoại'),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Material(
                      elevation: 0,
                      color: ptSecondaryColor(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 25)
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
                                  obscurePassword
                                      ? MdiIcons.eye
                                      : MdiIcons.eyeOff,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: ExpandBtn(
                        text: 'Đăng nhập',
                        onPress: _submit,
                      ),
                    ),
                  ),
                  SpacingBox(h: 2),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // if (TextF _nameC.text)
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ResetPasswordDialog());
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: ptTitle().copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                  SpacingBox(h: 1),
                  Center(
                    child: SizedBox(
                      width: deviceWidth(context) - 100,
                      child: Divider(),
                    ),
                  ),
                  SpacingBox(h: 1),
                  Center(
                    child: FlatButton(
                      color: Colors.cyanAccent,
                      onPressed: () {
                        RegisterPage.navigate();
                      },
                      child: Text(
                        'Tạo tài khoản mới',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SpacingBox(h: 2.5),
            SizedBox(
              width: deviceWidth(context) * 0.9,
              child: Center(
                child: GestureDetector(
                  onTap: () => RegisterPage.navigate(isCompany: true),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Tạo '),
                        TextSpan(
                          text: 'tài khoản',
                          style: ptBody().copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' dành cho doanh nghiệp của bạn'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SpacingBox(h: 2.5),
          ]),
        ),
      ),
    );
  }
}

// class _LoginPageState extends State<LoginPage> {
//   AuthBloc _authBloc;
//   TextEditingController _nameC = TextEditingController(text: '');
//   TextEditingController _passC = TextEditingController(text: '');

//   final _formKey = GlobalKey<FormState>();

//   bool obscurePassword = true;

//   @override
//   void didChangeDependencies() {
//     if (_authBloc == null) {
//       _authBloc = Provider.of<AuthBloc>(context);
//     }
//     super.didChangeDependencies();
//   }

//   _submit() async {
//     if (!_formKey.currentState.validate()) return;
//     showSimpleLoadingDialog(context);
//     try {
//       final res = await _authBloc.signIn(_nameC.text, _passC.text);
//       if (res.isSuccess) {
//         navigatorKey.currentState
//             .maybePop()
//             .then((value) => HomePage.navigate());
//       } else {
//         showToast(res.errMessage, context);
//         navigatorKey.currentState.maybePop();
//       }
//     } catch (e) {} finally {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar1(
//         centerTitle: true,
//         title: 'Đăng nhập',
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             SpacingBox(h: 1.5),
//             Center(
//                 child: SizedBox(
//                     width: deviceWidth(context) / 3.2,
//                     child: Image.asset('assets/image/logo.png'))),
//             SpacingBox(h: 2),
//             Text(
//               'Chào mừng bạn đến với DATCAO',
//               style: ptTitle(),
//             ),
//             SpacingBox(h: 1.5),
//             DropdownButton(
//                 underline: SizedBox.shrink(),
//                 elevation: 0,
//                 icon: Icon(Icons.keyboard_arrow_down),
//                 value: 'vi',
//                 items: [
//                   DropdownMenuItem(
//                     child: Padding(
//                       padding: const EdgeInsets.all(5).copyWith(right: 0),
//                       child: Row(
//                         children: [
//                           Image.asset('assets/image/vn_flag.png'),
//                           SizedBox(width: 8),
//                           Text('VI'),
//                         ],
//                       ),
//                     ),
//                     value: 'vi',
//                   )
//                 ],
//                 onChanged: (val) {}),
//             SpacingBox(h: 2),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Material(
//                   elevation: 0,
//                   borderRadius: BorderRadius.circular(15),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
//                     child: TextFormField(
//                       validator: TextFieldValidator.notEmptyValidator,
//                       controller: _nameC,
//                       decoration: InputDecoration(
//                           border: InputBorder.none, hintText: 'Số điện thoại'),
//                     ),
//                   )),
//             ),
//             SpacingBox(h: 2.5),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Material(
//                 elevation: 0,
//                 borderRadius: BorderRadius.circular(15),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 25)
//                           .copyWith(right: 10),
//                   child: TextFormField(
//                       obscureText: obscurePassword,
//                       controller: _passC,
//                       validator: TextFieldValidator.passValidator,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'Mật khẩu',
//                         suffixIcon: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               obscurePassword = !obscurePassword;
//                             });
//                           },
//                           child: Icon(
//                             obscurePassword ? MdiIcons.eye : MdiIcons.eyeOff,
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//             ),
//             SpacingBox(h: 3),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 30),
//                 child: GestureDetector(
//                   onTap: () {
//                     // if (TextF _nameC.text)
//                     showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => ResetPasswordDialog());
//                   },
//                   child: Text(
//                     'Quên mật khẩu?',
//                     style: ptTitle().copyWith(color: Colors.black54),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: Responsive.heightMultiplier * 15,
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: ExpandBtn(
//                     text: 'Đăng nhập',
//                     onPress: _submit,
//                   ),
//                 ),
//               ),
//             ),
//             SpacingBox(h: 2.5),
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Text(
//                 'Chưa có tài khoản?',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               GestureDetector(
//                 onTap: () => RegisterPage.navigate(),
//                 child: Text(
//                   'Đăng kí ngay',
//                   style: TextStyle(
//                       color: Colors.orange,
//                       decoration: TextDecoration.underline),
//                 ),
//               ),
//             ]),
//           ]),
//         ),
//       ),
//     );
//   }
// }
