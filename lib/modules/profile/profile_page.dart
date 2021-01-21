import 'package:vnrealtor/modules/post/post_widget.dart';
import 'package:vnrealtor/modules/post/search_people_widget.dart';
import 'package:vnrealtor/modules/profile/update_profile_page.dart';
import 'package:vnrealtor/share/import.dart';

class ProfilePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(ProfilePage()));
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _pageController;

  @override
  void initState() {
    _pageController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2(
        'Thông tin cá nhân',
        actions: [
          GestureDetector(
            onTap: () {
              UpdateProfilePage.navigate();
            },
            child: SizedBox(
              width: 40,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: ProfileCard(),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateTo(0);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: Text(
                        'Bài viết',
                        style: ptBigTitle().copyWith(
                            color: _pageController.index == 0
                                ? Colors.black
                                : Colors.black38),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateTo(1);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: Text(
                        'Bạn bè',
                        style: ptBigTitle().copyWith(
                            color: _pageController.index == 1
                                ? Colors.black
                                : Colors.black38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListView(
                children: [PostWidget(), PostWidget(), PostWidget()],
              ),
              ListView(
                children: [PeopleWidget(), PeopleWidget(), PeopleWidget()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
          borderRadius: BorderRadius.circular(5),
          elevation: 3,
          child: Container(
            width: deviceWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14)
                .copyWith(right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/image/avatar.jpeg'),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              'Nguyễn Hùng',
                              style:
                                  ptBigTitle().copyWith(color: Colors.black87),
                            ),
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Điểm uy tín: 13',
                                  style:
                                      ptBody().copyWith(color: Colors.black54),
                                ),
                                SizedBox(width: 2),
                                Image.asset('assets/image/coin.png'),
                              ],
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Nhà môi giới',
                              style: ptSmall().copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            'Kết bạn',
                            style: ptBody().copyWith(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: 70,
                    child: Center(
                      child: Text(
                        '3 bài viết',
                        style: ptSmall().copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      SizedBox(
                          width: 70,
                          child: Center(
                            child: Icon(
                              Icons.phone,
                              color: ptPrimaryColor(context),
                              size: 28,
                            ),
                          )),
                      Container(
                        width: 2,
                        height: 35,
                        color: ptLineColor(context),
                      ),
                      SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số điện thoại',
                            style: ptBody().copyWith(color: Colors.black54),
                          ),
                          Text(
                            '+84 971 904 687',
                            style: ptBody().copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      SizedBox(
                          width: 70,
                          child: Center(
                            child: Icon(
                              Icons.email,
                              color: ptPrimaryColor(context),
                              size: 28,
                            ),
                          )),
                      Container(
                        width: 2,
                        height: 35,
                        color: ptLineColor(context),
                      ),
                      SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: ptBody().copyWith(color: Colors.black54),
                          ),
                          Text(
                            'adminemail@gmail.com',
                            style: ptBody().copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
          )),
    );
  }
}
