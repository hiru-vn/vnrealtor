import 'package:datcao/modules/model/user.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

Future<List<UserModel>> showChooseUsersPopup(
    BuildContext context, List<String> userIds, String title,
    {String submitText}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ChooseUsersPage(title, userIds, submitText: submitText);
    },
    backgroundColor: Colors.transparent,
  );
}

class ChooseUsersPage extends StatefulWidget {
  final String title;
  final String submitText;
  final List<String> userIds;
  ChooseUsersPage(this.title, this.userIds, {this.submitText});

  @override
  _ChooseUsersPageState createState() => _ChooseUsersPageState();
}

class _ChooseUsersPageState extends State<ChooseUsersPage> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  List<UserModel> listUsers;
  List<UserModel> chooseUsers = [];
  String search = '';

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
      _userBloc = Provider.of(context);
      _userBloc.getListUserIn(widget.userIds).then((value) {
        if (value.isSuccess) {
          setState(() {
            listUsers = value.data;
          });
        } else
          showToast('Có lỗi khi lấy danh sách, vui lòng đóng trang và thử lại',
              context);
      });
    }
    super.didChangeDependencies();
  }

  _tapUser(UserModel user) {
    setState(() {
      if (!chooseUsers.contains(user))
        chooseUsers.add(user);
      else
        chooseUsers.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.title,
              style: ptBigBody().copyWith(color: Colors.black)),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  navigatorKey.currentState.pop(chooseUsers ?? <UserModel>[]),
              child: Center(
                child: SizedBox(
                  width: 50,
                  child: Text(
                    widget.submitText??'Xong',
                    style: ptTitle(),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.search, color: Colors.black45)),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() {
                      search = val;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên',
                        border: InputBorder.none,
                        hintStyle: ptBody().copyWith(color: Colors.black38)),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Expanded(
                child: (listUsers != null)
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listUsers
                            .where((e) => e.name.contains(search))
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final user = listUsers
                              .where((e) => e.name.contains(search))
                              .toList()[index];
                          return _buildUserItem(user,
                              chooseUsers.contains(user), () => _tapUser(user));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              height: 1,
                              color: Colors.black12.withOpacity(0.3));
                        },
                      )
                    : _buildUserLoading())
          ],
        ),
      ),
    );
  }

  _buildUserItem(UserModel user, bool isSelect, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: user.avatar != null
                ? CachedNetworkImageProvider(user.avatar)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(user.name, style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildUserLoading() {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      items: 3,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}
