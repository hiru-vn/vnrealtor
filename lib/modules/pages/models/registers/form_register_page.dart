import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_app_bar.dart';
import 'package:flutter/gestures.dart';

class FormRegisterPage extends StatefulWidget {
  const FormRegisterPage({Key key}) : super(key: key);
  static Future navigate({String phoneNumber}) {
    return navigatorKey.currentState.push(pageBuilder(FormRegisterPage(),
        transitionBuilder: transitionRightBuilder));
  }

  @override
  _FormRegisterPageState createState() => _FormRegisterPageState();
}

class _FormRegisterPageState extends State<FormRegisterPage> {
  bool _agree;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _agree = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            leading: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () => Navigator.pop(context),
            ),
            title: Center(
                child: Text(
              "Đăng ký tài khoản",
              style: roboto_18_700().copyWith(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            )),
            actions: [
              SizedBox(
                width: 30,
              )
            ],
          ),
          body: SafeArea(
            child: Container(
              height: deviceHeight(context),
              color: Colors.white,
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
                          child: Column(
                            children: [
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/name_icon.png",
                                  width: 25,
                                ),
                                hintText: "Username",
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/user_icon.png",
                                  width: 25,
                                ),
                                hintText: "Họ tên",
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/email_icon.png",
                                  width: 25,
                                ),
                                hintText: "Email",
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/password_icon.png",
                                  width: 25,
                                ),
                                hintText: "Mật khẩu",
                                obscureText: true,
                              ),
                              CustomInputField(
                                icon: Image.asset(
                                  "assets/image/password_icon.png",
                                  width: 25,
                                ),
                                hintText: "Nhập lại mật khẩu",
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
                                          style: ptBody()),
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
                                          style: ptBody()),
                                    ],
                                  ),
                                ),
                              ),
                              ExpandBtn(
                                text: "ĐĂNG KÝ",
                                onPress: null,
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
                                            style: ptBody()),
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

class CustomInputField extends StatelessWidget {
  final Widget icon;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomInputField({
    Key key,
    this.icon,
    this.hintText,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: HexColor.fromHex("#F5F5F5"),
            border: Border.all(color: HexColor.fromHex("#E5E5E5")),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 3, right: 10),
                child: icon),
            Expanded(
              child: TextFormField(
                cursorColor: ptMainColor(),
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: roboto_18_700().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: HexColor.fromHex("#505050")),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
