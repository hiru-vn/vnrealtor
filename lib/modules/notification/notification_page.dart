import 'package:vnrealtor/share/import.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
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
      appBar: AppBar1(
        title: 'Thông báo',
        actions: [
          Center(child: AnimatedSearchBar()),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  indicatorColor: ptPrimaryColor(context),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black87,
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14, color: Colors.black54),
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                  tabs: [
                    SizedBox(
                      height: 40,
                      width: deviceWidth(context) / 2 - 45,
                      child: Tab(
                        text: 'Thông báo mới (3)',
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: deviceWidth(context) / 2 - 45,
                      child: Tab(text: 'Lời mời kết bạn (2)'),
                    ),
                  ]),
            ),
            ListTile(
              tileColor: ptBackgroundColor(context),
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/image/avatar.jpg'),
              ),
              title: Text(
                'Cuti pit đã chia sẻ bài viết của bạn',
                style: ptBody(),
              ),
              subtitle: Text(
                '1 tháng trước',
                style: ptTiny(),
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              tileColor: ptBackgroundColor(context),
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/image/avatar.jpeg'),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hung Nguyen đã comment:',
                    style: ptBody(),
                  ),
                  Text(
                    '"Dự án này còn hoạt động không bạn?. Mình..."',
                    style: ptSmall(),
                  ),
                ],
              ),
              subtitle: Text(
                '1 tháng trước',
                style: ptTiny(),
              ),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              tileColor: ptBackgroundColor(context),
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/image/avatar.jpeg'),
              ),
              title: Text(
                'Hung Nguyen đã thích bài viết của bạn',
                style: ptBody(),
              ),
              subtitle: Text(
                '1 tháng trước',
                style: ptTiny(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
