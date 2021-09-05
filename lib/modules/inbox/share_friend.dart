import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_model.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'import/media_group.dart';
import 'inbox_bloc.dart';

class ShareFriendMedias extends StatefulWidget {
  static Future navigate(List<String> medias) {
    // navigatorKey in MaterialApp
    return navigatorKey.currentState
        .push(pageBuilder(ShareFriendMedias(medias)));
  }

  final List<String> medias;
  const ShareFriendMedias(this.medias, {Key key}) : super(key: key);

  @override
  _ShareFriendMediasState createState() => _ShareFriendMediasState();
}

class _ShareFriendMediasState extends State<ShareFriendMedias> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  List<UserModel> friends;
  List<FbInboxGroupModel> groups;
  List<UserModel> tagUsers = [];
  List<FbInboxGroupModel> tagGroups = [];
  String search = '';
  String name = '';
  List<String> medias;
  TextEditingController _textC = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
      _userBloc = Provider.of(context);
      _userBloc.getListUserIn(_authBloc.userModel.friendIds).then((value) {
        if (value.isSuccess) {
          setState(() {
            friends = value.data;
          });
        } else
          showToast('Có lỗi khi lấy danh sách, vui lòng đóng trang và thử lại',
              context);
      });
      // InboxBloc.instance.init();
      groups = InboxBloc.instance.groupInboxList.sublist(
          0,
          InboxBloc.instance.groupInboxList.length > 10
              ? 9
              : InboxBloc.instance.groupInboxList.length);
    }
    super.didChangeDependencies();
  }

  _tapUser(UserModel user) {
    setState(() {
      if (!tagUsers.contains(user))
        tagUsers.add(user);
      else
        tagUsers.remove(user);
    });
  }

  _tapGroup(FbInboxGroupModel group) {
    setState(() {
      if (!tagGroups.contains(group))
        tagGroups.add(group);
      else
        tagGroups.remove(group);
    });
  }

  _onShare() async {
    if (tagUsers.length < 1 && tagGroups.length < 1) {
      showToast('Cần chọn ít nhất 1 người', context);
      return;
    }
    showWaitingDialog(context);
    try {
      await Future.wait([
        ...tagUsers.map((e) {
          final list = [e.id, _authBloc.userModel.id];
          list.sort();
          final groupId = list.join("-");
          InboxBloc.instance.updateGroupOnMessage(
              groupId,
              _authBloc.userModel.name,
              DateTime.now(),
              AuthBloc.instance.userModel.name +
                  'đã chia sẻ ${widget.medias.length} ảnh/video',
              [],
              [AuthBloc.instance.userModel.id]);
          if (_textC.text != '') {
            InboxBloc.instance.addMessage(
                groupId,
                _textC.text,
                DateTime.now(),
                _authBloc.userModel.id,
                _authBloc.userModel.name,
                _authBloc.userModel.avatar);
          }
          return InboxBloc.instance.addMessage(
              groupId,
              '',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar,
              filePaths: widget.medias);
        }),
        ...tagGroups.map((e) {
          InboxBloc.instance.updateGroupOnMessage(
              e.id,
              _authBloc.userModel.name,
              DateTime.now(),
              AuthBloc.instance.userModel.name +
                  'đã chia sẻ ${widget.medias.length} ảnh/video',
              [],
              [AuthBloc.instance.userModel.id]);
          if (_textC.text != '') {
            InboxBloc.instance.addMessage(
                e.id,
                _textC.text,
                DateTime.now(),
                _authBloc.userModel.id,
                _authBloc.userModel.name,
                _authBloc.userModel.avatar);
          }
          return InboxBloc.instance.addMessage(
              e.id,
              '',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar,
              filePaths: widget.medias);
        }),
      ]);

      showToast('Đã gửi đến ${tagUsers.length + tagGroups.length} người dùng',
          context,
          isSuccess: true);
      closeLoading();
    } catch (e) {
      showToast(e.toString(), context);
    } finally {
      navigatorKey.currentState.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chia sẻ đến',
          style: ptBigBody().copyWith(color: Colors.black87),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                _onShare();
                audioCache.play('tab3.mp3');
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(10).copyWith(bottom: 13),
                child: Text('Gửi đi', style: ptBody()),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Center(
              child: Transform.scale(
                scale: 0.7,
                child: SizedBox(
                  width: deviceWidth(context) * 0.6,
                  child: MediaGroupWidgetNetwork(
                    urls: widget.medias,
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.search, color: Colors.black45)),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() {
                      search = val;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên',
                        border: InputBorder.none,
                        hintStyle: ptBody()),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.messenger_outline_rounded,
                        color: Colors.black45)),
                Expanded(
                  child: TextField(
                    controller: _textC,
                    decoration: InputDecoration(
                        hintText: 'Lời nhắn',
                        border: InputBorder.none,
                        hintStyle: ptBody()),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Hội thoại gần đây',
                    style: ptTitle().copyWith(
                        color: Colors.black, fontSize: 13, letterSpacing: 0.2),
                  ),
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Column(
                  children: [
                    if (groups != null)
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groups
                            .where((e) => e.users.any((u) => u.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim())))
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final group = groups
                              .where((e) => e.users.any((u) => u.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase().trim())))
                              .toList()[index];
                          return _buildGroupItem(
                              group,
                              tagGroups.contains(group),
                              () => _tapGroup(group));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              height: 1,
                              color: Colors.black12.withOpacity(0.3));
                        },
                      )
                    else
                      _buildUserLoading()
                  ],
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Bạn bè',
                    style: ptTitle().copyWith(
                        color: Colors.black, fontSize: 13, letterSpacing: 0.2),
                  ),
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Column(
                  children: [
                    if (friends != null)
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: friends
                            .where((e) => e.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim()))
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final friend = friends
                              .where((e) => e.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))
                              .toList()[index];
                          return _buildUserItem(
                              friend,
                              tagUsers.contains(friend),
                              () => _tapUser(friend));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              height: 1,
                              color: Colors.black12.withOpacity(0.3));
                        },
                      )
                    else
                      _buildUserLoading()
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildUserItem(UserModel user, bool isSelect, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: user.avatar != null
                ? CachedNetworkImageProvider(user.avatar)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(user.name, style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildGroupItem(FbInboxGroupModel group, bool isSelect, Function onTap) {
    String nameGroup = group.users
        .where((element) => element.id != _authBloc.userModel.id)
        .toList()
        .map((e) => e.name)
        .join(', ');
    if (group.pageName != null &&
        group.pageId != null &&
        !PagesBloc.instance.pageCreated.any((e) => e.id == group.pageId))
      nameGroup = group.pageName;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: group.image != null
                ? CachedNetworkImageProvider(group.image)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(nameGroup ?? '', style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildUserLoading() {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      items: 3,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}

class ShareFriendPost extends StatefulWidget {
  static Future navigate(PostModel post) {
    // navigatorKey in MaterialApp
    return navigatorKey.currentState.push(pageBuilder(ShareFriendPost(post)));
  }

  final PostModel post;
  const ShareFriendPost(this.post, {Key key}) : super(key: key);

  @override
  _ShareFriendPostState createState() => _ShareFriendPostState();
}

class _ShareFriendPostState extends State<ShareFriendPost> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  List<UserModel> friends;
  List<FbInboxGroupModel> groups;
  List<UserModel> tagUsers = [];
  List<FbInboxGroupModel> tagGroups = [];
  String search = '';
  String name = '';
  List<String> medias;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
      _userBloc = Provider.of(context);
      _userBloc.getListUserIn(_authBloc.userModel.friendIds).then((value) {
        if (value.isSuccess) {
          setState(() {
            friends = value.data;
          });
        } else
          showToast('Có lỗi khi lấy danh sách, vui lòng đóng trang và thử lại',
              context);
      });
      groups = InboxBloc.instance.groupInboxList.sublist(
          0,
          InboxBloc.instance.groupInboxList.length > 10
              ? 9
              : InboxBloc.instance.groupInboxList.length);
    }
    super.didChangeDependencies();
  }

  _tapUser(UserModel user) {
    setState(() {
      if (!tagUsers.contains(user))
        tagUsers.add(user);
      else
        tagUsers.remove(user);
    });
  }

  _tapGroup(FbInboxGroupModel group) {
    setState(() {
      if (!tagGroups.contains(group))
        tagGroups.add(group);
      else
        tagGroups.remove(group);
    });
  }

  _onShare() async {
    if (tagUsers.length < 1 && tagGroups.length < 1) {
      showToast('Cần chọn ít nhất 1 người', context);
      return;
    }
    showWaitingDialog(context);
    try {
      await Future.wait([
        ...tagUsers.map((e) {
          final list = [e.id, _authBloc.userModel.id];
          list.sort();
          final groupId = list.join("-");
          InboxBloc.instance.addMessage(
              groupId,
              widget.post.dynamicLink.shortLink + '\n${widget.post.content}',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar);

          InboxBloc.instance.updateGroupOnMessage(
              groupId,
              _authBloc.userModel.name,
              DateTime.now(),
              AuthBloc.instance.userModel.name + 'đã chia sẻ 1 bài viết',
              [],
              [AuthBloc.instance.userModel.id]);

          return InboxBloc.instance.addMessage(
              e.id,
              '',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar,
              filePaths: widget.post.mediaPosts.map((e) => e.url).toList());
        }),
        ...tagGroups.map((e) {
          InboxBloc.instance.addMessage(
              e.id,
              widget.post.dynamicLink.shortLink + '\n${widget.post.content}',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar);

          InboxBloc.instance.updateGroupOnMessage(
            e.id,
            _authBloc.userModel.name,
            DateTime.now(),
            AuthBloc.instance.userModel.name + 'đã chia sẻ 1 bài viết',
            [],
            [AuthBloc.instance.userModel.id],
          );
          return InboxBloc.instance.addMessage(
              e.id,
              '',
              DateTime.now(),
              _authBloc.userModel.id,
              _authBloc.userModel.name,
              _authBloc.userModel.avatar,
              filePaths: widget.post.mediaPosts.map((e) => e.url).toList());
        }),
      ]);

      showToast('Đã gửi đến ${tagUsers.length + tagGroups.length} người dùng',
          context,
          isSuccess: true);
      closeLoading();
    } catch (e) {
      showToast(e.toString(), context);
    } finally {
      navigatorKey.currentState.maybePop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chia sẻ đến',
          style: ptBigBody().copyWith(color: Colors.black87),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                _onShare();
                audioCache.play('tab3.mp3');
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(10).copyWith(bottom: 13),
                child: Text('Gửi đi', style: ptBody()),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Center(
              child: Transform.scale(
                scale: 0.8,
                child: PostWidget(
                  widget.post,
                  isSharedPost: true,
                ),
              ),
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.search, color: Colors.black45)),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() {
                      search = val;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên',
                        border: InputBorder.none,
                        hintStyle: ptBody()),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Hội thoại gần đây',
                    style: ptTitle().copyWith(
                        color: Colors.black, fontSize: 13, letterSpacing: 0.2),
                  ),
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Column(
                  children: [
                    if (groups != null)
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: groups
                            .where((e) => e.users.any((u) => u.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim())))
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final group = groups
                              .where((e) => e.users.any((u) => u.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase().trim())))
                              .toList()[index];
                          return _buildGroupItem(
                              group,
                              tagGroups.contains(group),
                              () => _tapGroup(group));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              height: 1,
                              color: Colors.black12.withOpacity(0.3));
                        },
                      )
                    else
                      _buildUserLoading()
                  ],
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Bạn bè',
                    style: ptTitle().copyWith(
                        color: Colors.black, fontSize: 13, letterSpacing: 0.2),
                  ),
                ),
                Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                Column(
                  children: [
                    if (friends != null)
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: friends
                            .where((e) => e.name
                                .toLowerCase()
                                .contains(search.toLowerCase().trim()))
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          final friend = friends
                              .where((e) => e.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))
                              .toList()[index];
                          return _buildUserItem(
                              friend,
                              tagUsers.contains(friend),
                              () => _tapUser(friend));
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                              height: 1,
                              color: Colors.black12.withOpacity(0.3));
                        },
                      )
                    else
                      _buildUserLoading()
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildUserItem(UserModel user, bool isSelect, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: user.avatar != null
                ? CachedNetworkImageProvider(user.avatar)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(user.name, style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildGroupItem(FbInboxGroupModel group, bool isSelect, Function onTap) {
    String nameGroup = group.users
        .where((element) => element.id != _authBloc.userModel.id)
        .toList()
        .map((e) => e.name)
        .join(', ');
    if (group.pageName != null &&
        group.pageId != null &&
        !PagesBloc.instance.pageCreated.any((e) => e.id == group.pageId))
      nameGroup = group.pageName;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
        audioCache.play('tab3.mp3');
      },
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: group.image != null
                ? CachedNetworkImageProvider(group.image)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(nameGroup ?? '', style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildUserLoading() {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      items: 3,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}
