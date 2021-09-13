import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/create_group_page.dart';
import 'package:datcao/modules/group/my_group_page.dart';
import 'package:datcao/modules/group/suggest_group.dart';
import 'package:datcao/modules/group/widget/suggest_list_group.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:datcao/share/widget/load_more.dart';

class GroupConnectScreen extends StatefulWidget {
  const GroupConnectScreen({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(GroupConnectScreen()));
  }

  @override
  _GroupConnectScreenState createState() => _GroupConnectScreenState();
}

class _GroupConnectScreenState extends State<GroupConnectScreen> {
  GroupBloc _groupBloc;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      Future.delayed(Duration(seconds: 2), () => _groupBloc.init());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _groupBloc.groupScrollController = ScrollController();
    return Scaffold(
        appBar: SecondAppBar(
          title: 'Nhóm',
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: 30,
              ),
              onPressed: () {
                audioCache.play('tab3.mp3');
                CreateGroupPage.navigate();
              },
            )
          ],
        ),
        body: LoadMoreScrollView(
            scrollController: _groupBloc.groupScrollController,
            onLoadMore: () {
              _groupBloc.loadMoreNewFeedGroup();
            },
            list: RefreshIndicator(
                color: ptPrimaryColor(context),
                onRefresh: () async {
                  audioCache.play('tab3.mp3');
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
      color: ptPrimaryColor(context),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row(
          //   children: [
          //     SizedBox(width: 27),
          //     GestureDetector(
          //       onTap: () {
          //         audioCache.play('tab3.mp3');
          //         CreateGroupPage.navigate();
          //       },
          //       child: Container(
          //         height: 33,
          //         width: 33,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: ptSecondaryColor(context),
          //         ),
          //         child: Center(
          //           child: Icon(Icons.group_add_rounded),
          //         ),
          //       ),
          //     ),
          //     GestureDetector(
          //         onTap: () {
          //           audioCache.play('tab3.mp3');
          //           CreateGroupPage.navigate();
          //         },
          //         child: SizedBox(width: 15)),
          //     GestureDetector(
          //         onTap: () {
          //           audioCache.play('tab3.mp3');
          //           CreateGroupPage.navigate();
          //         },
          //         child: Text('Tạo nhóm mới', style: ptTitle())),
          //   ],
          // ),
          SizedBox(height: 15),
          Container(
            height: 35,
            color: ptPrimaryColor(context),
            width: deviceWidth(context),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton('Nhóm của bạn',
                      Image.asset("assets/image/icon_group.png", width: 20),
                      () {
                    MyGroupPage.navigate();
                  }),
                  _buildButton('Gợi ý',
                      Image.asset("assets/image/icon_goiy.png", width: 20), () {
                    SuggestGroup.navigate();
                  }),
                  // SizedBox(width: 25),
                  // _buildButton('Lời mời',
                  //     Image.asset("assets/image/icon_group.png", width: 20),
                  //     () {
                  //   InviteGroup.navigate();
                  // },
                  //     counter: NotificationBloc.instance.notifications
                  //         .where((e) => e.type == 'INVITE_GROUP')
                  //         .toList()
                  //         .length),
                  // SizedBox(width: 12),
                ]),
          ),
          if (_groupBloc.suggestGroup != null &&
              _groupBloc.suggestGroup.length > 0) ...[
            SizedBox(height: 15),
            SuggestListGroup()
          ]
        ],
      ),
    );
  }

  Widget _buildButton(String text, Widget icon, Function onTap, {int counter}) {
    return GestureDetector(
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: ptPrimaryColor(context),
          border: Border.all(width: 1, color: Theme.of(context).dividerColor),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Text(text, style: ptTitle().copyWith(fontSize: 13.5)),
            if (counter != null) ...[
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.red),
                child: Text(
                  counter.toString(),
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
