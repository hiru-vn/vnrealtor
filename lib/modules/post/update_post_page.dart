import 'dart:io';

import 'package:datcao/modules/model/post.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/post/pick_coordinates.dart';
import 'package:datcao/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:hashtagable/hashtagable.dart';

class UpdatePostPage extends StatefulWidget {
  final PostModel post;
  UpdatePostPage(this.post);

  static Future navigate(PostModel post) {
    return navigatorKey.currentState.push(pageBuilder(UpdatePostPage(
      post,
    )));
  }

  @override
  _UpdatePostPageState createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
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
    _videos = widget.post.mediaPosts
        .where((element) => element.type == 'VIDEO')
        .map((e) => e.url)
        .toList();
    _images = widget.post.mediaPosts
        .where((element) => element.type == 'PICTURE')
        .map((e) => e.url)
        .toList();
    _allVideoAndImage = [..._videos, ..._images];
    _expirationDate = DateTime.tryParse(widget.post.expirationDate);
    if (widget.post.locationLat != null)
      _pos = LatLng(widget.post.locationLat, widget.post.locationLong);
    _contentC.text = widget.post.rawContent ?? widget.post.content;
    //if (widget.post.hashTag.length > 0)
    // _contentC.text += ('\n' + widget.post.hashTag.join('  '));
    _shareWith = widget.post.publicity ? 'public' : 'friend';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _updatePost() async {
    if (_contentC.text.trim() == '') {
      showToast('Nội dung không được để trống', context);
      return;
    }
    if (_allVideoAndImage.length == 0) {
      showToast('Phải có ít nhất một hình ảnh hoặc video', context);
      return;
    }
    showSimpleLoadingDialog(context);
    final res = await _postBloc.updatePost(
        widget.post.id,
        _contentC.text.trim(),
        _expirationDate?.toIso8601String(),
        _shareWith == 'public',
        _pos?.latitude,
        _pos?.longitude,
        _images,
        _videos);
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      final index =
          _postBloc.feed.indexWhere((element) => element.id == widget.post.id);
      _postBloc.feed[index] = res.data;

      //remove link image because backend auto formart it's size to fullhd and 360, so we will not need user image anymore

      navigatorKey.currentState.maybePop(true);
    } else {
      showToast(res.errMessage, context);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future _upload(String filePath) async {
    try {
      _allVideoAndImage.add(loadingGif);
      setState(() {});
      final res = await FileUtil.uploadFireStorage(File(filePath),
          path:
              'posts/user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}');
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

  Future _uploadMultiImage(List<String> filePaths) async {
    try {
      if (_allVideoAndImage.length >= 9) {
        showToast('Chỉ được đăng tối đa 9 ảnh/video', context);
        return;
      }
      _allVideoAndImage.addAll(filePaths.map((e) => loadingGif));
      setState(() {});
      final res = await Future.wait(filePaths.map((e) => FileUtil.uploadFireStorage(
          File(e),
          path:
              'posts/user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}')));
      res.forEach((element) {
        if (FileUtil.getFbUrlFileType(element) == FileType.image ||
            FileUtil.getFbUrlFileType(element) == FileType.gif) {
          _images.add(element);
          _allVideoAndImage.add(element);
        }
        if (FileUtil.getFbUrlFileType(element) == FileType.video) {
          _videos.add(element);
          _allVideoAndImage.add(element);
        }
      });

      _allVideoAndImage.removeWhere((e) => e == loadingGif);
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
      child: Scaffold(
        appBar: AppBar1(
          title: widget.post.user != null ? 'Bài viết của tôi' : '',
          automaticallyImplyLeading: true,
          bgColor: ptSecondaryColor(context),
          textColor: ptPrimaryColor(context),
          actions: [
            Center(
              child: FlatButton(
                color: ptPrimaryColor(context),
                onPressed: _updatePost,
                child: Text(
                  'Cập nhật',
                  style: ptTitle().copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 12,
            )
          ],
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: ImageButtonPicker(
                _allVideoAndImage,
                onUpdateListImg: (listImg) {},
                onAddImg: _upload,
                onAddMultiImg: _uploadMultiImage,
                onRemoveImg: (file) {
                  _images.remove(file);
                  _videos.remove(file);
                  _allVideoAndImage.remove(file);
                  setState(() {});

                  // FileUtil.deleteFileFireStorage(file);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 8, bottom: 3),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                // elevation: 5,
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 170),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5)
                            .copyWith(bottom: 0),
                        child: HashTagTextField(
                          maxLength: 400,
                          maxLines: null,
                          minLines: 4,
                          controller: _contentC,
                          basicStyle:
                              ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nội dung bài viết',
                            hintStyle: ptTitle().copyWith(
                                color: Colors.black38, letterSpacing: 1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        height: 30,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 30,
                          width: deviceWidth(context) - 20,
                          child: ListView.separated(
                            // shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  setState(() {
                                    _contentC.text = _contentC.text +
                                        ' ' +
                                        _postBloc.hasTags
                                            .where((element) =>
                                                _contentC.text
                                                    .contains(element['key']) &&
                                                !_contentC.text
                                                    .contains(element['value']))
                                            .toList()[index]['value']
                                            .toString();
                                    _contentC.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _contentC.text.length));
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: ptSecondaryColor(context),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      _postBloc.hasTags
                                          .where((element) =>
                                              _contentC.text
                                                  .contains(element['key']) &&
                                              !_contentC.text
                                                  .contains(element['value']))
                                          .toList()[index]['value']
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _postBloc.hasTags
                                .where((element) =>
                                    _contentC.text.contains(element['key']) &&
                                    !_contentC.text.contains(element['value']))
                                .toList()
                                .length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  _buildForm(),
                  SizedBox(
                    height: 3.0,
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.all(15),
                  //     child: Center(
                  //       child: RoundedBtn(
                  //         height: 45,
                  //         text: 'Cập nhật',
                  //         onPressed: _updatePost,
                  //         width: 150,
                  //         color: ptPrimaryColor(context),
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: 15,
                  //           vertical: 8,
                  //         ),
                  //       ),
                  //     )),
                  SizedBox(
                    height: _activityNode.hasFocus
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ]),
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
