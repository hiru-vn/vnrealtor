import 'package:vnrealtor/modules/authentication/register.dart';
import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/share/widget/appbar.dart';
import 'package:vnrealtor/utils/device_info.dart';

class LoginPage extends StatelessWidget {
  static Future navigate() {
    DeviceInfo.instance.getDeviceId().then((value) => print('dvid: ' + value));
    return navigatorKey.currentState.pushReplacement(pageBuilder(LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Đăng nhập',
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SpacingBox(h: 1.5),
          Center(
              child: SizedBox(
                  width: deviceWidth(context) / 3,
                  child: Image.asset('assets/image/logo.png'))),
          SpacingBox(h: 1.5),
          Text(
            'Chào mừng bạn đến với VN Realtor App',
            style: ptTitle(),
          ),
          SpacingBox(h: 1.5),
          DropdownButton(
              underline: SizedBox.shrink(),
              elevation: 0,
              icon: Icon(Icons.keyboard_arrow_down),
              value: 'vi',
              items: [
                DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.all(5).copyWith(right: 0),
                    child: Row(
                      children: [
                        Image.asset('assets/image/vn_flag.png'),
                        SizedBox(width: 8),
                        Text('VI'),
                      ],
                    ),
                  ),
                  value: 'vi',
                )
              ],
              onChanged: (val) {}),
          SpacingBox(h: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Email hoặc SĐT'),
                  ),
                )),
          ),
          SpacingBox(h: 2.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25)
                    .copyWith(right: 10),
                child: TextField(
                    decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mật khẩu',
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                  ),
                )),
              ),
            ),
          ),
          SpacingBox(h: 2.5),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Text(
                'Quên mật khẩu?',
                style: ptTitle().copyWith(color: Colors.black54),
              ),
            ),
          ),
          SizedBox(
            height: Responsive.heightMultiplier * 15,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExpandBtn(
                  text: 'Đăng nhập',
                  onPress: () {
                    HomePage.navigate();
                  },
                ),
              ),
            ),
          ),
          SpacingBox(h: 2.5),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Chưa có tài khoản?',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () => RegisterPage.navigate(),
              child: Text(
                'Đăng kí ngay',
                style: TextStyle(
                    color: Colors.orange, decoration: TextDecoration.underline),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
