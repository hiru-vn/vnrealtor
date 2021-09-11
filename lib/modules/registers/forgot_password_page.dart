import 'dart:async';

import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/registers/create_account_success_page.dart';
import 'package:datcao/modules/registers/form_register_page.dart';
import 'package:datcao/modules/registers/input_code_page.dart';
import 'package:datcao/share/import.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    Key key,
  }) : super(key: key);
  static Future navigate({String phoneNumber, String email}) {
    return navigatorKey.currentState.push(pageBuilder(ForgotPasswordPage(),
        transitionBuilder: transitionRightBuilder));
  }

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AuthBloc _authBloc;
  StreamSubscription listener;
  PhoneNumber _initPhoneNumber = PhoneNumber(isoCode: 'VN');
  bool _validPhone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      listener = _authBloc.authStatusStream.listen((event) async {
        if (event.status == AuthStatus.authFail) {
          closeLoading();
          showToast(event.errMessage, context);
        }
        if (event.status == AuthStatus.otpForgotSent) {
          closeLoading();
          InputPinCodePage.navigate(
            phoneNumber: "0" + _initPhoneNumber.parseNumber(),
          );
        }
        if (event.status == AuthStatus.requestOtp) {}
        if (event.status == AuthStatus.successForgotOtp) {
          closeLoading();
          // RegisterSuccessPage.navigate(
          //     phoneNumber: "0" + _initPhoneNumber.parseNumber());
          // navigatorKey.currentState.maybePop();
        }
      });
    }
    super.didChangeDependencies();
  }

  void _submitPhoneNumber() async {
    if (_validPhone) {
      showWaitingDialog(context);
      final res = await UserBloc.instance
          .checkValidUser(phone: "0" + _initPhoneNumber.parseNumber());
      if (res.data != 1) {
        _authBloc.requestOtpRegister(_initPhoneNumber.parseNumber(),
            isForgot: true);
      } else {
        closeLoading();
        showToast("Số điện thoại chưa tồn tại trong hệ thống", context);
      }
    } else {
      showToast("Số điện thoại không hợp lệ", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(width: deviceWidth(context), child: splash1),
            ),
            SingleChildScrollView(
              child: Container(
                width: deviceWidth(context),
                height: deviceHeight(context),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 40),
                      child: Center(
                          child: Image.asset("assets/image/security.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40, top: 20),
                      child: Text(
                        "QUÊN MẬT KHẨU?",
                        style: roboto_18_700().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: ptSecondColor(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ptBackgroundColor(context),
                            border:
                                Border.all(color: HexColor.fromHex("#E5E5E5")),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              _initPhoneNumber = number;
                            },
                            onInputValidated: (bool value) {
                              print(value);
                              _validPhone = value;
                            },
                            validator: (value) {
                              if (value.length < 10)
                                return "Số điện thoại không hợp lệ";
                              return null;
                            },
                            initialValue: _initPhoneNumber,
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            searchBoxDecoration: InputDecoration(
                              hintText: "Tìm kiếm",
                            ),
                            ignoreBlank: false,
                            maxLength: 11,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(
                              color: ptAccentColor(context),
                            ),
                            formatInput: false,
                            hintText: "Số điện thoại",
                            onSubmit: () {
                              print(_initPhoneNumber.phoneNumber);
                            },
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: InputBorder.none,
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                        ),
                      ),
                    ),
                    ExpandBtn(
                      text: "Khôi phục mật khẩu",
                      onPress: _submitPhoneNumber,
                      width: 200,
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
