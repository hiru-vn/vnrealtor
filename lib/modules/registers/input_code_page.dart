import 'dart:async';

import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/inbox/import/page_builder.dart';
import 'package:datcao/modules/registers/register_success_page.dart';
import 'package:datcao/navigator.dart';
import 'package:datcao/share/function/dialog.dart';
import 'package:datcao/share/widget/expand_btn.dart';
import 'package:datcao/themes/color.dart';
import 'package:datcao/themes/font.dart';
import 'package:datcao/utils/constants.dart';
import 'package:datcao/utils/type.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class InputPinCodePage extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final bool isForgot;
  const InputPinCodePage({Key key, this.phoneNumber, this.email, this.isForgot})
      : super(key: key);
  static Future navigate(
      {String phoneNumber, String email, bool isForgot = false}) {
    return navigatorKey.currentState.push(
      pageBuilder(
          InputPinCodePage(
            phoneNumber: phoneNumber,
            email: email,
            isForgot: isForgot,
          ),
          transitionBuilder: transitionRightBuilder),
    );
  }

  @override
  _InputPinCodePageState createState() => _InputPinCodePageState();
}

class _InputPinCodePageState extends State<InputPinCodePage> {
  TypeRegister _typeRegister;
  AuthBloc _authBloc;

  TextEditingController _otpC;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.email == null) {
      _typeRegister = TypeRegister.ByPhone;
    } else
      _typeRegister = TypeRegister.ByEmail;
    _otpC = TextEditingController();
    super.initState();
  }

  _codeSubmit() async {
    print(_otpC.text);
    showWaitingDialog(context);
    if (_typeRegister == TypeRegister.ByPhone) {
      await _authBloc.submitOtpRegister(widget.phoneNumber, _otpC.text,
          isForgot: widget.isForgot ?? false);
    } else {
      await _authBloc.verifyMail(widget.email, _otpC.text);
    }
  }

  _resendOtp() async {
    print("Resend");
    showWaitingDialog(context);
    if (_typeRegister == TypeRegister.ByPhone) {
      var result = await _authBloc.requestOtpRegister(widget.phoneNumber,
          isForgot: widget.isForgot ?? false);
      print(result);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.isForgot ? "QUÊN MẬT KHẨU" : "ĐĂNG KÝ",
          style: roboto_18_700().copyWith(
              color: isDarkMode
                  ? ptSecondaryColor(context)
                  : ptMainColor(context)),
        )),
        backgroundColor: ptPrimaryColor(context),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ptSecondaryColor(context),
      body: Container(
        height: deviceHeight(context),
        color: ptPrimaryColor(context),
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom != 0
                  ? -MediaQuery.of(context).viewInsets.bottom
                  : 0,
              right: 0,
              child: Container(width: deviceWidth(context), child: splash1),
            ),
            SingleChildScrollView(
              child: Container(
                width: deviceWidth(context),
                height: deviceHeight(context),
                child: Column(
                  children: [
                    _typeRegister == TypeRegister.ByPhone
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 65, vertical: 20),
                              child: Text(
                                "Mã xác nhận đã được gửi đến số điện thoại:",
                                style: roboto_18_700().copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 65, vertical: 20),
                              child: Text(
                                "Mã code đã được gửi đến email ${widget.email}, kiểm tra hòm thư và nhập vào bên dưới",
                                style: roboto_18_700().copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                    _typeRegister == TypeRegister.ByPhone
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 65, vertical: 20),
                              child: Text(
                                widget.phoneNumber,
                                style: roboto_18_700(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        obscureText: true,
                        textStyle: TextStyle(color: ptSecondaryColor(context)),
                        controller: _otpC,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 3) {
                            return "Invalid code";
                          } else {
                            return null;
                          }
                        },

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          selectedFillColor: ptPrimaryColor(context),
                          inactiveFillColor: ptPrimaryColor(context),
                          selectedColor: ptMainColor(context),
                          activeColor: ptSecondColor(),
                          inactiveColor: Colors.grey,
                          activeFillColor: ptPrimaryColor(context),
                        ),
                        backgroundColor: ptPrimaryColor(context),
                        cursorColor: ptMainColor(context),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        // errorAnimationController: errorController,
                        // controller: textEditingController,
                        keyboardType: TextInputType.number,

                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          print(v);
                          _codeSubmit();
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            // _otpC.text = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    ExpandBtn(
                      text: "XÁC NHẬN",
                      onPress: () => _codeSubmit(),
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ResendOTP(
                        onResend: _resendOtp,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResendOTP extends StatefulWidget {
  final VoidCallback onResend;
  const ResendOTP({
    Key key,
    this.onResend,
  }) : super(key: key);

  @override
  _ResendOTPState createState() => _ResendOTPState();
}

class _ResendOTPState extends State<ResendOTP> {
  Timer _timer;
  int _countdown = 60;

  @override
  void initState() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_countdown < 1) {
              timer.cancel();
            } else {
              setState(() {
                _countdown = _countdown - 1;
              });
            }
          },
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _countdown < 1
          ? () {
              widget.onResend();
              setState(() {
                _countdown = 60;
              });
            }
          : null,
      child: Center(
        child: Text(_countdown < 1
            ? "Gửi lại OTP"
            : "Gửi lại OTP sau $_countdown giây"),
      ),
    );
  }
}
