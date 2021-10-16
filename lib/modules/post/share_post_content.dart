import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/post/tag_user_list_page.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:hashtagable/hashtagable.dart';

class SharePostGroupContent extends StatefulWidget {
  final GroupModel groupModel;
  final PostModel? post;
  SharePostGroupContent(this.post, this.groupModel);
  @override
  _SharePostGroupContentState createState() => _SharePostGroupContentState();
}

class _SharePostGroupContentState extends State<SharePostGroupContent> {
  FocusNode _activityNode = FocusNode();
  TextEditingController _contentC = TextEditingController();
  PostBloc? _postBloc;
  bool isProcess = false;
  List<UserModel>? _tagUsers = [];

  get group => widget.groupModel;
  get post => widget.post;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _sharePost() async {
    await navigatorKey.currentState!.maybePop([
      _contentC.text,
      _tagUsers?.map((e) => e.id).toList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Chia sẻ lên nhóm',
              style: ptBigBody().copyWith(color: Colors.black)),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FlatButton(
                    color: ptPrimaryColor(context),
                    onPressed: _sharePost,
                    child: Text(
                      'Đăng',
                      style: ptTitle().copyWith(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
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
                        ((AuthBloc.instance.userModel!.avatar != null)
                            ? CachedNetworkImageProvider(group.coverImage)
                            : AssetImage('assets/image/default_avatar.png')) as ImageProvider<Object>?,
                    child: VerifiedIcon(
                      AuthBloc.instance.userModel?.role,
                      10,
                      isPage: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: AuthBloc.instance.userModel!.name ?? '',
                            style: ptTitle(),
                          ),
                          TextSpan(
                            text: '  ▶  ',
                            style: ptTitle(),
                          ),
                          TextSpan(
                            text: group?.name ?? '',
                            style: ptTitle(),
                          ),
                        ])),
                        Row(
                          children: [
                            Text(
                              Formart.formatToWeekTime(DateTime.now())!,
                              style: ptTiny().copyWith(color: Colors.black54),
                            ),
                            SizedBox(width: 12),
                            if (group.privacy) ...[
                              SizedBox(
                                height: 13,
                                width: 13,
                                child: Image.asset('assets/icon/private.png',
                                    color: Colors.black54),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Nhóm kín',
                                style: ptTiny().copyWith(color: Colors.black54),
                              )
                            ] else ...[
                              SizedBox(
                                height: 13,
                                width: 13,
                                child: Image.asset('assets/icon/public.png',
                                    color: Colors.black54),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Công khai',
                                style: ptTiny().copyWith(color: Colors.black54),
                              )
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
                          maxLines: 5,
                          minLines: 3,
                          controller: _contentC,
                          onChanged: (value) => setState(() {}),
                          basicStyle:
                              ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nêu cảm nghĩ hoặc để trống...',
                            hintStyle: ptTitle().copyWith(
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
                                        _postBloc!.hasTags!
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
                                      _postBloc!.hasTags!
                                          .where((element) => !_contentC.text
                                              .contains(element['value']))
                                          .toList()[index]['value']
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _postBloc!.hasTags!
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
            if ((_tagUsers?.length ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Gắn thẻ: ',
                      style: ptSmall().copyWith(color: Colors.black)),
                  ..._tagUsers?.map(
                    (e) => TextSpan(
                        text: '${e.name}, ',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => ProfileOtherPage.navigate(e),
                        style: ptSmall().copyWith(fontStyle: FontStyle.italic)),
                  )??[]
                ])),
              ),
            SizedBox(
              height: 5.0,
            ),
            Divider(height: 1),
            GestureDetector(
              onTap: () {
                audioCache.play('tab3.mp3');
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
              child: Row(
                children: [
                  SizedBox(width: 12, height: 50),
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/icon/tag_friend.png'),
                      )),
                  SizedBox(width: 4),
                  Text('Gắn thẻ bạn bè'),
                ],
              ),
            ),
            Divider(height: 1),
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

class SharePostPageContent extends StatefulWidget {
  final PagesCreate page;
  final PostModel? post;
  SharePostPageContent(this.post, this.page);
  @override
  _SharePostPageContentState createState() => _SharePostPageContentState();
}

class _SharePostPageContentState extends State<SharePostPageContent> {
  FocusNode _activityNode = FocusNode();
  TextEditingController _contentC = TextEditingController();
  PostBloc? _postBloc;
  bool isProcess = false;
  List<UserModel>? _tagUsers = [];

  PagesCreate get page => widget.page;
  PostModel? get post => widget.post;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _sharePost() async {
    await navigatorKey.currentState!.maybePop([
      _contentC.text,
      _tagUsers?.map((e) => e.id).toList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Chia sẻ lên trang',
              style: ptBigBody().copyWith(color: Colors.black)),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FlatButton(
                    color: ptPrimaryColor(context),
                    onPressed: _sharePost,
                    child: Text(
                      'Đăng',
                      style: ptTitle().copyWith(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
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
                        ((AuthBloc.instance.userModel!.avatar != null)
                            ? CachedNetworkImageProvider(page.avartar!)
                            : AssetImage('assets/image/default_avatar.png')) as ImageProvider<Object>?,
                    child: VerifiedIcon(
                      AuthBloc.instance.userModel?.role,
                      10,
                      isPage: true,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: AuthBloc.instance.userModel!.name ?? '',
                            style: ptTitle(),
                          ),
                          TextSpan(
                            text: ' đăng lên ',
                            style: ptBody(),
                          ),
                          TextSpan(
                            text: page.name ?? '',
                            style:
                                ptBody().copyWith(fontWeight: FontWeight.w500),
                          ),
                        ])),
                        Row(
                          children: [
                            Text(
                              Formart.formatToWeekTime(DateTime.now())!,
                              style: ptTiny().copyWith(color: Colors.black54),
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              height: 13,
                              width: 13,
                              child: Image.asset('assets/icon/public.png',
                                  color: Colors.black54),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Công khai',
                              style: ptTiny().copyWith(color: Colors.black54),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
                          maxLines: 5,
                          minLines: 3,
                          controller: _contentC,
                          onChanged: (value) => setState(() {}),
                          basicStyle:
                              ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nêu cảm nghĩ hoặc để trống...',
                            hintStyle: ptTitle().copyWith(
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
                                        _postBloc!.hasTags!
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
                                      _postBloc!.hasTags!
                                          .where((element) => !_contentC.text
                                              .contains(element['value']))
                                          .toList()[index]['value']
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _postBloc!.hasTags!
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
            if ((_tagUsers?.length ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Gắn thẻ: ',
                      style: ptSmall().copyWith(color: Colors.black)),
                  ..._tagUsers?.map(
                    (e) => TextSpan(
                        text: '${e.name}, ',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => ProfileOtherPage.navigate(e),
                        style: ptSmall().copyWith(fontStyle: FontStyle.italic)),
                  )??[]
                ])),
              ),
            SizedBox(
              height: 5.0,
            ),
            Divider(height: 1),
            GestureDetector(
              onTap: () {
                audioCache.play('tab3.mp3');
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
              child: Row(
                children: [
                  SizedBox(width: 12, height: 50),
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/icon/tag_friend.png'),
                      )),
                  SizedBox(width: 4),
                  Text('Gắn thẻ bạn bè'),
                ],
              ),
            ),
            Divider(height: 1),
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
