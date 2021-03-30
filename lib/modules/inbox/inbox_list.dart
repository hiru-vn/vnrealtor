import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_model.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/people_widget.dart';
import 'package:datcao/share/function/dialog.dart';
import 'package:datcao/utils/formart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/navigator.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'import/app_bar.dart';
import 'import/color.dart';
import 'import/font.dart';
import 'import/page_builder.dart';
import 'import/skeleton.dart';
import 'inbox_bloc.dart';
import 'inbox_chat.dart';

class InboxList extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(InboxList()));
  }

  @override
  _InboxListState createState() => _InboxListState();
}

class _InboxListState extends State<InboxList>
    with SingleTickerProviderStateMixin {
  InboxBloc _inboxBloc;
  AuthBloc _authBloc;
  int tabIndex = 0;
  PageController _pageController = PageController();
  List<UserModel> friends = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_inboxBloc == null || _authBloc == null) {
      _inboxBloc = Provider.of<InboxBloc>(context);
      _authBloc = Provider.of<AuthBloc>(context);
      if (mounted) init();
      UserBloc.instance
          .getListUserIn(_authBloc.userModel.friendIds)
          .then((res) {
        if (res.isSuccess) {
          setState(() {
            friends = res.data;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  init() async {
    try {
      _inboxBloc.init();
    } catch (e) {}
  }

  reload() async {
    final res = await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
    if (mounted)
      setState(() {
        _inboxBloc.groupInboxList = res;
      });
  }

  Widget _getChatGroupAvatar(FbInboxGroupModel group) {
    if (group.userAvatars == null) return SizedBox.shrink();
    List listAvatar = group.userAvatars.map((e) {
      if (e != AuthBloc.instance.userModel.avatar) return e;
    }).toList();
    listAvatar.remove(null);
    if (listAvatar.length > 0) {
      return CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        backgroundImage: listAvatar[0] != null
            ? CachedNetworkImageProvider(listAvatar[0])
            : AssetImage('assets/image/default_avatar.png'),
      );
    } else
      return CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/image/default_avatar.png'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Hộp thư',
        automaticallyImplyLeading: true,
        elevation: 3,
        bgColor: Colors.white,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.5),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tabIndex = 0;
                            _pageController.animateToPage(0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.decelerate);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 25,
                          decoration: BoxDecoration(
                            color: tabIndex == 0
                                ? ptPrimaryColor(context)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              'Tin nhắn',
                              style: ptTitle().copyWith(
                                  color: tabIndex == 0
                                      ? Colors.white
                                      : Colors.black54),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tabIndex = 1;
                            _pageController.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.decelerate);
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3 - 25,
                          decoration: BoxDecoration(
                            color: tabIndex == 1
                                ? ptPrimaryColor(context)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Text(
                              'Bạn bè',
                              style: ptTitle().copyWith(
                                  color: tabIndex == 1
                                      ? Colors.white
                                      : Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _inboxBloc.groupInboxList != null
                    ? _inboxBloc.groupInboxList.length == 0
                        ? EmptyWidget(
                            // assetImg: 'assets/image/no_message.dart',
                            title: 'Bạn chưa có tin nhắn nào.',
                          )
                        : RefreshIndicator(
                            color: ptPrimaryColor(context),
                            onRefresh: () async {
                              await _inboxBloc
                                  .getList20InboxGroup(_authBloc.userModel.id);
                              return;
                            },
                            child: _inboxBloc.groupInboxList.length != 0
                                ? ListView.separated(
                                    itemCount: _inboxBloc.groupInboxList.length,
                                    itemBuilder: (context, index) {
                                      final group =
                                          _inboxBloc.groupInboxList[index];
                                      final String nameGroup = group.users
                                          .where((element) =>
                                              element.id !=
                                              _authBloc.userModel.id)
                                          .toList()
                                          .map((e) => e.name)
                                          .join(', ');
                                      return ListTile(
                                        onTap: () {
                                          InboxChat.navigate(group, nameGroup)
                                              .then((value) => reload());
                                        },
                                        tileColor: group.readers.contains(
                                                _authBloc.userModel.id)
                                            ? Colors.white
                                            : ptBackgroundColor(context),
                                        leading: _getChatGroupAvatar(group),
                                        title: Text(
                                          nameGroup,
                                          style: ptTitle().copyWith(
                                              color: Colors.black87,
                                              fontSize: 14.5),
                                        ),
                                        subtitle: Text(
                                          // (group.lastUser ==  _authBloc.userModel.name? 'Bạn: ':'Tin nhắn mới: ')+
                                          group.lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: ptSmall().copyWith(
                                              fontWeight: _inboxBloc
                                                      .groupInboxList[index]
                                                      .readers
                                                      .contains(_authBloc
                                                          .userModel.id)
                                                  ? FontWeight.w400
                                                  : FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: group.readers.contains(
                                                      _authBloc.userModel.id)
                                                  ? 12.3
                                                  : 12.8),
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Spacer(),
                                            Text(
                                              Formart.timeByDayViShort(
                                                  DateTime.tryParse(
                                                      group.time)),
                                              style: ptSmall().copyWith(
                                                  fontWeight: _inboxBloc
                                                          .groupInboxList[index]
                                                          .readers
                                                          .contains(_authBloc
                                                              .userModel.id)
                                                      ? FontWeight.w400
                                                      : FontWeight.w500,
                                                  color: Colors.black54,
                                                  fontSize: group.readers
                                                          .contains(_authBloc
                                                              .userModel.id)
                                                      ? 12.3
                                                      : 12.8),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      height: 1,
                                    ),
                                  )
                                : EmptyWidget(
                                    // assetImg: 'assets/image/no_message.png',
                                    title: 'Bạn chưa có tin nhắn nào',
                                    content:
                                        'Bạn có thể nhắn tin với người khác khi cả 2 là bạn bè.',
                                  ),
                          )
                    : ListSkeleton(),
                ListView.separated(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final user = friends[index];
                    return GestureDetector(
                        onTap: () async {
                          showSimpleLoadingDialog(context);
                          await InboxBloc.instance.navigateToChatWith(user.name,
                              user.avatar, DateTime.now(), user.avatar, [
                            AuthBloc.instance.userModel.id,
                            user.id,
                          ], [
                            AuthBloc.instance.userModel.avatar,
                            user.avatar,
                          ]);
                          navigatorKey.currentState.maybePop();
                        },
                        child:
                            AbsorbPointer(child: PeopleWidget(friends[index])));
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
