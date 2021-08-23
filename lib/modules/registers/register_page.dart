import 'dart:async';

import 'package:datcao/main.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/registers/create_account_success_page.dart';
import 'package:datcao/modules/registers/form_register_page.dart';
import 'package:datcao/modules/registers/input_code_page.dart';
import 'package:datcao/modules/registers/register_success_page.dart';
import 'package:datcao/share/import.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(
        pageBuilder(RegisterPage(), transitionBuilder: transitionRightBuilder));
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "ĐĂNG KÝ",
          style: roboto_18_700().copyWith(color: ptMainColor()),
        )),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ptSecondaryColor(context),
      body: Container(
        height: deviceHeight(context),
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom != 0
                  ? -MediaQuery.of(context).viewInsets.bottom
                  : 0,
              right: 0,
              child: Container(width: deviceWidth(context), child: splash2),
            ),
            // SingleChildScrollView(
            //   child: Column(
            //     children: [],
            //   ),
            // ),
            SingleChildScrollView(
              child: Container(
                width: deviceWidth(context),
                height: deviceHeight(context),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          currentTab == 0
                              ? "Vui lòng nhập mã quốc gia và số điện thoại đăng ký"
                              : "Vui lòng nhập địa chỉ email và chúng tôi sẽ gửi sẽ gửi cho bạn 1 mã code",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Container(
                        child: TabBar(
                          tabs: [
                            Align(
                              alignment: Alignment.center,
                              child: Text("Số điện thoại"),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Email"))
                          ],
                          indicatorSize: TabBarIndicatorSize.tab,
                          onTap: (value) {
                            setState(() {
                              currentTab = value;
                            });
                          },
                          indicatorWeight: 3,
                          indicatorColor: ptSecondColor(),
                          labelPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          controller: _tabController,
                          labelColor: ptSecondColor(),
                          unselectedLabelColor: Colors.black54,
                          unselectedLabelStyle:
                              TextStyle(fontSize: 14, color: Colors.black12),
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ResisterByPhoneForm(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ResisterByEmailForm(),
                        ),
                      ]),
                    ),
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

class ResisterByPhoneForm extends StatefulWidget {
  @override
  _ResisterByPhoneFormState createState() => _ResisterByPhoneFormState();
}

class _ResisterByPhoneFormState extends State<ResisterByPhoneForm> {
  PhoneNumber _initPhoneNumber = PhoneNumber(isoCode: 'VN');
  AuthBloc _authBloc;
  StreamSubscription listener;
  bool _validPhone = false;
  @override
  void initState() {
    // TODO: implement initState
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
        if (event.status == AuthStatus.authSucces) {
          CreateAccountSuccessPage.navigate();
        }
        if (event.status == AuthStatus.otpSent) {
          closeLoading();
          InputPinCodePage.navigate(
            phoneNumber: "0" + _initPhoneNumber.parseNumber(),
          );
        }
        if (event.status == AuthStatus.requestOtp) {}
        if (event.status == AuthStatus.successOtp) {
          closeLoading();
          RegisterSuccessPage.navigate(
              phoneNumber: "0" + _initPhoneNumber.parseNumber());
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
      if (res.isSuccess) {
        _authBloc.requestOtpRegister(_initPhoneNumber.parseNumber());
      } else {
        closeLoading();
        showToast(res.errMessage, context);
      }
    } else {
      showToast("Số điện thoại không hợp lệ", context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listener.cancel();
    _authBloc.authStatusSink.add(AuthResponse.unAuthed());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: HexColor.fromHex("#F5F5F5"),
                border: Border.all(color: HexColor.fromHex("#E5E5E5")),
                borderRadius: BorderRadius.all(Radius.circular(10))),
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
                if (value.length < 10) return "Số điện thoại không hợp lệ";
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
                color: HexColor.fromHex("#BBBBBB"),
              ),
              formatInput: false,
              hintText: "Số điện thoại",
              onSubmit: () {
                print(_initPhoneNumber.phoneNumber);
              },
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: InputBorder.none,
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ),
          SizedBox(
            height: 150,
          ),
          ExpandBtn(
            width: 200,
            text: "TIẾP THEO",
            onPress: () => _submitPhoneNumber(),
          ),
        ],
      ),
    );
  }
}

class ResisterByEmailForm extends StatefulWidget {
  @override
  _ResisterByEmailFormState createState() => _ResisterByEmailFormState();
}

class _ResisterByEmailFormState extends State<ResisterByEmailForm> {
  TextEditingController _controller;

  AuthBloc _authBloc;
  StreamSubscription listener;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
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
        if (event.status == AuthStatus.authSucces) {
          CreateAccountSuccessPage.navigate();
        }
        if (event.status == AuthStatus.otpSent) {
          closeLoading();
          InputPinCodePage.navigate(
            email: _controller.text,
          );
        }
        if (event.status == AuthStatus.requestOtp) {}
        if (event.status == AuthStatus.successOtp) {
          closeLoading();
          RegisterSuccessPage.navigate(email: _controller.text);
          // navigatorKey.currentState.maybePop();
        }
      });
    }
    super.didChangeDependencies();
  }

  void _submitEmail() async {
    if (!_formKey.currentState.validate()) return;
    showWaitingDialog(context);
    // _authBloc.sendMailVer(_controller.text);

    final res = await UserBloc.instance.checkValidUser(email: _controller.text);
    if (res.isSuccess) {
      _authBloc.sendMailVer(_controller.text);
    } else {
      closeLoading();
      showToast(res.errMessage, context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listener.cancel();
    _authBloc.authStatusSink.add(AuthResponse.unAuthed());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomInputField(
              controller: _controller,
              validator: TextFieldValidator.emailValidator,
              icon: Image.asset(
                "assets/image/email_icon.png",
                width: 30,
              ),
              hintText: "Email",
            ),
            SizedBox(
              height: 150,
            ),
            ExpandBtn(
              width: 200,
              text: "TIẾP THEO",
              onPress: () => _submitEmail(),
            )
          ],
        ),
      ),
    );
  }
}
