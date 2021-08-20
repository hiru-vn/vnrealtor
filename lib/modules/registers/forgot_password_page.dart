import 'package:datcao/main.dart';
import 'package:datcao/modules/registers/form_register_page.dart';
import 'package:datcao/share/import.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: CustomInputField(
                        icon: Image.asset(
                          "assets/image/phone_icon.png",
                          width: 25,
                        ),
                        hintText: "Số điện thoại hoặc email",
                      ),
                    ),
                    ExpandBtn(
                      text: "Khôi phục mật khẩu",
                      onPress: null,
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
