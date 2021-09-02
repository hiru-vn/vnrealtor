import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/share/import.dart';

class UpdatePasswordPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(UpdatePasswordPage()),
    );
  }

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  UserBloc _userBloc;
  TextEditingController _passC = TextEditingController();
  TextEditingController _newPassC = TextEditingController();
  TextEditingController _rePassC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
    }
    super.didChangeDependencies();
  }

  _submit() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });
    final res = await _userBloc.changePassword(_passC.text, _newPassC.text);
    if (res.isSuccess) {
      showToast('Change password successfully', context, isSuccess: true);
      await navigatorKey.currentState.maybePop();
      await navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ptPrimaryColor(context),
          appBar: const SecondAppBar(
            title: 'Đổi mật khẩu',
            actions: [SizedBox(width: 30)],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SpacingBox(h: 3),
                  SizedBox(
                    width: 90,
                    child: Image.asset('assets/image/logo_datcao.png'),
                  ),
                  SpacingBox(h: 3),
                  Container(
                    width: deviceWidth(context),
                    color: ptPrimaryColor(context),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        _buildFormField(context, 'Mật khẩu hiện tại', _passC,
                            TextFieldValidator.passValidator),
                        SizedBox(height: 15),
                        _buildFormField(context, 'Mật khẩu mới', _newPassC,
                            TextFieldValidator.passValidator),
                        SizedBox(height: 15),
                        _buildFormField(
                            context, 'Nhập lại mật khẩu mới', _rePassC, (str) {
                          if (str != _newPassC.text)
                            return 'Not the same password';
                          return null;
                        }),
                        SpacingBox(h: 3),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: RoundedBtn(
                              height: 45,
                              text: 'Cập nhật',
                              onPressed: _submit,
                              width: 150,
                              hasBorder: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (isLoading) kLoadingSpinner
      ],
    );
  }

  _buildFormField(BuildContext context, String hint,
          TextEditingController controller, Function(String) validator) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ptPrimaryColor(context),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
              child: TextFormField(
                validator: validator,
                obscureText: true,
                controller: controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: hint),
              ),
            )),
      );
}
