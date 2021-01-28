import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/post/post_map.dart';
import 'package:vnrealtor/modules/post/people_widget.dart';
import 'package:vnrealtor/modules/post/post_widget.dart';
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
  UserBloc _userBloc;
  PostBloc _postBloc;
  TabController _tabController;
  List<UserModel> users = [];
  List<PostModel> posts = [];
  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
      _postBloc = Provider.of<PostBloc>(context);
    }
  }

  void _search(String text) async {
    if (text.trim() == '') return;
    setState(() {
      isLoading = true;
    });
    await Future.wait([_searchUser(text), _searchPost(text)]);
    setState(() {
      isLoading = false;
    });
  }

  Future _searchUser(String text) async {
    final res =
        await _userBloc.getListUser(filter: GraphqlFilter(search: text));
    if (res.isSuccess) {
      setState(() {
        users = res.data;
      });
    } else {
      showToast('Có lỗi xảy ra trong quá trình tìm kiếm', context);
      setState(() {
        users = [];
      });
    }
  }

  Future _searchPost(String text) async {
    final res = await _postBloc.getNewFeed(filter: GraphqlFilter(search: text));
    if (res.isSuccess) {
      setState(() {
        posts = res.data;
      });
    } else {
      showToast('Có lỗi xảy ra trong quá trình tìm kiếm', context);
      setState(() {
        posts = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    onSubmitted: _search,
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
                          PickListItem(0, 'Mới nhất xếp trước'),
                          PickListItem(1, 'Cũ nhất xếp trước'),
                          PickListItem(2, 'Địa điểm gần tôi nhất')
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
              ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostWidget(posts[index]);
                  }),
              ListView.builder(
                padding: EdgeInsets.only(top: 5),
                itemCount: users.length,
                itemBuilder: (context, index) => PeopleWidget(users[index]),
              ),
              PostMap(),
            ],
          ),
        ),
        if (isLoading) SearchingWidget(),
      ],
    );
  }
}
