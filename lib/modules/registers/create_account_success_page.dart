import 'package:datcao/main.dart';
import 'package:datcao/modules/home_page.dart';
import 'package:datcao/modules/registers/form_register_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/type.dart';

class CreateAccountSuccessPage extends StatefulWidget {
  final String phoneNumber;
  final String email;
  const CreateAccountSuccessPage({Key key, this.phoneNumber, this.email})
      : super(key: key);
  static Future navigate({String phoneNumber, String email}) {
    return navigatorKey.currentState.push(pageBuilder(
        CreateAccountSuccessPage(
          email: email,
          phoneNumber: phoneNumber,
        ),
        transitionBuilder: transitionRightBuilder));
  }

  @override
  _CreateAccountSuccessPageState createState() =>
      _CreateAccountSuccessPageState();
}

class _CreateAccountSuccessPageState extends State<CreateAccountSuccessPage> {
  TypeRegister _typeRegister;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.email == null) {
      _typeRegister = TypeRegister.ByPhone;
    } else
      _typeRegister = TypeRegister.ByEmail;
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
                          child:
                              Image.asset("assets/image/update_success.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40),
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
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40),
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
                    ExpandBtn(
                      text: "Bắt đầu",
                      onPress: () => HomePage.navigate(),
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
