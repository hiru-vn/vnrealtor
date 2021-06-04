import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/create_group_page.dart';
import 'package:datcao/modules/group/invite_group.dart';
import 'package:datcao/modules/group/my_group_page.dart';
import 'package:datcao/modules/group/suggest_group.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:datcao/share/widget/load_more.dart';
import './widget.dart/suggest_list_group.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupBloc _groupBloc;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc.init();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _groupBloc.groupScrollController = ScrollController();
    return Scaffold(
        appBar: AppBar1(
          bgColor: ptSecondaryColor(context),
          title: 'Nhóm',
          textColor: ptPrimaryColor(context),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: LoadMoreScrollView(
            scrollController: _groupBloc.groupScrollController,
            onLoadMore: () {
              _groupBloc.loadMoreNewFeedGroup();
            },
            list: RefreshIndicator(
                color: ptPrimaryColor(context),
                onRefresh: () async {
                  _groupBloc.getNewFeedGroup(
                      filter:
                          GraphqlFilter(limit: 10, order: "{updatedAt: -1}"));
                  return true;
                },
                child: SingleChildScrollView(
                  controller: GroupBloc.instance.groupScrollController,
                  child: Column(
                    children: [
                      _buildHeader(),
                      if (_groupBloc.isReloadFeed) PostSkeleton(),
                      _groupBloc.feed.length == 0
                          ? ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: deviceHeight(context) / 2),
                              child: EmptyWidget(
                                assetImg: 'assets/image/no_post.png',
                                title: 'Không có bài đăng nào',
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _groupBloc.feed.length,
                              itemBuilder: (context, index) {
                                final item = _groupBloc.feed[index];
                                return PostWidget(item);
                              },
                            ),
                      if (_groupBloc.isLoadMoreFeed &&
                          !_groupBloc.isEndFeed &&
                          _groupBloc.feed.length > 9)
                        PostSkeleton(
                          count: 1,
                        ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ))));
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 27),
              GestureDetector(
                onTap: () {
                  CreateGroupPage.navigate();
                },
                child: Container(
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ptSecondaryColor(context),
                  ),
                  child: Center(
                    child: Icon(Icons.group_add_rounded),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    CreateGroupPage.navigate();
                  },
                  child: SizedBox(width: 15)),
              GestureDetector(
                  onTap: () {
                    CreateGroupPage.navigate();
                  },
                  child: Text('Tạo nhóm mới', style: ptTitle())),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 35,
            width: deviceWidth(context),
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 12),
                  _buildButton('Nhóm của bạn', Icons.group_outlined, () {
                    MyGroupPage.navigate();
                  }),
                  SizedBox(width: 25),
                  _buildButton('Gợi ý', Icons.flag_outlined, () {
                    SuggestGroup.navigate();
                  }),
                  SizedBox(width: 25),
                  _buildButton('Lời mời', Icons.mail_outline_rounded, () {
                    // InviteGroup.navigate();
                    showToast('Chưa phát triển', context);
                  }, counter: 4),
                  SizedBox(width: 12),
                ]),
          ),
          if (_groupBloc.suggestGroup != null &&
              _groupBloc.suggestGroup.length > 0) ...[
            SizedBox(height: 15),
            SuggestListGroup(
              groups: _groupBloc.suggestGroup,
            )
          ]
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Function onTap,
      {int counter}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: ptSecondaryColor(context),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 27),
            SizedBox(width: 10),
            Text(text, style: ptTitle().copyWith(fontSize: 13.5)),
            if (counter != null) ...[
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.red),
                child: Text(
                  '9',
                  style: ptTiny().copyWith(color: Colors.white),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
