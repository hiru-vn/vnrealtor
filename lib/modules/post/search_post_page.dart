import 'package:vnrealtor/modules/post/post_map.dart';
import 'package:vnrealtor/modules/post/post_search_widget.dart';
import 'package:vnrealtor/modules/post/search_people_widget.dart';
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
    _tabController = TabController(length: 3, vsync: this);
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
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                if (_tabController.index == 1 || _tabController.index == 3)
                  return;
                pickList(context,
                    title: 'Sắp xếp kết quả theo',
                    onPicked: (value) {},
                    options: [
                      'Mới nhất xếp trước',
                      'Cũ nhất xếp trước',
                      'Địa điểm gần tôi nhất'
                    ],
                    closeText: 'Xong');
              }),
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
              SizedBox(height: 36, child: Tab(text: 'Bài viết')),
              SizedBox(height: 36, child: Tab(text: 'Người dùng')),
              //Tab(text: 'Ảnh/video'),
              SizedBox(height: 36, child: Tab(text: 'Bản đồ')),
            ]),
      ),
      backgroundColor: ptBackgroundColor(context),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          ListView(
            children: [
              PostSearchWidget(),
              PostSearchWidget(),
            ],
          ),
          ListView(
            padding: EdgeInsets.only(top: 5),
            children: [
              PeopleWidget(),
              PeopleWidget(),
              PeopleWidget(),
              PeopleWidget(),
            ],
          ),
          PostMap(),
        ],
      ),
    );
  }
}
