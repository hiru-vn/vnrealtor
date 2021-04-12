import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:datcao/modules/inbox/import/detail_media.dart';
import 'package:datcao/modules/inbox/import/media_group.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/post/pick_coordinates.dart';
import 'package:datcao/modules/post/search_post_page.dart';
import 'package:datcao/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  final PageController pageController;
  CreatePostPage(this.pageController);
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  FocusNode _activityNode = FocusNode();
  LatLng _pos;
  String _placeName;
  DateTime _expirationDate;
  String _shareWith = 'public';
  TextEditingController _contentC = TextEditingController();
  List<String> _cacheMedias = [];
  List<String> _cachePic = [];
  List<String> _urlMedias = [];
  PostBloc _postBloc;
  bool isProcess = false;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _createPost() async {
    if (isProcess) return;
    try {
      isProcess = true;
      if (_contentC.text.trim() == '') {
        showToast('Nội dung không được để trống', context);
        return;
      }
      if (_cacheMedias.length + _cachePic.length == 0) {
        showToast('Phải có ít nhất một hình ảnh hoặc video', context);
        return;
      }
      showSimpleLoadingDialog(context, canDismiss: false);

      while (_urlMedias.length < _cacheMedias.length + _cachePic.length) {
        await Future.delayed(Duration(milliseconds: 500));
      }

      final res = await _postBloc.createPost(
          _contentC.text.trim(),
          _expirationDate?.toIso8601String(),
          _shareWith == 'public',
          _pos?.latitude,
          _pos?.longitude,
          _urlMedias
              .where((path) =>
                  FileUtil.getFbUrlFileType(path) == FileType.image ||
                  FileUtil.getFbUrlFileType(path) == FileType.gif)
              .toList(),
          _urlMedias
              .where(
                  (path) => FileUtil.getFbUrlFileType(path) == FileType.video)
              .toList());

      navigatorKey.currentState.maybePop();
      if (res.isSuccess) {
        await widget.pageController.animateToPage(0,
            duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        FocusScope.of(context).requestFocus(FocusNode());
        //remove link image because backend auto formart it's size to fullhd and 360, so we will not need user image anymore
        // _images.map((e) => FileUtil.deleteFileFireStorage(e));
        // TODO: clean this

        _expirationDate = null;
        _contentC.clear();
        _cacheMedias.clear();
        _cachePic.clear();
      } else {
        showToast(res.errMessage, context);
      }

      Future.delayed(Duration(seconds: 2), () => _postBloc?.notifyListeners());
    } catch (e) {
      showToast(e.toString(), context);
    } finally {
      isProcess = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth(context),
      height: deviceHeight(context),
      child: Scaffold(
        appBar: CreatePostPageAppBar(widget.pageController, _createPost, true),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(12).copyWith(bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (AuthBloc.instance.userModel.avatar != null &&
                                AuthBloc.instance.userModel.avatar != 'null')
                            ? CachedNetworkImageProvider(
                                AuthBloc.instance.userModel.avatar)
                            : AssetImage('assets/image/default_avatar.png'),
                    child: VerifiedIcon(AuthBloc.instance.userModel?.role, 10),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthBloc.instance.userModel.name ?? '',
                        style: ptTitle(),
                      ),
                      Row(
                        children: [
                          Text(
                            Formart.formatToWeekTime(DateTime.now()),
                            style: ptTiny().copyWith(color: Colors.black54),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              pickList(context, title: 'Chia sẻ với',
                                  onPicked: (value) {
                                setState(() {
                                  _shareWith = value;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                });
                              }, options: [
                                PickListItem('public', 'Tất cả mọi người'),
                                PickListItem(
                                    'friend', 'Chỉ bạn bè mới nhìn thấy'),
                              ], closeText: 'Xong');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.black12)),
                              padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2)
                                  .copyWith(right: 0),
                              child: Row(
                                children: [
                                  Text(
                                    _shareWith == 'public'
                                        ? 'Tất cả'
                                        : 'Bạn bè',
                                    style: ptTiny()
                                        .copyWith(color: Colors.black54),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!(_cacheMedias.length == 0 && _cachePic.length == 0))
              SizedBox(
                height: 95,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: [..._cacheMedias, ..._cachePic].length,
                  itemBuilder: (context, index) {
                    final list = [..._cacheMedias, ..._cachePic];
                    return Stack(
                      children: [
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: MediaWidgetCache(
                              path: list[index],
                              radius: 0,
                              callBack: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DetailMediaGroupWidgetCache(
                                    files: list,
                                    index: index,
                                  );
                                }));
                              }),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              showConfirmDialog(
                                  context, 'Xác nhận xóa file này?',
                                  navigatorKey: navigatorKey, confirmTap: () {
                                setState(() {
                                  final url = _urlMedias.firstWhere(
                                      (element) => element.contains(
                                          FileUtil.changeImageToJpg(
                                                  Path.basename(list[index]))
                                              .replaceAll(
                                                  new RegExp(r'(\?alt).*'), '')
                                              .replaceAll(' ', '')),
                                      orElse: () => null);
                                  if (url != null) {
                                    _cacheMedias.remove(list[index]);
                                    _cachePic.remove(list[index]);
                                    _urlMedias.remove(url);
                                  } else {
                                    showToast(
                                        'File chưa được tải lên, hãy thử lại sau 5 giây',
                                        context);
                                  }
                                });
                              });
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: ptPrimaryColor(context),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              )),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(
                    width: 2,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 3),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                // elevation: 5,
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 170),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12)
                            .copyWith(bottom: 32),
                        child: HashTagTextField(
                          maxLength: 500,
                          maxLines: 15,
                          minLines: 8,
                          controller: _contentC,
                          onChanged: (value) => setState(() {}),
                          basicStyle:
                              ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nội dung bài viết...',
                            hintStyle: ptBigTitle().copyWith(
                                color: Colors.black38,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        height: 30,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: deviceWidth(context) - 20,
                          child: ListView.separated(
                            // shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                                            .where((element) => !_contentC.text
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
                                          .where((element) => !_contentC.text
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
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return MediaPagePickerWidget(
                            onMediaPick: (list) async {
                              setState(() {
                                _cacheMedias = list;
                              });
                              final listUrls = await Future.wait(list.map(
                                  (filePath) => FileUtil.uploadFireStorage(
                                      filePath,
                                      path:
                                          'posts/user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}')));
                              setState(() {
                                _urlMedias = listUrls;
                              });
                            },
                            maxCount: 10,
                          );
                        },
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset('assets/icon/image.png'),
                        )),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      onCustomPersionRequest(
                          permission: Permission.camera,
                          onGranted: () {
                            ImagePicker.pickImage(source: ImageSource.camera)
                                .then((value) async {
                              if (value == null) return;
                              setState(() {
                                _cachePic.add(value.path);
                              });

                              final url = await FileUtil.uploadFireStorage(
                                  value.path,
                                  path:
                                      'posts/user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}');
                              setState(() {
                                _urlMedias.add(url);
                              });
                            });
                          });
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset('assets/icon/camera.png'),
                        )),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      PickCoordinates.navigate().then((value) => setState(() {
                            _pos = value[0];
                            _placeName = value[1];
                            FocusScope.of(context).requestFocus(FocusNode());
                          }));
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset('assets/icon/map.png'),
                        )),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context, 'Đang phát triển',
                          navigatorKey: navigatorKey);
                    },
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset('assets/icon/tag_friend.png'),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // _buildForm(),
            if (_placeName != null && _placeName.trim() != '')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Địa điểm: ',
                      style: ptSmall().copyWith(color: Colors.black)),
                  TextSpan(
                      text: '$_placeName',
                      style: ptSmall().copyWith(fontStyle: FontStyle.italic))
                ])),
              ),
            SizedBox(
              height: 3.0,
            ),
            SizedBox(
              height: _activityNode.hasFocus
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0,
            ),
            SizedBox(
              height: 60,
            ),
          ]),
        ),
      ),
    );
  }
}

class CreatePostPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PageController controller;
  final Function createPost;
  final bool enableBtn;
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  CreatePostPageAppBar(this.controller, this.createPost, this.enableBtn);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 12, bottom: 8, right: 10),
        child: Row(
          children: [
            BackButton(
              color: Colors.black,
              onPressed: () {
                controller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Bài viết mới',
              style: ptBigTitle().copyWith(color: Colors.black),
            ),
            Spacer(),
            FlatButton(
                color: ptPrimaryColor(context),
                onPressed: enableBtn ? createPost : null,
                child: Text(
                  'Đăng',
                  style: ptTitle().copyWith(color: Colors.white),
                )),
          ],
        ),
      ),
      color: ptSecondaryColor(context),
    );
  }
}
