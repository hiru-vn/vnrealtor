import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/profile/change_password_page.dart';
import 'package:datcao/share/import.dart';

class UpdateProfilePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(UpdateProfilePage()),
    );
  }

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  AuthBloc _authBloc;
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  Future _updateProfile() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2('Cập nhật thông tin'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      NetworkImage(_authBloc.userModel.avatar ?? ''),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      child: Center(
                        child: Icon(
                          MdiIcons.camera,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SpacingBox(h: 3),
            Container(
              width: deviceWidth(context),
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  _buildFormField(context, 'Tên người dùng'),
                  SizedBox(height: 15),
                  _buildFormField(context, 'Email'),
                  SizedBox(height: 15),
                  _buildFormField(context, 'Số điện thoại'),
                  SpacingBox(h: 3),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundedBtn(
                          height: 45,
                          text: 'Cập nhật',
                          onPressed: () async {
                            await navigatorKey.currentState.maybePop();
                            await navigatorKey.currentState.maybePop();
                          },
                          width: 140,
                          color: ptPrimaryColor(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                        ),
                        RoundedBtn(
                          height: 45,
                          text: 'Đổi mật khẩu',
                          onPressed: () async {
                            UpdatePasswordPage.navigate();
                          },
                          width: 140,
                          color: Colors.blue[300],
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildFormField(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ptBackgroundColor(context)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
              child: TextField(
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: text),
              ),
            )),
      );
}
