import 'package:datcao/modules/bloc/invite_bloc.dart';
import 'package:datcao/modules/connection/widgets/user_connect_item.dart';
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
      _inviteBloc.getInvitesReceived();
      _inviteBloc.getInvitesSent();
    }
    super.didChangeDependencies();
  }

  void _deleteInvite() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "Xoá lời mời",
          ),
        ),
        content: Text(
            "Nếu bạn thu hồi lời mời, bạn sẽ không được gửi lời mời cho người dùng này trong 1 ngày nữa "),
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
            onPressed: () {
              showWaitingDialog(context);

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
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
                        child: LoadMoreScrollView(
                            scrollController:
                                _inviteBloc.invitesReceivedScrollController,
                            onLoadMore: () {
                              //  _inviteBloc.loadMoreNewFeedGroup();
                            },
                            list: RefreshIndicator(
                              color: ptPrimaryColor(context),
                              onRefresh: () async {
                                audioCache.play('tab3.mp3');
                                _inviteBloc.getInvitesReceived();
                                return true;
                              },
                              child: (!_inviteBloc.isLoadingInvitesReceived &&
                                      _inviteBloc.invitesReceived.isEmpty)
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
                                      controller: _inviteBloc
                                          .invitesReceivedScrollController,
                                      itemCount: _inviteBloc
                                              .isLoadingInvitesReceived
                                          ? 10
                                          : _inviteBloc.invitesReceived.length,
                                      itemBuilder: (context, index) =>
                                          _inviteBloc.isLoadingInvitesReceived
                                              ? UserConnectItemLoading()
                                              : UserConnectItem(
                                                  user: _inviteBloc
                                                      .invitesReceived[index],
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        print("");
                                                      },
                                                      child: Text(
                                                        "Xoá",
                                                        style: roboto(context)
                                                            .copyWith(
                                                                color:
                                                                    ptSecondaryColor(
                                                                        context)),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        print("");
                                                      },
                                                      child: Text(
                                                        "Chấp nhận",
                                                        style: roboto(context)
                                                            .copyWith(
                                                                color:
                                                                    ptSecondaryColor(
                                                                        context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                    ),
                            )),
                      );
                    } else
                      return Expanded(
                        child: LoadMoreScrollView(
                            scrollController:
                                _inviteBloc.invitesSentScrollController,
                            onLoadMore: () {
                              //  _inviteBloc.loadMoreNewFeedGroup();
                            },
                            list: RefreshIndicator(
                              color: ptPrimaryColor(context),
                              onRefresh: () async {
                                audioCache.play('tab3.mp3');
                                _inviteBloc.getInvitesSent();
                                return true;
                              },
                              child: (!_inviteBloc.isLoadingInvitesSent &&
                                      _inviteBloc.invitesSent.isEmpty)
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
                                      controller: _inviteBloc
                                          .invitesSentScrollController,
                                      itemCount:
                                          _inviteBloc.isLoadingInvitesSent
                                              ? 10
                                              : _inviteBloc.invitesSent.length,
                                      itemBuilder: (context, index) =>
                                          _inviteBloc.isLoadingInvitesSent
                                              ? UserConnectItemLoading()
                                              : UserConnectItem(
                                                  user: _inviteBloc
                                                      .invitesSent[index],
                                                  actions: [
                                                    TextButton(
                                                      onPressed: _deleteInvite,
                                                      child: Text(
                                                        "Thu hồi",
                                                        style: roboto(context)
                                                            .copyWith(
                                                                color:
                                                                    ptSecondaryColor(
                                                                        context)),
                                                      ),
                                                    )
                                                  ],
                                                )),
                            )),
                      );
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
