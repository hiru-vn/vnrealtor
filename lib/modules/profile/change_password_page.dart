import 'package:vnrealtor/share/import.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2('Đổi mật khẩu'),
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
                  _buildFormField(context, 'Mật khẩu hiện tại'),
                  SizedBox(height: 15),
                  _buildFormField(context, 'Mật khẩu mới'),
                  SizedBox(height: 15),
                  _buildFormField(context, 'Nhập lại mật khẩu mới'),
                  SpacingBox(h: 3),
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: RoundedBtn(
                          height: 45,
                          text: 'Cập nhật',
                          onPressed: () async {
                            await navigatorKey.currentState.maybePop();
                            await navigatorKey.currentState.maybePop();
                          },
                          width: 150,
                          color: ptPrimaryColor(context),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                        ),
                      )),
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
