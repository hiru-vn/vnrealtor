import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';

class GroupMemberPage extends StatefulWidget {
  final GroupModel groupModel;
  static Future navigate(GroupModel groupModel) {
    return navigatorKey.currentState
        .push(pageBuilder(GroupMemberPage(groupModel)));
  }

  GroupMemberPage(this.groupModel);

  @override
  _GroupMemberPageState createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  GroupBloc _groupBloc;
  UserModel owner;
  List<UserModel> admins;
  List<UserModel> members;
  String search = '';
  bool enableManageUser = false;
  List<String> _selectedUserIds = [];
  GroupModel _group;
  List<String> adminIds;
  List<String> memberIds;

  @override
  void initState() {
    _group = widget.groupModel;
    adminIds = [..._group.adminIds, _group.ownerId];
    memberIds = _group.memberIds.where((e) => !adminIds.contains(e)).toList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      owner = widget.groupModel.owner;
      UserBloc.instance.getListUserIn(adminIds).then((res) {
        if (res.isSuccess) {
          setState(() {
            admins = res.data;
          });
        } else
          showToast(res.errMessage, context);
      });
      UserBloc.instance.getListUserIn(memberIds).then((res) {
        if (res.isSuccess) {
          setState(() {
            members = res.data;
          });
        } else
          showToast(res.errMessage, context);
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Thành viên',
        textColor: ptPrimaryColor(context),
        automaticallyImplyLeading: true,
        actions: [
          if (_group.isOwner || _group.isAdmin)
            Center(
              child: GestureDetector(
                onTap: () {
                  audioCache.play('tab3.mp3');
                  setState(() {
                    enableManageUser = !enableManageUser;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: enableManageUser
                          ? ptPrimaryColor(context)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: ptPrimaryColor(context))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Quản lý',
                          style: ptTitle().copyWith(
                              color: enableManageUser
                                  ? Colors.white
                                  : ptPrimaryColor(context))),
                      SizedBox(width: 3),
                      Icon(Icons.edit,
                          size: 14,
                          color: enableManageUser
                              ? Colors.white
                              : ptPrimaryColor(context))
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
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
                              hintStyle: ptBody()),
                        ),
                      ),
                    ],
                  ),
                ),
                if (enableManageUser)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        _buildActionBtn(_selectedUserIds.length > 0, () async {
                          showWaitingDialog(context);
                          final res = await _groupBloc.sendInviteGroupAdmin(
                              _group.id, _selectedUserIds);
                          closeLoading();
                          if (res.isSuccess) {
                            setState(() {
                              _group.adminIds.addAll(_selectedUserIds);
                              admins.addAll(members
                                  .where((e) => _selectedUserIds.contains(e))
                                  .toList());
                              members.removeWhere(
                                  (e) => _selectedUserIds.contains(e));
                              _selectedUserIds.clear();
                            });
                          } else {
                            showToast(res.errMessage, context);
                          }
                        }, 'Mời quản trị viên', context),
                        SizedBox(width: 15),
                        _buildActionBtn(_selectedUserIds.length > 0, () async {
                          showWaitingDialog(context);
                          final res = await _groupBloc.kickMem(
                              _group.id, _selectedUserIds);
                          closeLoading();
                          if (res.isSuccess) {
                            setState(() {
                              _group.memberIds.removeWhere((e) =>
                                  _selectedUserIds.contains(_selectedUserIds));

                              members.removeWhere(
                                  (e) => _selectedUserIds.contains(e));
                              _selectedUserIds.clear();
                            });
                          } else {
                            showToast(res.errMessage, context);
                          }
                        }, 'Cấm khỏi nhóm', context),
                      ],
                    ),
                  ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 23),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                          child: SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/icon/admin.png'))),
                    ),
                    SizedBox(width: 15),
                    Text('Quản trị viên', style: ptTitle()),
                  ],
                ),
                (admins == null)
                    ? ListSkeleton()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MemberWidget(admins
                              .where((e) => e.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase().trim()))
                              .toList()[index]);
                        },
                        itemCount: admins
                            .where((e) => e.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim()))
                            .toList()
                            .length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 0),
                      ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 23),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                          child: SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset('assets/icon/group.png'))),
                    ),
                    SizedBox(width: 15),
                    Text('Thành viên', style: ptTitle()),
                  ],
                ),
                (members == null)
                    ? ListSkeleton()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final member = members
                              .where((e) => e.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase().trim()))
                              .toList()[index];
                          return MemberWidget(
                            member,
                            onSelect: enableManageUser
                                ? (user) {
                                    setState(() {
                                      if (_selectedUserIds.contains(user.id))
                                        _selectedUserIds.remove(user.id);
                                      else
                                        _selectedUserIds.add(user.id);
                                    });
                                  }
                                : null,
                            isSelect: _selectedUserIds.contains(member.id),
                          );
                        },
                        itemCount: members
                            .where((e) => e.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim()))
                            .toList()
                            .length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 0),
                      )
              ],
            ),
          )),
    );
  }

  Widget _buildActionBtn(
      bool enable, Function action, String text, BuildContext context) {
    return GestureDetector(
      onTap: enable
          ? () {
              action();
              audioCache.play('tab3.mp3');
            }
          : () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: enable ? ptPrimaryColor(context) : ptSecondaryColor(context),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: ptBody()
              .copyWith(color: enable ? Colors.white : ptPrimaryColor(context)),
        ),
      ),
    );
  }
}

class MemberWidget extends StatelessWidget {
  final UserModel user;
  final Function(UserModel) onSelect;
  final bool isSelect;

  const MemberWidget(this.user, {this.onSelect, this.isSelect = false});
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = Provider.of(context);
    AuthBloc _authBloc = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(5).copyWith(bottom: 0),
      child: GestureDetector(
        onTap: () {
          audioCache.play('tab3.mp3');
          ProfileOtherPage.navigate(user);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
          child: Row(children: [
            if (onSelect != null)
              GestureDetector(
                  onTap: () {
                    audioCache.play('tab3.mp3');
                    onSelect(user);
                  },
                  child: _buildCheckBox(context)),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: user.avatar != null
                  ? CachedNetworkImageProvider(user.avatar)
                  : AssetImage('assets/image/default_avatar.png'),
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name ?? '',
                        style: ptTitle().copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      if (UserBloc.isVerified(user)) ...[
                        CustomTooltip(
                          margin: EdgeInsets.only(top: 0),
                          message: 'Tài khoản xác thực',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[600],
                            ),
                            padding: EdgeInsets.all(1.3),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                      // Image.asset('assets/image/ip.png'),
                      // SizedBox(width: 2),
                      // Text(
                      //   user.totalPost.toString(),
                      //   style: ptBody().copyWith(color: Colors.yellow),
                      // ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        (() {
                          final role = UserBloc.getRole(user);
                          if (role == UserRole.company) return 'Công ty';
                          if (role == UserRole.agent) return 'Nhà môi giới';

                          return 'Người dùng';
                        })(),
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
                      if (_authBloc.userModel.followingIds
                          .contains(user.id)) ...[
                        Text(
                          ' • ',
                          style: ptSmall().copyWith(color: Colors.grey),
                        ),
                        Text(
                          'Đang theo dõi',
                          style: ptSmall().copyWith(color: Colors.blue),
                        ),
                      ]
                      // else if (_authBloc.userModel.followerIds
                      //     .contains(user.id)) ...[
                      //   Text(
                      //     ' • ',
                      //     style: ptSmall().copyWith(color: Colors.grey),
                      //   ),
                      //   Text(
                      //     'Theo dõi bạn',
                      //     style: ptSmall().copyWith(color: Colors.blue),
                      //   ),
                      // ]
                    ],
                  ),
                ],
              ),
            ),
            if (AuthBloc.instance.userModel != null &&
                !_authBloc.userModel.followingIds.contains(user.id) &&
                user.id != AuthBloc.instance.userModel.id)
              GestureDetector(
                onTap: () {
                  audioCache.play('tab3.mp3');
                  _authBloc.userModel.followingIds.add(user.id);
                  user.followerIds.add(_authBloc.userModel.id);
                  _userBloc.followUser(user.id);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'Theo dõi',
                    style: ptBody().copyWith(color: Colors.white),
                  ),
                ),
              )
          ]),
        ),
      ),
    );
  }

  Widget _buildCheckBox(BuildContext context) {
    if (!isSelect)
      return Container(
        width: 19,
        height: 19,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[200], width: 2),
        ),
      );
    else
      return Container(
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
      );
  }
}
