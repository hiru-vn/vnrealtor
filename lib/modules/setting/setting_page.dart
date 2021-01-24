import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/post/post_history_page.dart';
import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/modules/profile/verify_account_page1.dart';
import 'package:vnrealtor/modules/setting/about_page.dart';
import 'package:vnrealtor/modules/setting/point_page.dart';
import 'package:vnrealtor/modules/setting/policy_page.dart';
import 'package:vnrealtor/share/import.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final list = [
      {
        "name": "Bài đăng của tôi",
        "img": "assets/image/post.png",
        "action": () {
          PostHistoryPage.navigate();
        }
      },
      {
        "name": "Điểm uy tín: 23",
        "img": "assets/image/star_point.png",
        "action": () {
          PointPage.navigate();
        }
      },
      {
        "name": "Chia sẻ ứng dụng",
        "img": "assets/image/share_app.jpg",
        "action": () {
          showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
        }
      },
      {
        "name": "Ngôn ngữ",
        "img": "assets/image/language.png",
        "action": () {
          pickList(context,
              title: 'Chọn ngôn ngữ',
              onPicked: (value) {},
              options: ['Tiếng Việt', 'English'],
              closeText: 'Xong');
        }
      },
      {
        "name": "Điều khoản & chính sách",
        "img": "assets/image/policy.png",
        "action": () {
          PolicyPage.navigate();
        }
      },
      {
        "name": "Về chúng tôi",
        "img": "assets/image/logo.png",
        "action": () {
          AboutPage.navigate();
        }
      },
      {
        "name": "Phản hồi & Hỗ trợ",
        "img": "assets/image/feedback.png",
        "action": () {
          showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
        }
      },
      {
        "name": "Chế độ tối",
        "img": "assets/image/night_mode.png",
        "action": () {
          showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
        }
      },
      // {
      //   "name": "Đánh giá ứng dụng",
      //   "img": "assets/image/rate_us.png",
      //   "action": () {
      //     OpenAppstore.launch(
      //         androidAppId: "io.payvin.ex", iOSAppId: "284882215");
      //   }
      // },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ptPrimaryColorLight(context),
        centerTitle: true,
        elevation: 1,
        title: SizedBox(
            height: 30, child: Image.asset('assets/image/logo_full.png')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 1.3, color: ptDarkColor(context)),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage('assets/image/avatar.jpeg'),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nguyen Hung',
                          style:
                              ptTitle().copyWith(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 3),
                        GestureDetector(
                          onTap: () {
                            ProfilePage.navigate();
                          },
                          child: Text(
                            'Thông tin người dùng',
                            style: ptSmall().copyWith(color: Colors.blue[300]),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    VertifyAccountPage1.navigate();
                  },
                  child: Card(
                    color: ptDarkColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10)
                                      .copyWith(bottom: 5),
                                  child: Text(
                                    'Xác thực nhà môi giới',
                                    maxLines: null,
                                    style: ptBody().copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(10).copyWith(top: 0),
                                  child: Text(
                                    'Để đăng bài bds, bạn sẽ cần cung cấp thêm 1 số thông tin.',
                                    maxLines: 2,
                                    style: ptTiny().copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Container(
                                  height: 41,
                                  width: 41,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ptDarkColor(context),
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Center(
                                        child: Icon(
                                          Icons.verified_user,
                                          color: ptDarkColor(context),
                                          size: 27,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              StaggeredGridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                staggeredTiles: list.map((_) => StaggeredTile.fit(1)).toList(),
                children: List.generate(list.length, (index) {
                  return ProfileItemCard(
                    title: list[index]['name'],
                    image: list[index]['img'],
                    onTap: list[index]['action'],
                  );
                }),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExpandBtn(
                  elevation: 0,
                  text: 'Logout',
                  borderRadius: 5,
                  onPress: () {
                    AuthBloc.instance.logout();
                  },
                  color: ptGreyColor(context).withOpacity(0.6),
                  height: 45,
                  textColor: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'v1.0.21',
                style: ptSmall().copyWith(color: Colors.black54),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItemCard extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;

  const ProfileItemCard({Key key, this.image, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: deviceWidth(context) / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 5),
                      child: SizedBox(
                        width: deviceWidth(context) / 7,
                        child: Image.asset(
                          image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    title,
                    maxLines: null,
                    style: ptBody().copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
