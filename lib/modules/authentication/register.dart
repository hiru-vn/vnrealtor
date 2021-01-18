import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/share/import.dart';

class RegisterPage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Đăng kí',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SpacingBox(h: 1.5),
          Center(
              child: SizedBox(
                  width: deviceWidth(context) / 2,
                  child: Image.asset('assets/image/logo_full.png'))),
          SpacingBox(h: 3),
          _buildFormField(context, 'Tên người dùng'),
          SpacingBox(h: 2.5),
          _buildFormField(context, 'Số điện thoại'),
          SpacingBox(h: 2.5),
          _buildFormField(context, 'Mật khẩu'),
          SpacingBox(h: 2.5),
          _buildFormField(context, 'Nhập lại mật khẩu'),
          SpacingBox(h: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {},
              child: RichText(
                maxLines: null,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: ptTitle(),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Bằng việc đăng kí tài khoản, bạn đồng ý với',
                    ),
                    TextSpan(
                      text: ' Điều kiện và điều khoản ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(text: ' của VNRealtor'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: Responsive.heightMultiplier * 15,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExpandBtn(
                  text: 'Đăng kí',
                  onPress: () {
                    HomePage.navigate();
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _buildFormField(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
