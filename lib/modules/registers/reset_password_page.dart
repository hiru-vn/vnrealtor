import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/registers/form_register_page.dart';
import 'package:datcao/share/import.dart';

class ResetPasswordPage extends StatefulWidget {
  static Future navigate({String phoneNumber, String email}) {
    return navigatorKey.currentState.push(pageBuilder(ResetPasswordPage(),
        transitionBuilder: transitionRightBuilder));
  }

  const ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _passC = TextEditingController(text: '');
  TextEditingController _rePassC = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureRePassword = true;
  AuthBloc _authBloc;

  _submitResetPassword() async {
    if (!_formKey.currentState.validate()) return;
    showWaitingDialog(context);
    await _authBloc.resetPass(_passC.text);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _authBloc = Provider.of<AuthBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ptPrimaryColor(context),
          appBar: SecondAppBar(
            title: "Quên mật khẩu",
          ),
          body: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lấy lại mật khẩu",
                        style: ptHeadLineSmall(),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Vui lòng nhập mật khẩu mới ( mà bạn chưa từng sử dụng trước đây) vào phía dưới",
                        style: ptTitle(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        obscureText: obscurePassword,
                        controller: _passC,
                        validator: TextFieldValidator.passValidator,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                              obscurePassword ? MdiIcons.eye : MdiIcons.eyeOff,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: obscureRePassword,
                        controller: _rePassC,
                        validator: (str) {
                          if (str != _passC.text)
                            return 'Mật khẩu không trùng khớp';
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Nhập lại mật khẩu",
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              audioCache.play('tab3.mp3');
                              setState(() {
                                obscureRePassword = !obscureRePassword;
                              });
                            },
                            child: Icon(
                              obscureRePassword
                                  ? MdiIcons.eye
                                  : MdiIcons.eyeOff,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ExpandBtn(
                      width: 200,
                      onPress: () {
                        _submitResetPassword();
                      },
                      text: 'Tiếp',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
