import 'package:datcao/modules/bloc/invite_bloc.dart';
import 'package:datcao/modules/connection/widgets/invite_items.dart';
import 'package:datcao/modules/connection/widgets/suggest_items.dart';
import 'package:datcao/modules/connection/widgets/user_connect_item.dart';
import 'package:datcao/modules/model/invite.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/load_more.dart';

class InvitesListScreen extends StatefulWidget {
  const InvitesListScreen({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(InvitesListScreen()));
  }

  @override
  _InvitesListScreenState createState() => _InvitesListScreenState();
}

class _InvitesListScreenState extends State<InvitesListScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentTab = 0;
  InviteBloc _inviteBloc;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_inviteBloc == null) {
      _inviteBloc = Provider.of<InviteBloc>(context);
      _inviteBloc.getInvitesUserReceived();
      _inviteBloc.getInvitesUserSent();
      _inviteBloc.getInvitesPageSent();
      _inviteBloc.getInvitesPageReceived();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
          child: Scaffold(
        appBar: SecondAppBar(
          title: "Lời mời",
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                color: ptPrimaryColor(context),
                child: TabBar(
                  tabs: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Lời mời nhận được"),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Lời mời đã gửi"))
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (value) {
                    setState(() {
                      currentTab = value;
                    });
                  },
                  indicatorWeight: 3,
                  indicatorColor: ptSecondColor(),
                  labelPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: _tabController,
                  labelColor: ptSecondColor(),
                  unselectedLabelColor: Theme.of(context).accentColor,
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14, color: Colors.black12),
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedBuilder(
                  animation: _tabController.animation,
                  builder: (ctx, child) {
                    if (_tabController.index == 0) {
                      return Expanded(
                          child: ListInvitesUserReceived(
                        inviteBloc: _inviteBloc,
                      ));
                    } else
                      return Expanded(
                          child: ListInvitesUserSent(
                        inviteBloc: _inviteBloc,
                      ));
                  }),
            ],
          ),
        ),
      )),
    );
  }
}

class ListInvitesUserReceived extends StatefulWidget {
  final InviteBloc inviteBloc;
  const ListInvitesUserReceived({Key key, this.inviteBloc}) : super(key: key);

  @override
  _ListInvitesUserReceivedState createState() =>
      _ListInvitesUserReceivedState();
}

class _ListInvitesUserReceivedState extends State<ListInvitesUserReceived> {
  int tabIndex = 0;
  PageController _pageController = PageController();

  void _deleteInvite({String id, bool isSent = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Xoá lời mời",
          ),
        ),
        content: Text(
            "Nếu bạn xoá lời mời, bạn sẽ không được gửi lời mời cho người dùng này trong 1 ngày nữa "),
        actions: [
          TextButton(
            child: Text(
              "Huỷ",
              style: ptBody().copyWith(color: ptSecondaryColor(context)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              "Xoá",
              style: ptBody().copyWith(color: ptSecondaryColor(context)),
            ),
            onPressed: () async {
              showWaitingDialog(context);
              await widget.inviteBloc.deleteInviteSent(id: id, isSent: isSent);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _acceptInviteFollow({String id, UserModel user}) async {
    showWaitingDialog(context);
    await widget.inviteBloc.acceptInviteFollow(id: id);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          "Kết bạn thành công",
        )),
        content: Text("Bạn và ${user.name} đã trở thành bạn bè"),
        actions: [
          TextButton(
            child: Text(
              "Xong",
              style: ptBody().copyWith(color: ptSecondaryColor(context)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 0;
                      _pageController.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 0
                          ? ptSecondColor()
                          : ptPrimaryColorLight(context),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Người dùng',
                        style: ptTitle().copyWith(
                            color: tabIndex == 0
                                ? Colors.white
                                : ptSecondaryColor(context)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 1;
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 1
                          ? ptSecondColor()
                          : ptPrimaryColorLight(context),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Trang',
                        style: ptTitle().copyWith(
                            color: tabIndex == 1
                                ? Colors.white
                                : ptSecondaryColor(context)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 2;
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 2
                          ? ptSecondColor()
                          : ptPrimaryColorLight(context),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Nhóm',
                        style: ptTitle().copyWith(
                            color: tabIndex == 2
                                ? Colors.white
                                : ptSecondaryColor(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                buildInvitesUserReceived(context),
                buildInvitesPageReceived(context),
                buildInvitesGroupReceived(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LoadMoreScrollView buildInvitesUserReceived(BuildContext context) {
    return LoadMoreScrollView(
        scrollController: widget.inviteBloc.invitesUserReceivedScrollController,
        onLoadMore: () {
          //  widget.inviteBloc.loadMoreNewFeedGroup();
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            widget.inviteBloc.getInvitesUserReceived();
            return true;
          },
          child: (!widget.inviteBloc.isLoadingInvitesUserReceived &&
                  widget.inviteBloc.invitesUserReceived.isEmpty)
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/image/invite_image.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Không có lời mời nào!",
                          style: ptBigBody(),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller:
                      widget.inviteBloc.invitesUserReceivedScrollController,
                  itemCount: widget.inviteBloc.isLoadingInvitesUserReceived
                      ? 10
                      : widget.inviteBloc.invitesUserReceived.length,
                  itemBuilder: (context, index) => widget
                          .inviteBloc.isLoadingInvitesUserReceived
                      ? UserConnectItemLoading()
                      : UserConnectItem(
                          user: widget
                              .inviteBloc.invitesUserReceived[index].fromUser,
                          actions: [
                            TextButton(
                              onPressed: () => _deleteInvite(
                                  id: widget
                                      .inviteBloc.invitesUserReceived[index].id,
                                  isSent: false),
                              child: Text(
                                "Xoá",
                                style: roboto(context)
                                    .copyWith(color: ptSecondaryColor(context)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _acceptInviteFollow(
                                    id: widget.inviteBloc
                                        .invitesUserReceived[index].id,
                                    user: widget.inviteBloc
                                        .invitesUserReceived[index].fromUser);
                              },
                              child: Text(
                                "Chấp nhận",
                                style: roboto(context)
                                    .copyWith(color: ptSecondaryColor(context)),
                              ),
                            ),
                          ],
                        ),
                ),
        ));
  }

  LoadMoreScrollView buildInvitesPageReceived(BuildContext context) {
    return LoadMoreScrollView(
        scrollController: widget.inviteBloc.invitesPageReceivedScrollController,
        onLoadMore: () {
          //  widget.inviteBloc.loadMoreNewFeedGroup();
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            widget.inviteBloc.getInvitesUserReceived();
            return true;
          },
          child: (!widget.inviteBloc.isLoadingInvitesPageReceived &&
                  widget.inviteBloc.invitesPageReceived.isEmpty)
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/image/invite_image.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Không có lời mời nào!",
                          style: ptBigBody(),
                        )
                      ],
                    ),
                  ),
                )
              : StaggeredGridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  controller:
                      widget.inviteBloc.invitesPageReceivedScrollController,
                  crossAxisCount: 2,
                  staggeredTiles: widget.inviteBloc.invitesPageReceived
                      .map((_) => StaggeredTile.fit(1))
                      .toList(),
                  children: List.generate(
                      widget.inviteBloc.isLoadingInvitesPageReceived
                          ? 6
                          : widget.inviteBloc.invitesPageReceived.length,
                      (index) {
                    final InvitePageModel invite =
                        widget.inviteBloc.invitesPageReceived[index];
                    return widget.inviteBloc.isLoadingInvitesPageReceived
                        ? SuggestItemLoading()
                        : PageInviteReceivedItem(
                            page: invite.page,
                            user: invite.fromUser,
                          );
                  }),
                ),
        ));
  }

  LoadMoreScrollView buildInvitesGroupReceived(BuildContext context) {
    return LoadMoreScrollView(
        scrollController:
            widget.inviteBloc.invitesGroupReceivedScrollController,
        onLoadMore: () {
          //  widget.inviteBloc.loadMoreNewFeedGroup();
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            widget.inviteBloc.getInvitesUserReceived();
            return true;
          },
          child: (!widget.inviteBloc.isLoadingInvitesGroupReceived &&
                  widget.inviteBloc.invitesGroupReceived.isEmpty)
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/image/invite_image.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Không có lời mời nào!",
                          style: ptBigBody(),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller:
                      widget.inviteBloc.invitesGroupReceivedScrollController,
                  itemCount: widget.inviteBloc.isLoadingInvitesGroupReceived
                      ? 10
                      : widget.inviteBloc.invitesGroupReceived.length,
                  itemBuilder: (context, index) => widget
                          .inviteBloc.isLoadingInvitesGroupReceived
                      ? UserConnectItemLoading()
                      : UserConnectItem(
                          user: widget
                              .inviteBloc.invitesGroupReceived[index].fromUser,
                          actions: [
                            TextButton(
                              onPressed: () => _deleteInvite(
                                  id: widget.inviteBloc
                                      .invitesGroupReceived[index].id,
                                  isSent: false),
                              child: Text(
                                "Xoá",
                                style: roboto(context)
                                    .copyWith(color: ptSecondaryColor(context)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _acceptInviteFollow(
                                    id: widget.inviteBloc
                                        .invitesGroupReceived[index].id,
                                    user: widget.inviteBloc
                                        .invitesGroupReceived[index].fromUser);
                              },
                              child: Text(
                                "Chấp nhận",
                                style: roboto(context)
                                    .copyWith(color: ptSecondaryColor(context)),
                              ),
                            ),
                          ],
                        ),
                ),
        ));
  }
}

class ListInvitesUserSent extends StatefulWidget {
  final InviteBloc inviteBloc;
  const ListInvitesUserSent({Key key, this.inviteBloc}) : super(key: key);

  @override
  _ListInvitesUserSentState createState() => _ListInvitesUserSentState();
}

class _ListInvitesUserSentState extends State<ListInvitesUserSent> {
  int tabIndex = 0;
  PageController _pageController = PageController();
  void _deleteInvite({String id, bool isSent = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Xoá lời mời",
          ),
        ),
        content: Text(
            "Nếu bạn xoá lời mời, bạn sẽ không được gửi lời mời cho người dùng này trong 1 ngày nữa "),
        actions: [
          TextButton(
            child: Text(
              "Huỷ",
              style: ptBody().copyWith(color: ptSecondaryColor(context)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              "Xoá",
              style: ptBody().copyWith(color: ptSecondaryColor(context)),
            ),
            onPressed: () async {
              showWaitingDialog(context);
              await widget.inviteBloc.deleteInviteSent(id: id, isSent: isSent);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    tabIndex = 0;
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 20,
                  decoration: BoxDecoration(
                    color: tabIndex == 0
                        ? ptSecondColor()
                        : ptPrimaryColorLight(context),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      'Người dùng',
                      style: ptTitle().copyWith(
                          color: tabIndex == 0
                              ? Colors.white
                              : ptSecondaryColor(context)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    tabIndex = 1;
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 20,
                  decoration: BoxDecoration(
                    color: tabIndex == 1
                        ? ptSecondColor()
                        : ptPrimaryColorLight(context),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      'Trang',
                      style: ptTitle().copyWith(
                          color: tabIndex == 1
                              ? Colors.white
                              : ptSecondaryColor(context)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    tabIndex = 2;
                    _pageController.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 20,
                  decoration: BoxDecoration(
                    color: tabIndex == 2
                        ? ptSecondColor()
                        : ptPrimaryColorLight(context),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      'Nhóm',
                      style: ptTitle().copyWith(
                          color: tabIndex == 2
                              ? Colors.white
                              : ptSecondaryColor(context)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              buildInvitesUserSent(context),
              buildInvitesPageSent(context),
              buildInvitesGroupSent(context),
            ],
          ),
        ),
      ],
    );
  }

  LoadMoreScrollView buildInvitesUserSent(BuildContext context) {
    return LoadMoreScrollView(
        scrollController: widget.inviteBloc.invitesUserSentScrollController,
        onLoadMore: () {
          //  widget.inviteBloc.loadMoreNewFeedGroup();
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            widget.inviteBloc.getInvitesUserSent();
            return true;
          },
          child: (!widget.inviteBloc.isLoadingInvitesUserSent &&
                  widget.inviteBloc.invitesUserSent.isEmpty)
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/image/invite_image.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Không có lời mời nào!",
                          style: ptBigBody(),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: widget.inviteBloc.invitesUserSentScrollController,
                  itemCount: widget.inviteBloc.isLoadingInvitesUserSent
                      ? 10
                      : widget.inviteBloc.invitesUserSent.length,
                  itemBuilder: (context, index) => widget
                          .inviteBloc.isLoadingInvitesUserSent
                      ? UserConnectItemLoading()
                      : UserConnectItem(
                          user: widget.inviteBloc.invitesUserSent[index].toUser,
                          actions: [
                            TextButton(
                              onPressed: () => _deleteInvite(
                                  id: widget
                                      .inviteBloc.invitesUserSent[index].id,
                                  isSent: true),
                              child: Text(
                                "Thu hồi",
                                style: roboto(context)
                                    .copyWith(color: ptSecondaryColor(context)),
                              ),
                            )
                          ],
                        )),
        ));
  }

  LoadMoreScrollView buildInvitesPageSent(BuildContext context) {
    return LoadMoreScrollView(
      scrollController: widget.inviteBloc.invitesPageSentScrollController,
      onLoadMore: () {
        //  widget.inviteBloc.loadMoreNewFeedGroup();
      },
      list: RefreshIndicator(
        color: ptPrimaryColor(context),
        onRefresh: () async {
          audioCache.play('tab3.mp3');
          widget.inviteBloc.getInvitesUserSent();
          return true;
        },
        child: (!widget.inviteBloc.isLoadingInvitesPageSent &&
                widget.inviteBloc.invitesPageSent.isEmpty)
            ? Center(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/image/invite_image.png",
                        width: 200,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Không có lời mời nào!",
                        style: ptBigBody(),
                      )
                    ],
                  ),
                ),
              )
            : ListView.builder(
                controller: widget.inviteBloc.invitesPageSentScrollController,
                itemCount: widget.inviteBloc.isLoadingInvitesPageSent
                    ? 10
                    : widget.inviteBloc.invitesPageSent.length,
                itemBuilder: (context, index) => widget
                        .inviteBloc.isLoadingInvitesPageSent
                    ? UserConnectItemLoading()
                    : PageInviteSentItem(
                        actions: [
                          TextButton(
                            onPressed: null,
                            child: Text(
                              "Thu hồi",
                              style: roboto(context)
                                  .copyWith(color: ptSecondaryColor(context)),
                            ),
                          )
                        ],
                        page: widget.inviteBloc.invitesPageSent[index].page,
                        user: widget.inviteBloc.invitesPageSent[index].toUser,
                      ),
              ),
      ),
    );
  }

  LoadMoreScrollView buildInvitesGroupSent(BuildContext context) {
    return LoadMoreScrollView(
        scrollController: widget.inviteBloc.invitesGroupSentScrollController,
        onLoadMore: () {
          //  widget.inviteBloc.loadMoreNewFeedGroup();
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            widget.inviteBloc.getInvitesUserSent();
            return true;
          },
          child: (!widget.inviteBloc.isLoadingInvitesGroupSent &&
                  widget.inviteBloc.invitesGroupSent.isEmpty)
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/image/invite_image.png",
                          width: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Không có lời mời nào!",
                          style: ptBigBody(),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller:
                      widget.inviteBloc.invitesGroupSentScrollController,
                  itemCount: widget.inviteBloc.isLoadingInvitesGroupSent
                      ? 10
                      : widget.inviteBloc.invitesGroupSent.length,
                  itemBuilder: (context, index) =>
                      widget.inviteBloc.isLoadingInvitesGroupSent
                          ? UserConnectItemLoading()
                          : UserConnectItem(
                              user: widget
                                  .inviteBloc.invitesGroupSent[index].fromUser,
                              actions: [
                                TextButton(
                                  onPressed: () => _deleteInvite(
                                      id: widget.inviteBloc
                                          .invitesGroupSent[index].id,
                                      isSent: false),
                                  child: Text(
                                    "Thu hồi",
                                    style: roboto(context).copyWith(
                                        color: ptSecondaryColor(context)),
                                  ),
                                ),
                              ],
                            ),
                ),
        ));
  }
}
