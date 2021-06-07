import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/notification.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';

class InviteGroup extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(InviteGroup()));
  }

  const InviteGroup({Key key}) : super(key: key);

  @override
  _InviteGroupState createState() => _InviteGroupState();
}

class _InviteGroupState extends State<InviteGroup> {
  GroupBloc _groupBloc;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc.getListInviteGroupNotification();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Lời mời tham gia nhóm',
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: (_groupBloc.invites == null)
          ? ListSkeleton()
          : (_groupBloc.invites.length == 0
              ? Center(child: Text('Bạn không có lời mời nào'))
              : ListView.separated(
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    return InviteGroupWidget(_groupBloc.invites[index]);
                  },
                  itemCount: _groupBloc.invites.length,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                )),
    );
  }
}

class InviteGroupWidget extends StatefulWidget {
  final NotificationModel noti;
  InviteGroupWidget(this.noti, {Key key}) : super(key: key);

  @override
  _InviteGroupWidgetState createState() => _InviteGroupWidgetState();
}

class _InviteGroupWidgetState extends State<InviteGroupWidget> {
  GroupModel group;
  GroupBloc _groupBloc;
  bool canNotLoad = false;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc.getOneGroup(widget.noti.data['modelId']).then((res) {
        if (res.isSuccess)
          setState(() {
            group = res.data;
          });
        else
          setState(() {
            canNotLoad = true;
          });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (canNotLoad) return SizedBox.shrink();
    if (group == null) return kLoadingSpinner;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Lời mời từ ' + widget.noti.body.split(' ')[0],
          style: ptBody().copyWith(color: Colors.black54),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: double.infinity,
            color: Colors.grey[50],
            child: Row(
              children: [
                SizedBox(
                    width: deviceWidth(context) / 2.1 - 30,
                    height: deviceWidth(context) / 4 - 10,
                    child: Image.network(
                      group.coverImage,
                      fit: BoxFit.cover,
                      loadingBuilder: kLoadingBuilder,
                    )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () => DetailGroupPage.navigate(group),
                  child: Container(
                    height: deviceWidth(context) / 4 - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          group.name,
                        ),
                        SizedBox(height: 3),
                        Text(
                          group.privacy
                              ? 'Nhóm kín'
                              : 'Công khai' +
                                  ' • ${group.countMember} thành viên',
                          style: ptTiny().copyWith(color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${group.postIn24h} bài đăng hôm nay',
                          style: ptTiny().copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )),
                Icon(Icons.chevron_right_rounded),
                SizedBox(width: 3)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
