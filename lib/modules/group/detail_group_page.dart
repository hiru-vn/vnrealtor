import 'dart:async';

import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/create_post_group_page.dart';
import 'package:datcao/modules/group/info_group_page.dart';
import 'package:datcao/modules/group/invite_group.dart';
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
      }
      _loadPost();
    }
    super.didChangeDependencies();
  }

  _loadGroup() async {
    final res = await GroupBloc.instance.getOneGroup(widget.groupId);
    if (res.isSuccess) {
      setState(() {
        group = res.data;
      });
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
    if (res.isSuccess) {
      showToast('Gửi lời mời thành công', context, isSuccess: true);
      await navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: group?.name ?? '',
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
    return Column(children: [
      Stack(
        children: [
          SizedBox(
            width: deviceWidth(context),
            height: 160,
            child: Image.network(
              group.coverImage ?? '',
              fit: BoxFit.cover,
            ),
          ),
          if (!group.isOwner && group.isMember)
            Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () async {
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
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Thoát',
                            style: ptSmall().copyWith(color: Colors.black54)),
                        SizedBox(width: 3),
                        Icon(Icons.exit_to_app_rounded,
                            size: 16, color: Colors.black54)
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
                    showSettingGroup(context, group);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white30,
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
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
                ),
                SizedBox(width: 5),
                Text('${group.countMember} thành viên',
                    style: ptBigBody().copyWith(fontSize: 14.6)),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return TagUserListPage('Mời bạn bè vào nhóm');
                      },
                      backgroundColor: Colors.transparent,
                    ).then((user) => _inviteUsers((user as List<UserModel>)
                        .map<String>((e) => e.id)
                        .toList()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        color: ptPrimaryColor(context),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Mời',
                            style: ptSmall().copyWith(color: Colors.white)),
                        Icon(Icons.add, size: 16, color: Colors.white)
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 12),
            if (!group.isMember && !group.isOwner)
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
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quản trị viên', style: ptBigBody().copyWith(fontSize: 14.6)),
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
                                Image.asset('assets/image/default_avatar.png'),
                          )
                        : Image.asset('assets/image/default_avatar.png'),
                  ),
                ),
                SizedBox(width: 5),
                Text(group.owner.name),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      GroupMemberPage.navigate(widget.groupModel ?? group);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: ptSecondaryColor(context),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text('Xem thêm', style: ptTitle()),
                    ))
              ],
            )
          ],
        ),
      ),
      SizedBox(height: 14),
      Container(
        color: Colors.white,
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
                Text('Địa chỉ: ' + group.address),
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
    ]);
  }

  Widget _buildGroupSkeleton() {
    return PageSkeleton();
  }
}
