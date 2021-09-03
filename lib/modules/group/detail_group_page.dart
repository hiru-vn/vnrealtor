import 'dart:async';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/group/create_post_group_page.dart';
import 'package:datcao/modules/group/info_group_page.dart';
import 'package:datcao/modules/group/member_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/widget/page_skeleton.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/modules/post/tag_user_list_page.dart';
import 'package:datcao/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './widget/setting_group_bottom_sheet.dart';
import 'widget/choose_user_popup.dart';

class DetailGroupPage extends StatefulWidget {
  static Future navigate(GroupModel groupModel, {String groupId}) {
    return navigatorKey.currentState
        .push(pageBuilder(DetailGroupPage(groupModel, groupId: groupId)));
  }

  final GroupModel groupModel;
  final String groupId;
  DetailGroupPage(this.groupModel, {this.groupId});

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  List<UserModel> admins;
  GroupBloc _groupBloc;
  Completer<GoogleMapController> _controller = Completer();
  List<PostModel> posts;
  GroupModel group;
  bool isLoadingBtn = false;
  List<UserModel> pendingUsers;

  @override
  void initState() {
    group = widget.groupModel;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      if (group == null) {
        _loadGroup();
      } else {
        _loadPendingUsers();
      }
      _loadPost();
    }
    super.didChangeDependencies();
  }

  _loadPendingUsers() {
    if (!group.isAdmin && !group.isOwner) return;
    UserBloc.instance
        .getListUserIn(widget.groupModel.pendingMemberIds.sublist(
            0,
            widget.groupModel.pendingMemberIds.length > 5
                ? 5
                : widget.groupModel.pendingMemberIds.length))
        .then((res) {
      if (res.isSuccess) {
        setState(() {
          pendingUsers = res.data;
        });
      }
    });
  }

  _loadGroup() async {
    final res = await GroupBloc.instance.getOneGroup(widget.groupId);
    if (res.isSuccess) {
      setState(() {
        group = res.data;
      });
      _loadPendingUsers();
    } else {
      showToast('Có lỗi khi load dữ liệu', context);
    }
  }

  _loadPost() {
    _groupBloc.getPostGroup(group?.id ?? widget.groupId).then((res) {
      if (res.isSuccess)
        setState(() {
          posts = res.data;
        });
      else
        showToast(res.errMessage, context);
    });
  }

  _inviteUsers(List<String> users) async {
    if (users.length == 0) {
      await navigatorKey.currentState.maybePop();
      return;
    }
    showWaitingDialog(context);
    final res = await _groupBloc.sendInviteGroup(group?.id, users);
    closeLoading();
    if (res.isSuccess) {
      showToast('Gửi lời mời thành công', context, isSuccess: true);
    } else {
      showToast(res.errMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: SecondAppBar(
        title: group?.name ?? '',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            group != null ? _buildGroupInfo() : _buildGroupSkeleton(),
            SizedBox(height: 14),
            if (posts == null)
              PostSkeleton()
            else
              posts.length == 0
                  ? SizedBox(
                      width: deviceWidth(context),
                      height: 50,
                      child:
                          Center(child: Text('Nhóm này chưa có bài đăng nào')))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final item = posts[index];
                        return PostWidget(item);
                      },
                    ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    return Container(
      color: ptPrimaryColor(context),
      child: Column(children: [
        Stack(
          children: [
            SizedBox(
              width: deviceWidth(context),
              height: 160,
              child: Image.network(
                group.coverImage ?? '',
                fit: BoxFit.cover,
                loadingBuilder: kLoadingBuilder,
              ),
            ),
            if (!group.isOwner && group.isMember)
              Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      audioCache.play('tab3.mp3');
                      final confirm = await showConfirmDialog(
                          context, 'Xác nhận rời nhóm này?',
                          confirmTap: () {}, navigatorKey: navigatorKey);
                      if (!confirm) return;
                      final res = await _groupBloc.leaveGroup(group.id);
                      if (res.isSuccess) {
                        await navigatorKey.currentState.maybePop();
                      } else {
                        showToast(res.errMessage, context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                          color: ptPrimaryColor(context),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Thoát', style: ptSmall()),
                          SizedBox(width: 3),
                          Icon(
                            Icons.exit_to_app_rounded,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  )),
            if (group.isOwner || group.isAdmin)
              Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      audioCache.play('tab3.mp3');
                      showSettingGroup(context, group).then((value) {
                        if (value is GroupModel) {
                          setState(() {
                            group = value;
                          });
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                          color: ptPrimaryColor(context),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cài đặt',
                              style: ptSmall().copyWith(color: Colors.black54)),
                          SizedBox(width: 3),
                          Icon(Icons.settings, size: 16, color: Colors.black54)
                        ],
                      ),
                    ),
                  ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  audioCache.play('tab3.mp3');
                  InfoGroupPage.navigate(group);
                },
                child: Row(
                  children: [
                    Text(
                      group.name ?? 'null',
                      style: ptBigTitle(),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset('assets/icon/public.png'),
                  ),
                  SizedBox(width: 5),
                  Text(!group.privacy ? 'Công khai' : 'Nhóm kín',
                      style: ptBigBody().copyWith(fontSize: 14.6)),
                  SizedBox(width: 20),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.cyan),
                  ),
                  SizedBox(width: 5),
                  Text('${group.countMember} thành viên',
                      style: ptBigBody().copyWith(fontSize: 14.6)),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      audioCache.play('tab3.mp3');
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return TagUserListPage('Mời bạn bè vào nhóm');
                        },
                        backgroundColor: Colors.transparent,
                      ).then((user) {
                        if (user != null)
                          _inviteUsers((user as List<UserModel>)
                              .map<String>((e) => e.id)
                              .toList());
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: ptPrimaryColor(context),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Mời',
                              style: ptSmall()
                                  .copyWith(color: ptPrimaryColor(context))),
                          Icon(Icons.add,
                              size: 16, color: ptPrimaryColor(context))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              if (group.pendingMemberIds
                  .contains(AuthBloc.instance.userModel.id))
                ExpandBtn(
                    color: ptPrimaryColor(context),
                    textColor: ptPrimaryColor(context),
                    text: 'Đang chờ duyệt yêu cầu',
                    onPress: () {},
                    borderRadius: 5)
              else if (!group.isMember && !group.isOwner)
                ExpandBtn(
                    text: 'Tham gia',
                    isLoading: isLoadingBtn,
                    onPress: () async {
                      setState(() {
                        isLoadingBtn = true;
                      });
                      final res = await _groupBloc.joinGroup(group.id);
                      setState(() {
                        isLoadingBtn = false;
                      });
                      if (res.isSuccess) {
                        setState(() {
                          group = res.data;
                        });
                      } else {
                        showToast(res.errMessage, context);
                      }
                    },
                    borderRadius: 5)
              else
                ExpandBtn(
                    text: 'Đăng bài',
                    onPress: () {
                      GroupCreatePostPage.navigate(group);
                    },
                    borderRadius: 5)
            ],
          ),
        ),
        Container(
          color: ptPrimaryColor(context),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quản trị viên',
                  style: ptBigBody().copyWith(fontSize: 14.6)),
              SizedBox(height: 2),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: group.owner.avatar != null
                          ? Image.network(
                              group.owner.avatar,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      'assets/image/default_avatar.png'),
                            )
                          : Image.asset('assets/image/default_avatar.png'),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(group.owner.name),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        audioCache.play('tab3.mp3');
                        GroupMemberPage.navigate(widget.groupModel ?? group);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: ptPrimaryColor(context),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              width: 1, color: Theme.of(context).dividerColor),
                        ),
                        child: Text('Xem thêm', style: ptTitle()),
                      ))
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 14),
        if (group.censor && (group.isAdmin || group.isOwner)) ...[
          Container(
            color: ptPrimaryColor(context),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yêu cầu tham gia nhóm',
                    style: ptBigBody().copyWith(fontSize: 14.6)),
                SizedBox(height: 2),
                SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      group.pendingMemberIds != null &&
                              group.pendingMemberIds.length > 0
                          ? Text(
                              'Có ${group.pendingMemberIds.length} yêu cầu tham gia')
                          : Text('Không có yêu cầu tham gia mới'),
                      SizedBox(width: 10),
                      pendingUsers != null
                          ? Expanded(
                              child: Stack(
                              fit: StackFit.expand,
                              children: pendingUsers
                                  .map<Widget>((e) => Positioned(
                                      height: 25,
                                      left: 5 *
                                          pendingUsers.indexOf(e).toDouble(),
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ptPrimaryColor(context),
                                          radius: 9,
                                          backgroundImage: e.avatar != null
                                              ? CachedNetworkImageProvider(
                                                  e.avatar)
                                              : AssetImage(
                                                  'assets/image/default_avatar.png'),
                                        ),
                                      )))
                                  .toList(),
                            ))
                          : Spacer(),
                      GestureDetector(
                        onTap: () async {
                          audioCache.play('tab3.mp3');
                          final users = await showChooseUsersPopup(context,
                              group.pendingMemberIds, 'Yêu cầu tham gia',
                              submitText: 'Duyệt');

                          if (users.length > 0) {
                            showWaitingDialog(context);
                            final res = await _groupBloc.adminAcceptMem(
                                group.id, users.map((e) => e.id).toList());
                            closeLoading();
                            if (res.isSuccess) {
                              showToast('Thêm ${users.length} thành viên mới',
                                  context,
                                  isSuccess: true);
                              setState(() {
                                if (res.data is GroupModel) group = res.data;
                              });
                            } else
                              showToast(res.errMessage, context);
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Text('Chi tiết', style: ptSmall()),
                            Icon(Icons.chevron_right_rounded)
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 14),
        ],
        Container(
          color: ptPrimaryColor(context),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mô tả', style: ptTitle()),
              SizedBox(height: 8),
              Text(group.description, style: ptTitle()),
              SizedBox(height: 8),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: 20,
                            child: Image.asset(!group.privacy
                                ? 'assets/icon/public.png'
                                : 'assets/icon/lock.png')),
                      )),
                  Text(group.privacy ? 'Nhóm kín' : 'Công khai'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: 20,
                            child: Image.asset('assets/icon/location.png')),
                      )),
                  Expanded(child: Text('Địa chỉ: ' + group.address)),
                ],
              ),
              SizedBox(height: 12),
              if (group.locationLat != null && group.locationLong != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: deviceWidth(context),
                      maxHeight: deviceWidth(context) / 2,
                    ),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(group.locationLat, group.locationLong),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: {
                        Marker(
                            markerId: MarkerId('1'),
                            position:
                                LatLng(group.locationLat, group.locationLong))
                      },
                      onTap: (location) {},
                    ),
                  ),
                ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildGroupSkeleton() {
    return PageSkeleton();
  }
}
