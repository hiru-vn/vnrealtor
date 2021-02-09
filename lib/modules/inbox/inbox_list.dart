import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/navigator.dart';
import 'package:vnrealtor/share/widget/empty_widget.dart';

import 'import/animated_search_bar.dart';
import 'import/app_bar.dart';
import 'import/color.dart';
import 'import/font.dart';
import 'import/formart.dart';
import 'import/page_builder.dart';
import 'import/spin_loader.dart';
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
    }
    super.didChangeDependencies();
  }

  init() async {
    try {
      await _inboxBloc.createUser(_authBloc.userModel.id,
          _authBloc.userModel.name, _authBloc.userModel.avatar);
      final res = await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
      setState(() {
        _inboxBloc.groupInboxList = res;
      });
    } catch (e) {}
  }

  reload() async {
    final res = await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
    setState(() {
      _inboxBloc.groupInboxList = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: ' Hộp thư tin nhắn',
        automaticallyImplyLeading: true,
        actions: [
          Center(
            child: AnimatedSearchBar(
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
            ),
          ),
        ],
      ),
      body: _inboxBloc.groupInboxList != null
          ? RefreshIndicator(
              color: ptPrimaryColor(context),
              onRefresh: () async {
                await _inboxBloc.getList20InboxGroup(_authBloc.userModel.id);
                return;
              },
              child: _inboxBloc.groupInboxList.length != 0
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: _inboxBloc.groupInboxList.length,
                      itemBuilder: (context, index) {
                        final group = _inboxBloc.groupInboxList[index];
                        return ListTile(
                          onTap: () {
                            InboxChat.navigate(group, group.lastUser)
                                .then((value) => reload());
                          },
                          tileColor:
                              group.reader.contains(_authBloc.userModel.id)
                                  ? Colors.white
                                  : ptBackgroundColor(context),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(group.image ??
                                'assets/image/default_avatar.png'),
                          ),
                          title: Text(
                            group.users.indexWhere((element) =>
                                        element == _authBloc.userModel.id) ==
                                    0
                                ? group.usersName[1]
                                : group.usersName[0],
                            style: ptTitle().copyWith(
                                color: group.reader
                                        .contains(_authBloc.userModel.id)
                                    ? Colors.black54
                                    : Colors.black87,
                                fontSize: group.reader
                                        .contains(_authBloc.userModel.id)
                                    ? 15
                                    : 16),
                          ),
                          subtitle: Text(
                            // (group.lastUser ==  _authBloc.userModel.name? 'Bạn: ':'Tin nhắn mới: ')+
                            group.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ptTiny().copyWith(
                                fontWeight: _inboxBloc
                                        .groupInboxList[index].reader
                                        .contains(_authBloc.userModel.id)
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                                color: group.reader
                                        .contains(_authBloc.userModel.id)
                                    ? Colors.black54
                                    : Colors.black87,
                                fontSize: group.reader
                                        .contains(_authBloc.userModel.id)
                                    ? 12
                                    : 13.5),
                          ),
                          trailing: Column(
                            children: [
                              SizedBox(height: 12),
                              Text(
                                Formart.timeByDay(
                                    DateTime.tryParse(group.time)),
                                style: ptSmall().copyWith(
                                    fontWeight: _inboxBloc
                                            .groupInboxList[index].reader
                                            .contains(_authBloc.userModel.id)
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                    color: group.reader
                                            .contains(_authBloc.userModel.id)
                                        ? Colors.black54
                                        : Colors.black87,
                                    fontSize: _inboxBloc
                                            .groupInboxList[index].reader
                                            .contains(_authBloc.userModel.id)
                                        ? 12
                                        : 13),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                      ),
                    )
                  : EmptyWidget(
                      assetImg: 'assets/image/no_message.png',
                      title: 'Bạn chưa có tin nhắn nào',
                      content:
                          'Bạn có thể nhắn tin với người khác khi cả 2 là bạn bè.',
                    ),
            )
          : kLoadingSpinner,
    );
  }
}
