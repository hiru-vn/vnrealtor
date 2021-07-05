import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/widget/page_create_post_appbar.dart';
import 'package:datcao/modules/post/info_post_page.dart';
import 'package:datcao/modules/post/tag_user_list_page.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:flutter/gestures.dart';
import 'package:path/path.dart' as Path;
import 'package:datcao/modules/inbox/import/detail_media.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/post/pick_coordinates.dart';
import 'package:datcao/share/import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class PageCreatePostPage extends StatefulWidget {
  final PagesCreate page;
  const PageCreatePostPage({this.page});

  static Future navigate(PagesCreate page) {
    return navigatorKey.currentState.push(
      pageBuilder(
        PageCreatePostPage(
          page: page,
        ),
      ),
    );
  }

  @override
  _CreatePageCreatePostPageState createState() =>
      _CreatePageCreatePostPageState();
}

class _CreatePageCreatePostPageState extends State<PageCreatePostPage> {
  FocusNode _activityNode = FocusNode();
  LatLng _pos;
  String _placeName;
  DateTime _expirationDate;
  String _shareWith = 'public';
  TextEditingController _contentC = TextEditingController();
  List<String> _cacheMedias = [];
  List<String> _cachePic = [];
  List<String> _urlMedias = [];
  PagesBloc _pagesBloc;
  List<LatLng> _polygonPoints = [];
  List<UserModel> _tagUsers = [];
  double _price;
  double _area;
  String _type;
  String _need;

  String get pageId => widget.page.id;
  PagesCreate get page => widget.page;

  @override
  void didChangeDependencies() {
    if (_pagesBloc == null) {
      _pagesBloc = Provider.of<PagesBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _createPagePost() async {
    if (_pagesBloc.isCreatePostLoading) return;
    try {
      _pagesBloc.isCreatePostLoading = true;
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

      final res = await _pagesBloc.createPagePost(
        pageId,
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
            .where((path) => FileUtil.getFbUrlFileType(path) == FileType.video)
            .toList(),
        _polygonPoints,
        _tagUsers.map((e) => e.id).toList(),
        _type,
        _need,
        _area,
        _price,
      );
      navigatorKey.currentState.maybePop();
      if (res.isSuccess) {
        navigatorKey.currentState.pop();
        FocusScope.of(context).requestFocus(FocusNode());
        _expirationDate = null;
        _contentC.clear();
        _cacheMedias.clear();
        _cachePic.clear();
        Navigator.pop(context);
      } else {
        showToast(res.errMessage, context);
      }

      Future.delayed(Duration(seconds: 2), () => _pagesBloc?.notifyListeners());
    } catch (e) {
      showToast(e.toString(), context);
    } finally {
      _pagesBloc.isCreatePostLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth(context),
      height: deviceHeight(context),
      child: Scaffold(
        appBar: PageCreatePostAppBar(_createPagePost, true),
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
                        (page.avartar != null && page.avartar != 'null')
                            ? CachedNetworkImageProvider(page.avartar)
                            : AssetImage('assets/image/default_avatar.png'),
                    child: VerifiedIcon(
                      AuthBloc.instance.userModel?.role,
                      10,
                      isPage: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.name ?? '',
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
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return InfoPostPage();
                              },
                              backgroundColor: Colors.transparent,
                            ).then((value) {
                              if (value != null && value.length == 4) {
                                setState(() {
                                  _type = value[0];
                                  _need = value[1];
                                  _area = value[2];
                                  _price = value[3];
                                });
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ptPrimaryColor(context),
                            ),
                            padding: EdgeInsets.all(6),
                            child: Row(
                              children: [
                                Icon(_area == null ? Icons.add : Icons.check,
                                    size: 15, color: Colors.white),
                                SizedBox(width: 3),
                                Text('Mô tả chi tiết',
                                    style: ptSmall()
                                        .copyWith(color: Colors.white)),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 30,
              width: deviceWidth(context),
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
                            _pagesBloc.hasTags
                                .where((element) =>
                                    !_contentC.text.contains(element['value']))
                                .toList()[index]['value']
                                .toString();
                        _contentC.selection = TextSelection.fromPosition(
                            TextPosition(offset: _contentC.text.length));
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
                          _pagesBloc.hasTags
                              .where((element) =>
                                  !_contentC.text.contains(element['value']))
                              .toList()[index]['value']
                              .toString(),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _pagesBloc.hasTags
                    .where(
                        (element) => !_contentC.text.contains(element['value']))
                    .toList()
                    .length,
                scrollDirection: Axis.horizontal,
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
                            _polygonPoints = value[2];
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
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return TagUserListPage('Gắn thẻ');
                        },
                        backgroundColor: Colors.transparent,
                      ).then((value) => setState(() {
                            _tagUsers = value ?? [];
                          }));
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
            if ((_tagUsers?.length ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Gắn thẻ: ',
                      style: ptSmall().copyWith(color: Colors.black)),
                  ..._tagUsers.map(
                    (e) => TextSpan(
                        text: '${e.name}, ',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => ProfileOtherPage.navigate(e),
                        style: ptSmall().copyWith(fontStyle: FontStyle.italic)),
                  )
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
