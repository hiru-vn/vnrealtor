import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/import/spin_loader.dart';
import 'package:datcao/modules/inbox/inbox_model.dart';
import 'package:datcao/modules/inbox/inbox_setting.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/post/people_widget.dart';
import 'package:datcao/share/function/dialog.dart';
import 'package:datcao/share/function/show_toast.dart';
import 'package:datcao/share/widget/animation_search.dart';
import 'package:datcao/share/widget/spacing_box.dart';
import 'package:datcao/utils/formart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/navigator.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'add_group.dart';
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
  List<UserModel> _friends = [];
  TextEditingController _searchC = TextEditingController();
  bool isSearching = false;

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
            _friends = res.data;
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
    if (group.pageName != null && group.pageId != null) {
      return CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        backgroundImage: group.image != null
            ? CachedNetworkImageProvider(group.image ?? '')
            : AssetImage('assets/image/default_avatar.png'),
      );
    }
    if (listAvatar.length > 1) {
      return CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        backgroundImage: listAvatar[1] != null
            ? CachedNetworkImageProvider(listAvatar[1])
            : AssetImage('assets/image/default_avatar.png'),
      );
    } else if (listAvatar.length > 0) {
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
    if (_inboxBloc.groupInboxList == null)
      return Scaffold(
        appBar: MyAppBar(
          icon: Icon(
            Icons.mail,
          ),
          title: 'Hộp thư',
          automaticallyImplyLeading: true,
          elevation: 3,
          bgColor: Colors.white,
        ),
        body: ListSkeleton(),
      );
    final friends = _friends
        .where((element) => element.name
            .toLowerCase()
            .contains(_searchC.text.trim().toLowerCase()))
        .toList();
    final groups = _inboxBloc.groupInboxList
        .where((element) =>
            !element.waitingBy.contains(AuthBloc.instance.userModel.id))
        .where((element) => element.users.any((element) =>
            element.id != AuthBloc.instance.userModel.id &&
            element.name
                .toLowerCase()
                .contains(_searchC.text.trim().toLowerCase())))
        .toList();
    final waitingGroups = _inboxBloc.groupInboxList
        .where((element) =>
            element.waitingBy.contains(AuthBloc.instance.userModel.id))
        .where((element) => element.users.any((element) =>
            element.id != AuthBloc.instance.userModel.id &&
            element.name
                .toLowerCase()
                .contains(_searchC.text.trim().toLowerCase())))
        .toList();
    return Scaffold(
      appBar: MyAppBar(
        icon: Icon(
          Icons.mail,
        ),
        title: 'Hộp thư',
        automaticallyImplyLeading: true,
        elevation: 3,
        bgColor: Colors.white,
        actions: [
          Center(
            child: IconButton(
              splashColor: Colors.white,
              onPressed: () {
                AddGroup.navigate();
              },
              icon: Icon(Icons.group_add_rounded),
            ),
          ),
          Center(
              child: AnimatedSearchBar(
            onSearch: (val) {},
            onSubmit: (val) {
              // this is good for UX :))
              setState(() {
                isSearching = true;
              });
              Future.delayed(
                  Duration(milliseconds: 700),
                  () => setState(() {
                        isSearching = false;
                      }));
            },
            controller: _searchC,
          )),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 0 ? Colors.grey[400] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Tin nhắn',
                        style: ptTitle().copyWith(
                            color:
                                tabIndex == 0 ? Colors.white : Colors.black54),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 1 ? Colors.grey[400] : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Bạn bè',
                        style: ptTitle().copyWith(
                            color:
                                tabIndex == 1 ? Colors.white : Colors.black54),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabIndex = 2;
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.decelerate);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    decoration: BoxDecoration(
                      color: tabIndex == 2 ? Colors.grey[400] : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        'Đang chờ',
                        style: ptTitle().copyWith(
                            color:
                                tabIndex == 2 ? Colors.white : Colors.black54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isSearching
              ? Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: kLoadingSpinner,
                )
              : Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      _buildListInboxTab(groups),
                      _buildFriendsTab(friends),
                      _buildWaitingGroupTab(waitingGroups),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _buildListInboxTab(List<FbInboxGroupModel> groups) {
    if (_inboxBloc.groupInboxList == null) return ListSkeleton();
    return groups != null
        ? groups.length == 0
            ? EmptyWidget(
                // assetImg: 'assets/image/no_message.dart',
                title: _searchC.text.trim() == ''
                    ? 'Bạn chưa có tin nhắn nào.'
                    : 'Không tìm thấy người dùng',
              )
            : RefreshIndicator(
                color: ptPrimaryColor(context),
                onRefresh: () async {
                  await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
                  return;
                },
                child: groups.length != 0
                    ? ListView.separated(
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          String nameGroup = group.users
                              .where((element) =>
                                  element.id != _authBloc.userModel.id)
                              .toList()
                              .map((e) => e.name)
                              .join(', ');
                          if (group.pageName != null &&
                              group.pageId != null &&
                              !PagesBloc.instance.pageCreated
                                  .any((e) => e.id == group.pageId))
                            nameGroup = group.pageName;
                          return _buildChatTile(group, nameGroup);
                        },
                        separatorBuilder: (context, index) => Divider(
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
        : ListSkeleton();
  }

  _buildFriendsTab(List<UserModel> friends) {
    return ListView.separated(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final user = friends[index];
        return GestureDetector(
            onTap: () async {
              showWaitingDialog(context);
              await InboxBloc.instance.navigateToChatWith(context, user.name,
                  user.avatar, DateTime.now(), user.avatar, [
                AuthBloc.instance.userModel.id,
                user.id,
              ], [
                AuthBloc.instance.userModel.avatar,
                user.avatar,
              ]);
              navigatorKey.currentState.maybePop();
            },
            child: AbsorbPointer(child: PeopleWidget(friends[index])));
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 0,
      ),
    );
  }

  _buildWaitingGroupTab(List<FbInboxGroupModel> waitingGroups) {
    return waitingGroups != null
        ? waitingGroups.length == 0
            ? EmptyWidget(
                // assetImg: 'assets/image/no_message.dart',
                title: _searchC.text.trim() == ''
                    ? 'Không có tin nhắn chờ.'
                    : 'Không tìm thấy người dùng',
              )
            : RefreshIndicator(
                color: ptPrimaryColor(context),
                onRefresh: () async {
                  await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
                  return;
                },
                child: waitingGroups.length != 0
                    ? ListView.separated(
                        itemCount: waitingGroups.length,
                        itemBuilder: (context, index) {
                          final group = waitingGroups[index];
                          String nameGroup = group.users
                              .where((element) =>
                                  element.id != _authBloc.userModel.id)
                              .toList()
                              .map((e) => e.name)
                              .join(', ');
                          if (group.pageName != null && group.pageId != null)
                            nameGroup = group.pageName;

                          return _buildChatTile(group, nameGroup);
                        },
                        separatorBuilder: (context, index) => Divider(
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
        : ListSkeleton();
  }

  _buildChatTile(FbInboxGroupModel group, String nameGroup) {
    final GlobalKey _menuKey = new GlobalKey();
    final button = SizedBox(
        width: 0,
        height: 0,
        child: PopupMenuButton(
            padding: EdgeInsets.zero,
            child: SizedBox.shrink(),
            key: _menuKey,
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  if (!group.waitingBy.contains(AuthBloc.instance.userModel.id))
                    PopupMenuItem(
                      child: Text('Đưa vào tin nhắn chờ'),
                      value: 'Đưa vào tin nhắn chờ',
                    ),
                  if (!group.waitingBy.contains(AuthBloc.instance.userModel.id))
                    PopupMenuItem(
                      child: Text('Xoá trò chuyện'),
                      value: 'Xoá trò chuyện',
                    )
                ],
            onSelected: (val) {
              if (val == 'Đưa vào tin nhắn chờ') {
                _inboxBloc.setPendingGroup(group.id);
              }
              if (val == 'Xoá trò chuyện') {
                showToast('Chưa hỗ trợ', context);
              }
            }));
    return ListTile(
      onTap: () {
        InboxChat.navigate(group, nameGroup).then((value) => reload());
      },
      onLongPress: () {
        if (AuthBloc.instance.userModel == null) return;
        dynamic state = _menuKey.currentState;
        state.showButtonMenu();
      },
      tileColor: group.readers.contains(_authBloc.userModel.id)
          ? Colors.white
          : ptBackgroundColor(context),
      leading: _getChatGroupAvatar(group),
      title: Text(
        nameGroup,
        style: ptTitle().copyWith(color: Colors.black87, fontSize: 14.5),
      ),
      subtitle: Text(
        // (group.lastUser ==  _authBloc.userModel.name? 'Bạn: ':'Tin nhắn mới: ')+
        group.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ptSmall().copyWith(
            fontWeight: group.readers.contains(_authBloc.userModel.id)
                ? FontWeight.w400
                : FontWeight.w500,
            color: Colors.black87,
            fontSize:
                group.readers.contains(_authBloc.userModel.id) ? 12.3 : 12.8),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          button,
          Spacer(),
          Text(
            Formart.timeByDayViShort(DateTime.tryParse(group.time)),
            style: ptSmall().copyWith(
                fontWeight: group.readers.contains(_authBloc.userModel.id)
                    ? FontWeight.w400
                    : FontWeight.w500,
                color: Colors.black54,
                fontSize: group.readers.contains(_authBloc.userModel.id)
                    ? 12.3
                    : 12.8),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
