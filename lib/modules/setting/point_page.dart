import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/share/import.dart';

class PointPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(PointPage()));
  }

  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2('Điểm tương tác của bạn'),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Responsive.widthMultiplier * 6),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.heightMultiplier * 4.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AuthBloc.instance.userModel.reputationScore
                                  .toString(),
                              style: ptHeadLine().copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'ĐIỂM',
                                style: ptBigTitle().copyWith(color: Colors.red),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/image/coin_big.png'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: deviceWidth(context) / 1.4,
                          child: Text(
                            'Điểm tương tác dùng để tăng số lượng bài đăng mà bạn có thể đăng trong ngày.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: TabBar(
            //         indicatorSize: TabBarIndicatorSize.label,
            //         indicatorWeight: 3,
            //         indicatorColor: ptPrimaryColor(context),
            //         indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            //         controller: _tabController,
            //         isScrollable: true,
            //         labelColor: Colors.black87,
            //         unselectedLabelStyle:
            //             TextStyle(fontSize: 15, color: Colors.black54),
            //         labelStyle: TextStyle(
            //             fontSize: 15,
            //             color: Colors.black87,
            //             fontWeight: FontWeight.bold),
            //         tabs: [
            //           SizedBox(
            //             height: 40,
            //             width: deviceWidth(context) / 2 - 45,
            //             child: Tab(
            //               text: 'Thông tin tích điểm',
            //             ),
            //           ),
            //           SizedBox(
            //             height: 40,
            //             width: deviceWidth(context) / 2 - 45,
            //             child: Tab(text: 'Lịch sử tích điểm'),
            //           ),
            //         ]),
            //   ),
            // ),
          ];
        },
        body: Container(
          // padding: EdgeInsets.only(top: 30),
          child: PointInfoWidget(),
          // TabBarView(
          //   controller: _tabController,
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     PointInfoWidget(),
          //     ListView(
          //       children: [],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}

class PointInfoWidget extends StatefulWidget {
  @override
  _PointInfoWidgetState createState() => _PointInfoWidgetState();
}

class _PointInfoWidgetState extends State<PointInfoWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int selectTab = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 3,
          child: Container(
            color: Colors.white,
            width: deviceWidth(context),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 50),
                    Image.asset('assets/image/milestone.png'),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/image/coin_iron.png'),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 5,
                        width: double.infinity,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 5,
                        width: double.infinity,
                        color: Colors.yellow,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          height: 5,
                          width: double.infinity,
                          color: Colors.orangeAccent),
                    ),
                    SizedBox(width: 5),
                    Image.asset('assets/image/coin_gold.png')
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Cấp độ hiện tại của bạn: Chuẩn",
                  style:
                      ptTitle().copyWith(color: Colors.black.withOpacity(0.7)),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              _buildOptionHeader('Chuẩn', 'assets/image/coin_iron.png', 0),
              _buildOptionHeader('Bạc', 'assets/image/coin_silver.png', 1),
              _buildOptionHeader('Vàng', 'assets/image/coin_gold.png', 2)
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        _buildOptionInfo(),
      ],
    );
  }

  Widget _buildOptionInfo() {
    if (selectTab == 0)
      return Container(
        height: 42.0 + 40.0,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200], width: 1.5),
                shape: BoxShape.circle,
              ),
              child: Center(child: Image.asset('assets/image/gift.png')),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Đăng 1 bài viết/ 1 ngày',
              style: ptBody(),
            ),
          ],
        ),
      );
    if (selectTab == 1)
      return Container(
        height: 42.0 + 40.0,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200], width: 1.5),
                shape: BoxShape.circle,
              ),
              child: Center(child: Image.asset('assets/image/gift.png')),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Đăng 2 bài viết/ 1 ngày',
              style: ptBody(),
            ),
          ],
        ),
      );
    if (selectTab == 2)
      return Container(
        height: 42.0 + 40.0,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200], width: 1.5),
                shape: BoxShape.circle,
              ),
              child: Center(child: Image.asset('assets/image/gift.png')),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Đăng 5 bài viết/ 1 ngày',
              style: ptBody(),
            ),
          ],
        ),
      );
    return SizedBox.shrink();
  }

  Widget _buildOptionHeader(String title, String asset, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {audioCache.play('tab3.mp3');
          setState(() {
            selectTab = index;
          });
        },
        child: Container(
          color: selectTab == index ? Colors.white : Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(asset),
              SizedBox(height: 5),
              Text(
                title,
                style: ptTitle(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
