import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/registers/create_account_success_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_app_bar.dart';
import 'package:datcao/utils/type.dart';
import 'package:flutter/gestures.dart';

class FormRegisterPage extends StatefulWidget {
  final String phoneNumber;
  final String email;
  const FormRegisterPage({Key key, this.phoneNumber, this.email})
      : super(key: key);
  static Future navigate({String phoneNumber, String email}) {
    return navigatorKey.currentState.push(pageBuilder(
        FormRegisterPage(
          phoneNumber: phoneNumber,
          email: email,
        ),
        transitionBuilder: transitionRightBuilder));
  }

  @override
  _FormRegisterPageState createState() => _FormRegisterPageState();
}

class _FormRegisterPageState extends State<FormRegisterPage> {
  bool _agree;
  TypeRegister _typeRegister;
  TextEditingController _passC = TextEditingController(),
      _rePassC = TextEditingController(),
      _usernameC = TextEditingController(),
      _nameC = TextEditingController(),
      _phoneC = TextEditingController(),
      _emailC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AuthBloc _authBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _agree = false;
    if (widget.email == null) {
      _typeRegister = TypeRegister.ByPhone;
    } else
      _typeRegister = TypeRegister.ByEmail;
  }

  _submitRegister() async {
    if (!_formKey.currentState.validate()) return;
    showWaitingDialog(context);
    if (_typeRegister == TypeRegister.ByPhone) {
      _authBloc.submitRegister(
        name: _nameC.text,
        email: _emailC.text,
        password: _passC.text,
        phone: widget.phoneNumber,
        username: _usernameC.text,
      );
    } else {
      _authBloc.submitRegisterByEmail(
          email: widget.email,
          name: _nameC.text,
          username: _usernameC.text,
          password: _passC.text,
          phone: _phoneC.text);
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
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          appBar: SecondAppBar(
            title: "Đăng ký tài khoản",
          ),
          body: SafeArea(
            child: Container(
              height: deviceHeight(context),
              color: ptPrimaryColor(context),
              child: SingleChildScrollView(
                child: Container(
                  width: deviceWidth(context),
                  height: deviceHeight(context),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "TẠO TÀI KHOẢN",
                          style: roboto_18_700().copyWith(
                              fontWeight: FontWeight.w600,
                              color: ptSecondColor()),
                        ),
                      ),
                      Text(
                          "Điền vào form bên dưới để bắt đầu quá trình đăng ký"),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/name_icon.png",
                                  width: 25,
                                ),
                                validator: TextFieldValidator.usernameValidator,
                                hintText: "Username",
                                controller: _usernameC,
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/user_icon.png",
                                  width: 25,
                                ),
                                controller: _nameC,
                                validator: TextFieldValidator.notEmptyValidator,
                                hintText: "Họ tên",
                              ),
                              _typeRegister == TypeRegister.ByPhone
                                  ? CustomInputField(
                                      icon: Image.asset(
                                        "assets/image/email_icon.png",
                                        width: 25,
                                      ),
                                      controller: _emailC,
                                      validator:
                                          TextFieldValidator.emailValidator,
                                      hintText: "Email",
                                    )
                                  : CustomInputField(
                                      icon: Image.asset(
                                        "assets/image/phone_icon.png",
                                        width: 25,
                                      ),
                                      controller: _phoneC,
                                      validator:
                                          TextFieldValidator.phoneValidator,
                                      hintText: "Phone",
                                    ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/password_icon.png",
                                  width: 25,
                                ),
                                hintText: "Mật khẩu",
                                controller: _passC,
                                validator: TextFieldValidator.passValidator,
                                obscureText: true,
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/password_icon.png",
                                  width: 25,
                                ),
                                controller: _rePassC,
                                hintText: "Nhập lại mật khẩu",
                                validator: (str) {
                                  if (str != _passC.text)
                                    return 'Mật khẩu không trùng khớp';
                                },
                                obscureText: true,
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: _agree,
                                checkColor: Colors.white,
                                activeColor: ptSecondColor(),
                                onChanged: (v) {
                                  setState(() {
                                    _agree = v;
                                  });
                                },
                                title: RichText(
                                  text: TextSpan(
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Tôi đồng ý với các ',
                                          style: ptBody().copyWith(
                                              color:
                                                  ptSecondaryColor(context))),
                                      TextSpan(
                                          text: 'điều khoản và chính sách',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              print('Tap');
                                            },
                                          style: ptBody()
                                              .copyWith(color: Colors.blue)),
                                      TextSpan(
                                          text: ' của DATCAO ',
                                          style: ptBody().copyWith(
                                              color: ptPrimaryColor(context))),
                                    ],
                                  ),
                                ),
                              ),
                              ExpandBtn(
                                text: "ĐĂNG KÝ",
                                onPress:
                                    _agree ? () => _submitRegister() : null,
                                width: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Đã có tài khoản công ty? ',
                                            style: ptBody().copyWith(
                                                color:
                                                    ptPrimaryColor(context))),
                                        TextSpan(
                                            text: 'Đăng ký tại đây',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print('Tap');
                                              },
                                            style: ptBody()
                                                .copyWith(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final Widget icon;
  final String hintText;
  final bool obscureText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) validator;
  const CustomInputField({
    Key key,
    this.icon,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool obscurePassword;

  @override
  void initState() {
    // TODO: implement initState
    obscurePassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: ptBackgroundColor(context),
            border: Border.all(color: HexColor.fromHex("#E5E5E5")),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 3, right: 10),
                child: widget.icon),
            Expanded(
              child: TextFormField(
                keyboardType: widget.keyboardType ?? TextInputType.text,
                cursorColor: ptMainColor(context),
                obscureText: obscurePassword,
                controller: widget.controller,
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: () {
                            audioCache.play('tab3.mp3');
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: Icon(
                            obscurePassword ? MdiIcons.eye : MdiIcons.eyeOff,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
