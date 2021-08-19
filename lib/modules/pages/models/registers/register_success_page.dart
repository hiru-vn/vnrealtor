import 'package:datcao/main.dart';
import 'package:datcao/modules/pages/models/registers/form_register_page.dart';
import 'package:datcao/share/import.dart';

class RegisterSuccessPage extends StatefulWidget {
  const RegisterSuccessPage({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(RegisterSuccessPage(),
        transitionBuilder: transitionRightBuilder));
  }

  @override
  _RegisterSuccessPageState createState() => _RegisterSuccessPageState();
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 80),
                      child: Text(
                        "ĐĂNG KÝ THÀNH CÔNG!",
                        style: roboto_18_700().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: ptSecondColor(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Bây giờ bạn có thể điền các thông tin cơ bản để hoàn thiện tài khoản!",
                        style: roboto_18_700().copyWith(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: Center(
                          child: Image.asset("assets/image/success.png")),
                    ),
                    ExpandBtn(
                      text: "Bắt đầu",
                      onPress: () => {FormRegisterPage.navigate()},
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
