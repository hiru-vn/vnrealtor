import 'package:vnrealtor/modules/post/post_widget.dart';
import 'package:vnrealtor/share/import.dart';

class ProfilePage extends StatelessWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2(
        'Thông tin cá nhân',
        actions: [
          SizedBox(
              width: 40,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ProfileCard(),
          Padding(
            padding: const EdgeInsets.all(15).copyWith(bottom: 0),
            child: Text(
              'Bài viết',
              style: ptBigTitle(),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              PostWidget(),
              PostWidget(),
              PostWidget(),
            ],
          )
        ]),
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
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14).copyWith(right: 20),
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
