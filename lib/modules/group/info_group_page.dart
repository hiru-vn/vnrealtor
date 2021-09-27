import 'dart:async';

import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/member_page.dart';
import 'package:datcao/modules/group/update_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/widget/page_skeleton.dart';
import 'package:datcao/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoGroupPage extends StatefulWidget {
  static Future navigate(GroupModel groupModel, {String groupId}) {
    return navigatorKey.currentState
        .push(pageBuilder(InfoGroupPage(groupModel, groupId: groupId)));
  }

  final GroupModel groupModel;
  final String groupId;
  InfoGroupPage(this.groupModel, {this.groupId});

  @override
  _InfoGroupPageState createState() => _InfoGroupPageState();
}

class _InfoGroupPageState extends State<InfoGroupPage> {
  List<UserModel> admins;
  GroupBloc _groupBloc;
  Completer<GoogleMapController> _controller = Completer();
  List<PostModel> posts;
  GroupModel group;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: SecondAppBar(
        title: group?.name ?? '',
      ),
      body: SingleChildScrollView(
        child: group != null ? _buildGroupInfo() : _buildGroupSkeleton(),
      ),
    );
  }

  Widget _buildGroupInfo() {
    var brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    return Column(children: [
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
                          child: Image.asset(
                            !group.privacy
                                ? 'assets/icon/public.png'
                                : 'assets/icon/lock.png',
                            color: isDarkMode
                                ? Colors.white
                                : ptMainColor(context),
                          )),
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
                          child: Image.asset(
                            'assets/icon/location.png',
                            color: isDarkMode
                                ? Colors.white
                                : ptMainColor(context),
                          )),
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
                    markers: {
                      Marker(
                          markerId: MarkerId('1'),
                          position:
                              LatLng(group.locationLat, group.locationLong))
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (location) {},
                  ),
                ),
              ),
          ],
        ),
      ),
      SizedBox(height: 12),
      Container(
        color: ptPrimaryColor(context),
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
                    audioCache.play('tab3.mp3');
                    GroupMemberPage.navigate(widget.groupModel);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: ptPrimaryColorLight(context),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text('Xem thêm', style: ptTitle()),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      SizedBox(height: 12),
      Container(
        color: ptPrimaryColor(context),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: deviceWidth(context)),
            Text('Hoạt động nhóm', style: ptBigBody().copyWith(fontSize: 14.6)),
            SizedBox(height: 2),
            _buildTile(
                'post',
                '${widget.groupModel.postIn24h ?? 0} bài viết hôm nay',
                '${widget.groupModel.totalPost ?? 0} bài viết'),
            _buildTile(
                'person',
                '${widget.groupModel.countMember ?? 0} thành viên',
                '${widget.groupModel.memberIn24h ?? 0} thành viên tham gia hôm nay'),
            _buildTile(
                'group',
                'Tạo ${Formart.timeByDayVi(DateTime.tryParse(widget.groupModel.createdAt))}',
                null)
          ],
        ),
      ),
      SizedBox(
        height: 18,
      ),
      if (group.isOwner || group.isAdmin)
        GestureDetector(
          onTap: () async {
            audioCache.play('tab3.mp3');
            UpdateGroupPage.navigate(group);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: ptPrimaryColor(context))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Cập nhật thông tin nhóm',
                    style: ptTitle().copyWith(color: ptPrimaryColor(context))),
                SizedBox(width: 3),
                Icon(Icons.edit, size: 16, color: ptPrimaryColor(context))
              ],
            ),
          ),
        ),
      SizedBox(
        height: 18,
      )
    ]);
  }

  Widget _buildGroupSkeleton() {
    return PageSkeleton();
  }

  Widget _buildTile(String asset, String title, String content) {
    var brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 6, right: 4, left: 4),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Image.asset(
              'assets/icon/$asset.png',
              color: isDarkMode ? Colors.white : ptMainColor(context),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: ptTitle(),
              ),
              if (content != null)
                Text(
                  content,
                  style: ptSmall(),
                )
            ],
          )
        ],
      ),
    );
  }
}
