import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/share/import.dart';

class IntroducePage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState
        .pushReplacement(pageBuilder(IntroducePage()));
  }

  final _pageC = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: deviceWidth(context),
          child: PageView(controller: _pageC, children: [
            IntroSlide(
              index: 0,
              text: 'Kết nối mua, bán, cho thuê bất động sản dễ dàng',
              nextTap: () {
                _pageC.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.decelerate);
              },
            ),
            IntroSlide(
              index: 1,
              text:
                  'Đăng tin bài viết nhanh chóng, tiếp cận khách hàng hiệu quả',
              nextTap: () {
                _pageC.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.decelerate);
              },
            ),
            IntroSlide(
              index: 2,
              text:
                  'Nhanh chóng tìm thấy căn nhà mà bạn yêu thích theo địa điểm, giá cả, ngoại hình',
              nextTap: () {
                LoginPage.navigate();
              },
            ),
          ])),
    );
  }
}

class IntroSlide extends StatelessWidget {
  final int index;
  final String text;
  final Function nextTap;

  const IntroSlide({Key key, this.index, this.text, this.nextTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 0,
        child: Container(
          width: deviceWidth(context),
          height: deviceHeight(context) / 3 * 2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  colorFilter:
                      ColorFilter.mode(Colors.black38, BlendMode.darken),
                  image: AssetImage('assets/image/bg_intro.jpg'))),
          child: SizedBox(
              width: deviceWidth(context) / 3,
              child: Image.asset('assets/image/logo_full_white.png')),
        ),
      ),
      Positioned(
        top: deviceHeight(context) / 3 * 2 - 35,
        width: deviceWidth(context),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? ptPrimaryColor(context) : Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 1 ? ptPrimaryColor(context) : Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 2 ? ptPrimaryColor(context) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          width: deviceWidth(context),
          height: deviceHeight(context) / 3,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/image/bg_foot_gradient.png')),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              Expanded(
                child: Center(
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: ptBigTitle().copyWith(color: Colors.white)),
                ),
              ),
              RoundedBtn(
                height: 45,
                text: 'Tiếp theo',
                onPressed: nextTap,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                hasBorder: true,
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      )
    ]);
  }
}
