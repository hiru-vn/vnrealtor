import 'dart:io';

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

class CreatePostPage extends StatefulWidget {
  final PageController pageController;
  CreatePostPage(this.pageController);
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
        _contentC.text.trim(),
        _expirationDate?.toIso8601String(),
        _shareWith == 'public',
        _pos?.latitude,
        _pos?.longitude,
        _images,
        _videos);
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      _postBloc.post.insert(0, res.data);
      await widget.pageController.animateToPage(0,
          duration: Duration(milliseconds: 200), curve: Curves.decelerate);
      FocusScope.of(context).requestFocus(FocusNode());
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
      child: Scaffold(
        appBar: CreatePostPageAppBar(widget.pageController, _createPost),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 5),
              child: ImageButtonPicker(
                _allVideoAndImage,
                onUpdateListImg: (listImg) {},
                onAddImg: _upload,
                onRemoveImg: (file) {
                  _images.remove(file);
                  _videos.remove(file);
                  _allVideoAndImage.remove(file);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 8),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                // elevation: 5,
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 200),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: HashTagTextField(
                          maxLength: 400,
                          maxLines: null,
                          minLines: 5,
                          controller: _contentC,
                          onChanged: (value) => setState(() {}),
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
                  //         text: 'Đăng bài',
                  //         onPressed: _createPost,
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

class CreatePostPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PageController controller;
  final Function createPost;
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  CreatePostPageAppBar(this.controller, this.createPost);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            BackButton(
              onPressed: () {
                controller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              },
            ),
            SizedBox(
              width: 5,
            ),
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            FlatButton(
                color: ptPrimaryColor(context),
                onPressed: createPost,
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

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:datcao/modules/authentication/auth_bloc.dart';
// import 'package:datcao/modules/bloc/post_bloc.dart';
// import 'package:datcao/modules/post/pick_coordinates.dart';
// import 'package:datcao/share/import.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:datcao/utils/file_util.dart';

// class CreatePostPage extends StatefulWidget {
//   static navigate() {
//     navigatorKey.currentState.push(pageBuilder(CreatePostPage()));
//   }

//   @override
//   _CreatePostPageState createState() => _CreatePostPageState();
// }

// class _CreatePostPageState extends State<CreatePostPage> {
//   FocusNode _activityNode = FocusNode();
//   LatLng _pos;
//   DateTime _expirationDate;
//   String _shareWith = 'public';
//   TextEditingController _contentC = TextEditingController();
//   List<String> _videos = [];
//   List<String> _images = [];
//   List<String> _allVideoAndImage = [];
//   PostBloc _postBloc;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_postBloc == null) {
//       _postBloc = Provider.of<PostBloc>(context);
//     }
//     super.didChangeDependencies();
//   }

//   Future _createPost() async {
//     if (_contentC.text.trim() == '') {
//       showToast('Nội dung không được để trống', context);
//       return;
//     }
//     if (_allVideoAndImage.length == 0) {
//       showToast('Phải có ít nhất một hình ảnh hoặc video', context);
//       return;
//     }
//     showSimpleLoadingDialog(context);
//     final res = await _postBloc.createPost(
//         _contentC.text.trim(),
//         _expirationDate?.toIso8601String(),
//         _shareWith == 'public',
//         _pos?.latitude,
//         _pos?.longitude,
//         _images,
//         _videos);
//     await navigatorKey.currentState.maybePop();
//     if (res.isSuccess) {
//       _postBloc.post.insert(0, res.data);
//       await navigatorKey.currentState.maybePop();
//     } else {
//       showToast(res.errMessage, context);
//     }
//   }

//   Future _upload(String filePath) async {
//     try {
//       _allVideoAndImage.add(loadingGif);
//       setState(() {});
//       final res = await FileUtil.uploadFireStorage(File(filePath),
//           path:
//               'posts/user_${AuthBloc.instance.userModel.id}/${Formart.formatToDate(DateTime.now(), seperateChar: '-')}');
//       if (FileUtil.getFbUrlFileType(res) == FileType.image ||
//           FileUtil.getFbUrlFileType(res) == FileType.gif) {
//         _images.add(res);
//         _allVideoAndImage.add(res);
//       }
//       if (FileUtil.getFbUrlFileType(res) == FileType.video) {
//         _videos.add(res);
//         _allVideoAndImage.add(res);
//       }
//       _allVideoAndImage.remove(loadingGif);
//       setState(() {});
//     } catch (e) {
//       showToast(e.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: deviceWidth(context),
//       height: deviceHeight(context),
//       child: Material(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Scaffold(
//               appBar: AppBar1(
//                 automaticallyImplyLeading: true,
//                 title: '',
//               ),
//               body: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15).copyWith(top: 0),
//                       child: Text(
//                         'Hình ảnh/ Video',
//                         style: ptBigTitle().copyWith(
//                           color: Colors.black.withOpacity(0.7),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15).copyWith(top: 0),
//                       child: SizedBox(
//                         height: 110,
//                         child: ImageRowPicker(
//                           _allVideoAndImage,
//                           onUpdateListImg: (listImg) {},
//                           onAddImg: _upload,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: TextField(
//                           maxLength: 400,
//                           maxLines: null,
//                           controller: _contentC,
//                           style: ptBigBody().copyWith(color: Colors.black54),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Nội dung bài viết',
//                             hintStyle: ptTitle().copyWith(
//                                 color: Colors.black38, letterSpacing: 1),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]),
//             ),
//             Positioned(
//               bottom: 0,
//               width: deviceWidth(context),
//               child: Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(height: 10),
//                     _buildForm(),
//                     SizedBox(
//                       height: 3.0,
//                     ),
//                     ExpandRectangleButton(
//                       text: 'Đăng bài',
//                       onTap: _createPost,
//                     ),
//                     SizedBox(
//                       height: _activityNode.hasFocus
//                           ? MediaQuery.of(context).viewInsets.bottom
//                           : 0,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   _buildForm() {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode());
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(
//             height: 3,
//           ),
//           InkWell(
//             highlightColor: ptAccentColor(context),
//             splashColor: ptPrimaryColor(context),
//             onTap: () {
//               PickCoordinates.navigate().then((value) => setState(() {
//                     _pos = value;
//                     FocusScope.of(context).requestFocus(FocusNode());
//                   }));
//             },
//             child: CustomListTile(
//               leading: Icon(
//                 Icons.map,
//                 color: Colors.black54,
//               ),
//               title: Text(
//                 'Gắn vị trí',
//                 style: ptTitle(),
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (_pos != null) Text('Đã chọn'),
//                   SizedBox(width: 10),
//                   Icon(
//                     MdiIcons.arrowRightCircle,
//                     size: 20,
//                     color: Colors.black54,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Divider(
//             height: 3,
//           ),
//           CustomListTile(
//             onTap: () {
//               showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now().add(Duration(days: 30)),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(Duration(days: 500)),
//               ).then((value) => setState(() {
//                     _expirationDate = value;
//                     FocusScope.of(context).requestFocus(FocusNode());
//                   }));
//             },
//             leading: Icon(
//               Icons.date_range,
//               color: Colors.black54,
//             ),
//             title: Text(
//               'Ngày hết hạn',
//               style: ptTitle(),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(Formart.formatToDate(_expirationDate) ?? 'Không hết hạn'),
//                 // SizedBox(width: 10),
//                 //   Icon(
//                 //     MdiIcons.calendar,
//                 //     size: 20,
//                 //     color: Colors.black54,
//                 //   ),
//               ],
//             ),
//           ),
//           Divider(
//             height: 3,
//           ),
//           CustomListTile(
//             leading: Icon(
//               Icons.language,
//               color: Colors.black54,
//             ),
//             title: Text(
//               'Chia sẻ với',
//               style: ptTitle(),
//             ),
//             trailing: _shareWith != null
//                 ? Text(_shareWith == 'public'
//                     ? 'Tất cả mọi người'
//                     : 'Chỉ bạn bè mới nhìn thấy')
//                 : Text('Chọn'),
//             onTap: () {
//               pickList(context, title: 'Chia sẻ với', onPicked: (value) {
//                 setState(() {
//                   _shareWith = value;
//                   FocusScope.of(context).requestFocus(FocusNode());
//                 });
//               }, options: [
//                 PickListItem('public', 'Tất cả mọi người'),
//                 PickListItem('friend', 'Chỉ bạn bè mới nhìn thấy'),
//               ], closeText: 'Xong');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
