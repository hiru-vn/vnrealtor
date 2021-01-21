import 'package:vnrealtor/modules/profile/change_password_page.dart';
import 'package:vnrealtor/share/import.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2('Cập nhật thông tin'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            SizedBox(
              width: 90,
              child: Image.asset('assets/image/logo.png'),
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
