import 'dart:async';

import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/create_post_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/create_post_page.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailGroupPage extends StatefulWidget {
  static Future navigate(GroupModel groupModel) {
    return navigatorKey.currentState
        .push(pageBuilder(DetailGroupPage(groupModel)));
  }

  final GroupModel groupModel;
  DetailGroupPage(this.groupModel);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  List<UserModel> admins;
  GroupBloc _groupBloc;
  Completer<GoogleMapController> _controller = Completer();
  List<PostModel> posts;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc
          .getPostGroup(
              filter: GraphqlFilter(
                  filter: "{groupId: \"${widget.groupModel.id}\"}",
                  limit: 20,
                  order: "{updatedAt: -1}"))
          .then((res) {
        if (res.isSuccess)
          setState(() {
            posts = res.data;
          });
        else
          showToast(res.errMessage, context);
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: widget.groupModel.name,
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: deviceWidth(context),
              height: 160,
              child: Image.network(
                widget.groupModel.coverImage ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Bất động sản Việt Nam',
                        style: ptBigTitle(),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.chevron_right)
                    ],
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
                      Text('Công khai',
                          style: ptBigBody().copyWith(fontSize: 14.6)),
                      SizedBox(width: 30),
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.cyan),
                      ),
                      SizedBox(width: 5),
                      Text('100 thành viên',
                          style: ptBigBody().copyWith(fontSize: 14.6)),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (!widget.groupModel.isMember && !widget.groupModel.isOwner)
                    ExpandBtn(text: 'Tham gia', onPress: () {}, borderRadius: 5)
                  else
                    ExpandBtn(
                        text: 'Đăng bài',
                        onPress: () {
                          GroupCreatePostPage.navigate(widget.groupModel);
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
                  Text('Quản trị viên',
                      style: ptBigBody().copyWith(fontSize: 14.6)),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: widget.groupModel.owner.avatar != null
                            ? Image.network(
                                widget.groupModel.owner.avatar,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                        'assets/image/default_avatar.png'),
                              )
                            : Image.asset('assets/image/default_avatar.png'),
                      ),
                      SizedBox(width: 5),
                      Text(widget.groupModel.owner.name),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: ptSecondaryColor(context),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text('Xem thêm', style: ptTitle()),
                      )
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
                  Text(widget.groupModel.description, style: ptTitle()),
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
                                child: Image.asset(widget.groupModel.privacy
                                    ? 'assets/icon/public.png'
                                    : 'assets/icon/lock.png')),
                          )),
                      Text(
                          widget.groupModel.privacy ? 'Nhóm kín' : 'Công khai'),
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
                      Text('Địa chỉ: ' + widget.groupModel.address),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (widget.groupModel.locationLat != null &&
                      widget.groupModel.locationLong != null)
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
                            target: LatLng(widget.groupModel.locationLat,
                                widget.groupModel.locationLong),
                            zoom: 5,
                          ),
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
            SizedBox(height: 14),
            if (posts == null)
              PostSkeleton()
            else
              posts.length == 0
                  ? SizedBox(
                      height: 50, child: Text('Nhóm này chưa có bài đăng nào'))
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
}
