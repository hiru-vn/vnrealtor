import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/pages/pages/pages_page.dart';
import 'package:datcao/modules/profile/profile_page.dart';
import 'package:datcao/modules/profile/update_profile_page.dart';
import 'package:datcao/modules/profile/verify_account_page1.dart';
import 'package:datcao/modules/profile/verify_company.dart';
import 'package:datcao/modules/setting/about_page.dart';
import 'package:datcao/modules/setting/policy_page.dart';
import 'package:datcao/modules/setting/saved_post_page.dart';
import 'package:datcao/share/function/share_to.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';
import 'package:package_info/package_info.dart';
import 'package:datcao/share/import.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      // {
      //   "name": "Bài đăng của tôi",
      //   "img": "assets/image/post.png",
      //   "action": () {
      //     PostHistoryPage.navigate();
      //   }
      // },
      {
        "name":
            "Điểm tương tác: ${_authBloc.userModel.reputationScore.toString()}",
        "img": "assets/image/star_point.png",
        "action": () {
          showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
          // PointPage.navigate();
        }
      },
      {
        "name": "Chia sẻ ứng dụng",
        "img": "assets/image/share_app.png",
        "action": () {
          shareTo(context,
              image: [
                'https://firebasestorage.googleapis.com/v0/b/vnrealtor-52b40.appspot.com/o/datacao_promote.png?alt=media&token=b7d7db60-f108-46eb-8a50-22f003f2dc83'
              ],
              content:
                  'Tải về ứng dụng Datcao: mạng xã hội bất động sản dành cho người Việt tại https://datcao.page.link/iGuj');
        }
      },
      // {
      //   "name": "Ngôn ngữ",
      //   "img": "assets/image/language.png",
      //   "action": () {
      //     pickList(context,
      //         title: 'Chọn ngôn ngữ',
      //         onPicked: (value) {},
      //         options: [
      //           PickListItem('vi', 'Tiếng Việt'),
      //           PickListItem('en', 'English')
      //         ],
      //         closeText: 'Xong');
      //   }
      // },

      // {
      //   "name": "Chính sách bảo mật",
      //   "img": "assets/image/privacy.png",
      //   "action": () {
      //     PrivacyPage.navigate();
      //   }
      // },
      {
        "name": "Trang",
        "img": "assets/image/page.png",
        "action": () {
          PagesPage.navigate();
        }
      },
      {
        "name": "Bài viết đã lưu",
        "img": "assets/image/saved_post.png",
        "action": () {
          SavedPostPage.navigate();
        }
      },
      {
        "name": "Về chúng tôi",
        "img": "assets/image/about.png",
        "action": () {
          AboutPage.navigate();
        }
      },
      {
        "name": "Điều khoản và\nchính sách",
        "img": "assets/image/policy.png",
        "action": () {
          PolicyPage.navigate();
        }
      },
      // {
      //   "name": "Phản hồi & Hỗ trợ",
      //   "img": "assets/image/feedback.png",
      //   "action": () {
      //     showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
      //   }
      // },
      // {
      //   "name": "Chế độ tối",
      //   "img": "assets/image/night_mode.png",
      //   "action": () {
      //     showAlertDialog(context, 'Đang cập nhật', navigatorKey: navigatorKey);
      //   }
      // },
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
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ptPrimaryColorLight(context),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        brightness: Brightness.light,
        title: SizedBox(
            height: 30, child: Image.asset('assets/image/logo_full.png')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => ProfilePage.navigate(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage: AuthBloc.instance.userModel.avatar !=
                                  null
                              ? CachedNetworkImageProvider(
                                  AuthBloc.instance.userModel.avatar)
                              : AssetImage('assets/image/default_avatar.png'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                _authBloc.userModel?.name ?? '',
                                style: ptTitle()
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),
                              SizedBox(width: 8),
                              if (UserBloc.isVerified(_authBloc.userModel))
                                CustomTooltip(
                                  margin: EdgeInsets.only(top: 0),
                                  message: 'Tài khoản xác thực',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue[600],
                                    ),
                                    padding: EdgeInsets.all(1.3),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 11,
                                    ),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(height: 3),
                          GestureDetector(
                            onTap: () {
                              audioCache.play('tab3.mp3');
                              UpdateProfilePage.navigate()
                                  .then((value) => setState(() {}));
                            },
                            child: Text(
                              AuthBloc.instance.userModel.role == 'AGENT'
                                  ? 'Cập nhật thông tin'
                                  : 'Cập nhật thông tin',
                              style: ptSmall()
                                  .copyWith(color: ptPrimaryColor(context)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if ((AuthBloc.instance.userModel.role != 'COMPANY' ||
                      !AuthBloc.instance.userModel.isVerify) &&
                  ['AGENT', 'COMPANY', 'EDITOR']
                      .contains(AuthBloc.instance.userModel.role))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      audioCache.play('tab3.mp3');
                      if (_authBloc.userModel.role == 'COMPANY') {
                        VerifyCompany.navigate();
                        return;
                      }
                      VertifyAccountPage1.navigate();
                    },
                    child: Card(
                      elevation: 0,
                      color: ptSecondaryColor(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _authBloc.userModel.role != 'AGENT'
                                        ? Colors.transparent
                                        : ptSecondaryColor(context)),
                                child: Center(
                                  child: Container(
                                    height: 41,
                                    width: 41,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ptDarkColor(context),
                                    ),
                                    child: _authBloc.userModel.role == 'AGENT'
                                        ? Center(
                                            child: Container(
                                              height: 38,
                                              width: 38,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ptSecondaryColor(
                                                      context)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.verified_user,
                                                  color: ptDarkColor(context),
                                                  size: 27,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/image/no_agency.png'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10)
                                        .copyWith(bottom: 5, left: 3),
                                    child: Text(
                                      (() {
                                        if (_authBloc.userModel.role == 'AGENT')
                                          return 'Bạn đã là nhà môi giới';
                                        else if (_authBloc.userModel.role ==
                                            'EDITOR')
                                          return 'Xác thực nhà môi giới';
                                        else if (_authBloc.userModel.role ==
                                            'COMPANY')
                                          return 'Xác thực tài khoản doanh nghiệp';
                                        return '';
                                      }()),
                                      maxLines: null,
                                      style: ptBody().copyWith(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10)
                                        .copyWith(top: 0, left: 3),
                                    child: Text(
                                      _authBloc.userModel.role != 'AGENT'
                                          ? 'Để đăng bài bds, bạn sẽ cần cung cấp thêm 1 số thông tin.'
                                          : 'Cập nhật lại thông tin nhà môi giới của bạn tại đây',
                                      maxLines: 2,
                                      style: ptSmall(),
                                    ),
                                  ),
                                ],
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExpandBtn(
                  elevation: 0,
                  text: 'Đăng xuất',
                  borderRadius: 5,
                  onPress: () {
                    AuthBloc.instance.logout();
                  },
                  color: ptGreyColor(context).withOpacity(0.6),
                  height: 45,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox.shrink();
                    return Text(
                      'v${snapshot.data.version}',
                      style: ptSmall().copyWith(color: Colors.black54),
                    );
                  }),
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
        onTap: () {
          onTap();
          audioCache.play('tab3.mp3');
        },
        child: Card(
          // elevation: 3,
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
