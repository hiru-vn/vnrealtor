import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/post/pick_coordinates.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vnrealtor/utils/file_util.dart';

class CreatePostPage extends StatefulWidget {
  static navigate() {
    navigatorKey.currentState.push(pageBuilder(CreatePostPage()));
  }

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  FocusNode _activityNode = FocusNode();
  LatLng _pos;
  DateTime _expirationDate;
  String _shareWith = 'public';
  TextEditingController _contentC = TextEditingController();
  List<String> _videos = [];
  List<String> _images = [];
  List<String> _allVideoAndImage = [];
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _createPost() async {
    if (_contentC.text.trim() == '') {
      showToast('Nội dung không được để trống', context);
      return;
    }
    if (_allVideoAndImage.length == 0) {
      showToast('Phải có ít nhất một hình ảnh hoặc video', context);
      return;
    }
    showSimpleLoadingDialog(context);
    final res = await _postBloc.createPost(
        _contentC.text,
        _expirationDate?.toIso8601String(),
        _shareWith == 'public',
        _pos?.latitude,
        _pos?.longitude,
        _images,
        _videos);
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      _postBloc.post.insert(0, res.data);
      await navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
  }

  Future _upload(String filePath) async {
    try {
      _allVideoAndImage.add(loadingGif);
      setState(() {});
      final res = await FileUtil.uploadFireStorage(File(filePath),
          path:
              'posts/user_${AuthBloc.instance.userModel.id}/${Formart.formatToDate(DateTime.now(), seperateChar: '-')}');
      if (FileUtil.getFbUrlFileType(res) == FileType.image ||
          FileUtil.getFbUrlFileType(res) == FileType.gif) {
        _images.add(res);
        _allVideoAndImage.add(res);
      }
      if (FileUtil.getFbUrlFileType(res) == FileType.video) {
        _videos.add(res);
        _allVideoAndImage.add(res);
      }
      _allVideoAndImage.remove(loadingGif);
      setState(() {});
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth(context),
      height: deviceHeight(context),
      child: Material(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              appBar: AppBar1(
                automaticallyImplyLeading: true,
                title: '',
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15).copyWith(top: 0),
                      child: Text(
                        'Hình ảnh/ Video',
                        style: ptBigTitle().copyWith(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15).copyWith(top: 0),
                      child: SizedBox(
                        height: 110,
                        child: ImageRowPicker(
                          _allVideoAndImage,
                          onUpdateListImg: (listImg) {},
                          onAddImg: _upload,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          maxLength: 400,
                          maxLines: null,
                          controller: _contentC,
                          style: ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nội dung bài viết',
                            hintStyle: ptTitle().copyWith(
                                color: Colors.black38, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Positioned(
              bottom: 0,
              width: deviceWidth(context),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    _buildForm(),
                    SizedBox(
                      height: 3.0,
                    ),
                    ExpandRectangleButton(
                      text: 'Đăng bài',
                      onTap: _createPost,
                    ),
                    SizedBox(
                      height: _activityNode.hasFocus
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildForm() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 3,
          ),
          InkWell(
            highlightColor: ptAccentColor(context),
            splashColor: ptPrimaryColor(context),
            onTap: () {
              PickCoordinates.navigate().then((value) => setState(() {
                    _pos = value;
                    FocusScope.of(context).requestFocus(FocusNode());
                  }));
            },
            child: CustomListTile(
              leading: Icon(
                Icons.map,
                color: Colors.black54,
              ),
              title: Text(
                'Gắn vị trí',
                style: ptTitle(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_pos != null) Text('Đã chọn'),
                  SizedBox(width: 10),
                  Icon(
                    MdiIcons.arrowRightCircle,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 3,
          ),
          CustomListTile(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 500)),
              ).then((value) => setState(() {
                    _expirationDate = value;
                    FocusScope.of(context).requestFocus(FocusNode());
                  }));
            },
            leading: Icon(
              Icons.date_range,
              color: Colors.black54,
            ),
            title: Text(
              'Ngày hết hạn',
              style: ptTitle(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Formart.formatToDate(_expirationDate) ?? 'Không hết hạn'),
                // SizedBox(width: 10),
                //   Icon(
                //     MdiIcons.calendar,
                //     size: 20,
                //     color: Colors.black54,
                //   ),
              ],
            ),
          ),
          Divider(
            height: 3,
          ),
          CustomListTile(
            leading: Icon(
              Icons.language,
              color: Colors.black54,
            ),
            title: Text(
              'Chia sẻ với',
              style: ptTitle(),
            ),
            trailing: _shareWith != null
                ? Text(_shareWith == 'public'
                    ? 'Tất cả mọi người'
                    : 'Chỉ bạn bè mới nhìn thấy')
                : Text('Chọn'),
            onTap: () {
              pickList(context, title: 'Chia sẻ với', onPicked: (value) {
                setState(() {
                  _shareWith = value;
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              }, options: [
                PickListItem('public', 'Tất cả mọi người'),
                PickListItem('friend', 'Chỉ bạn bè mới nhìn thấy'),
              ], closeText: 'Xong');
            },
          ),
        ],
      ),
    );
  }
}
