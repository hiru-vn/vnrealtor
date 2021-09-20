import 'dart:async';

import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/registers/forgot_password_page.dart';
import 'package:datcao/modules/registers/register_page.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/gestures.dart';

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
    showWaitingDialog(context);
    try {
      final res = await _authBloc.signIn(_nameC.text, _passC.text);
      closeLoading();
      if (res.isSuccess) {
        HomePage.navigate();
        // showModalBottomSheet(
        //   backgroundColor: Colors.transparent,
        //   context: context,
        //   builder: (context) => Container(
        //     decoration: BoxDecoration(
        //       color: ptPrimaryColor(context),
        //       borderRadius: BorderRadius.vertical(
        //         top: Radius.circular(15),
        //       ),
        //     ),
        //     child: Column(
        //       children: [
        //         Container(
        //             height: 80,
        //             decoration: BoxDecoration(
        //               color: ptMainColor(context),
        //               borderRadius: BorderRadius.vertical(
        //                 top: Radius.circular(15),
        //               ),
        //             ),
        //             child: Center(
        //               child: Text("ĐĂNG NHẬP THÀNH CÔNG!",
        //                   style: roboto_18_700()
        //                       .copyWith(fontSize: 20, color: Colors.white)),
        //             )),
        //         Expanded(
        //             child: Padding(
        //           padding: const EdgeInsets.all(20),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 "ĐĂNG KÝ ĐỂ TẠO TRANG VÀ NHÓM CHO CÔNG TY",
        //                 textAlign: TextAlign.center,
        //                 style: roboto_18_700().copyWith(
        //                   fontSize: 20,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     vertical: 10, horizontal: 40),
        //                 child: RichText(
        //                   textAlign: TextAlign.center,
        //                   text: TextSpan(
        //                     children: <TextSpan>[
        //                       TextSpan(
        //                         text: 'Bật thông báo ',
        //                         style: roboto(context).copyWith(
        //                             fontWeight: FontWeight.w400, fontSize: 15),
        //                       ),
        //                       TextSpan(
        //                         text: 'tại đây',
        //                         recognizer: TapGestureRecognizer()
        //                           ..onTap = () => HomePage.navigate(),
        //                         style: roboto(context).copyWith(
        //                             fontWeight: FontWeight.w400,
        //                             fontSize: 15,
        //                             color: Colors.blue),
        //                       ),
        //                       TextSpan(
        //                         text: ' để nhận được thông tin mới nhất ',
        //                         style: roboto(context).copyWith(
        //                             fontWeight: FontWeight.w400, fontSize: 15),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               ExpandBtn(
        //                   text: "TRANG CHỦ",
        //                   width: 100,
        //                   onPress: () => HomePage.navigate())
        //             ],
        //           ),
        //         ))
        //       ],
        //     ),
        //   ),
        // );
      } else {
        showToast(res.errMessage, context);
      }
    } catch (e) {
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "ĐĂNG NHẬP",
          style: roboto_18_700().copyWith(color: ptMainColor(context)),
        )),
        backgroundColor: ptPrimaryColor(context),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: ptPrimaryColor(context),
      body: Container(
        height: deviceHeight(context),
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom != 0
                  ? -MediaQuery.of(context).viewInsets.bottom
                  : 0,
              right: 0,
              child: Container(width: deviceWidth(context), child: splash2),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SpacingBox(h: 12),
                      Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ptPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 1),
                                ),
                                child: TextFormField(
                                  validator:
                                      TextFieldValidator.notEmptyValidator,
                                  controller: _nameC,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                      border: InputBorder.none,
                                      hintText: 'Số điện thoại'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 23),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ptPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 1),
                                ),
                                child: TextFormField(
                                    obscureText: obscurePassword,
                                    controller: _passC,
                                    validator: TextFieldValidator.passValidator,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Mật khẩu',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          audioCache.play('tab3.mp3');
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
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                width: deviceWidth(context) * 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      RegisterPage.navigate();
                                      audioCache.play('tab3.mp3');
                                    },
                                    child: Text(
                                      'Chưa có tài khoản? Tạo tài khoản mới',
                                      style: ptBody().copyWith(
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 23),
                                child: ExpandBtn(
                                  width: 150,
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
                                  audioCache.play('tab3.mp3');
                                  // showDialog(
                                  //     context: context,
                                  //     barrierDismissible: false,
                                  //     builder: (context) =>
                                  //         ResetPasswordDialog());
                                  ForgotPasswordPage.navigate();
                                },
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: ptTitle(),
                                ),
                              ),
                            ),
                            SpacingBox(h: 1),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ],
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
//       appBar: SecondAppBar(
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
