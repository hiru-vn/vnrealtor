import 'package:vnrealtor/share/import.dart';

class SearchPostPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(SearchPostPage()));
  }

  @override
  _SearchPostPageState createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ptPrimaryColorLight(context),
        titleSpacing: 3,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
              color: HexColor('#f2f9fc'),
              borderRadius: BorderRadius.circular(25)),
          child: Row(children: [
            SizedBox(
              width: 15,
            ),
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                style: ptBody(),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm dự án, địa điểm',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 5),
                ),
              ),
            ),
          ]),
        ),
        actions: [
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
        bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: ptPrimaryColor(context),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.black87,
            unselectedLabelStyle:
                TextStyle(fontSize: 14.5, color: Colors.black54),
            labelStyle: TextStyle(
                fontSize: 14.5,
                color: Colors.black87,
                fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Bài viết'),
              Tab(text: 'Người dùng'),
              Tab(text: 'Ảnh/video'),
              Tab(text: 'Bản đồ'),
            ]),
      ),
      backgroundColor: ptBackgroundColor(context),
    );
  }
}
