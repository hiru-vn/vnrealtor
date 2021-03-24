import 'dart:async';
import 'dart:io';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/import/launch_url.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/function/dialog.dart';
import 'package:datcao/share/function/show_toast.dart';
import 'package:datcao/utils/call_kit.dart';
import 'package:flutter/material.dart';
import './import/dash_chat/dash_chat.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:datcao/navigator.dart';
import 'google_map_widget.dart';
import 'import/app_bar.dart';
import 'import/color.dart';
import 'import/font.dart';
import 'import/image_picker.dart';
import 'import/image_view.dart';
import 'import/page_builder.dart';
import 'import/video_view.dart';
import 'inbox_bloc.dart';
import 'inbox_model.dart';
import 'video_call_page.dart';
import 'voice_call_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './import/media_group.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';

class InboxChat extends StatefulWidget {
  final FbInboxGroupModel group;
  final String title;

  InboxChat(this.group, this.title);
  static Future navigate(FbInboxGroupModel group, String title) {
    // navigatorKey in MaterialApp
    return navigatorKey.currentState.push(pageBuilder(InboxChat(group, title)));
  }

  @override
  _InboxChatState createState() => _InboxChatState();
}

class _InboxChatState extends State<InboxChat> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final List<ChatUser> _users = [];
  final List<FbInboxUserModel> _fbUsers = [];
  List<UserModel> _severUsers = [];
  final TextEditingController _chatC = TextEditingController();
  final userColor = HexColor('#4D94FF');

  List<String> _files = [];
  InboxBloc _inboxBloc;
  AuthBloc _authBloc;
  ScrollController scrollController = ScrollController();
  bool shouldShowLoadEarlier = true;
  bool reachEndList = false;
  bool onLoadMore = false;
  Stream<QuerySnapshot> _incomingMessageStream;
  StreamSubscription _incomingMessageListener;
  GlobalKey<State<StatefulWidget>> moreBtnKey =
      GlobalKey<State<StatefulWidget>>();
  FocusNode _focusNode = FocusNode();
  List<ChatMessage> messages = List<ChatMessage>();

  var i = 0;
  bool showEmoj = false;

  @override
  void didChangeDependencies() {
    if (_inboxBloc == null || _authBloc == null) {
      _inboxBloc = Provider.of<InboxBloc>(context);
      _authBloc = Provider.of<AuthBloc>(
          context); // this just to get userId, avatar, name. you can replace this with your params
      initMenu();
      loadUsers();
      loadFirst20Message();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus)
        setState(() {
          showEmoj = false;
        });
    });
    for (final user in widget.group.users) {
      _users.add(ChatUser(
        uid: user.id,
        name: user.name,
        // containerColor: user.id == AuthBloc.instance.userModel.id
        //     ? HexColor('#4D94FF')
        //     : Colors.grey[200]
      ));
    }
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _incomingMessageListener?.cancel();
    _focusNode.dispose();
  }

  Future<void> loadUsers() async {
    final fbUsers = widget.group.users;
    _fbUsers.addAll(fbUsers);
    for (final fbUser in fbUsers) {
      final user = _users.firstWhere((user) => user.uid == fbUser.id);
      user.avatar = fbUser.image;
      user.name = fbUser.name;
    }
    loadUsersFromSever();
  }

  Future loadUsersFromSever() async {
    final res = await UserBloc.instance
        .getListUserIn(widget.group.users.map((e) => e.id).toList());
    if (res.isSuccess) {
      _severUsers.clear();
      _severUsers.addAll(res.data);
      _users.forEach((i) {
        _severUsers.forEach((j) {
          if (i.uid == j.id) {
            i.avatar = j.avatar;
            i.name = j.name;
          }
        });
      });
    }
    if (mounted) setState(() {});
  }

  Future<void> loadFirst20Message() async {
    // get list first 20 message by group id
    final fbMessages = await _inboxBloc.get20Messages(widget.group.id);
    if (fbMessages.isEmpty) return;
    messages.addAll(fbMessages.map((element) {
      return ChatMessage(
          user: _users.firstWhere((user) => user.uid == element.uid),
          text: element.text,
          id: element.id,
          image:
              'assets/image/loading.gif', // temp image, widget need temp string to build image builder
          createdAt: DateTime.tryParse(element.date),
          customProperties: <String, dynamic>{
            'long': element.location?.longitude,
            'lat': element.location?.latitude,
            'files': element.filePaths ?? [],
          });
    }).toList());
    Future.delayed(Duration(milliseconds: 100), () => jumpToEnd());
    Future.delayed(Duration(milliseconds: 500), () => jumpToEnd());

    // init stream with last messageId
    _incomingMessageStream = await _inboxBloc.getStreamIncomingMessages(
        widget.group.id,
        fbMessages.length > 0 ? fbMessages[fbMessages.length - 1].id : null);
    // add listener to cancel listener, or else will cause bug setState when dispose state
    _incomingMessageListener = _incomingMessageStream.listen(onIncomingMessage);
  }

  void onIncomingMessage(event) async {
    print('new message!!!');
    final newMessages = event as QuerySnapshot;
    final fbMessages = newMessages.docs
        .map((e) => FbInboxMessageModel.fromJson(e.data(), e.id))
        .toList();
    // do not add message come for this user
    fbMessages.removeWhere((message) => message.uid == _authBloc.userModel.id);
    if (fbMessages.isEmpty) return;
    // add incoming message to first
    messages.addAll(fbMessages.map((element) {
      return ChatMessage(
          user: _users.firstWhere((user) => user.uid == element.uid),
          text: element.text,
          id: element.id,
          createdAt: DateTime.tryParse(element.date),
          image:
              'assets/image/loading.gif', // temp image, widget need temp string to build image builder

          customProperties: <String, dynamic>{
            'long': element.location?.longitude,
            'lat': element.location?.latitude,
            'files': element.filePaths ?? [],
          });
    }).toList());

    // now update stream with new last message id
    _incomingMessageStream = await _inboxBloc.getStreamIncomingMessages(
        widget.group.id, fbMessages[fbMessages.length - 1].id);
    // refresh lisener to prevent bug
    _incomingMessageListener?.cancel();
    _incomingMessageListener = _incomingMessageStream.listen(onIncomingMessage);

    if (mounted) setState(() {});
    // new message! scroll to bottom to see them
    Future.delayed(Duration(milliseconds: 100), () {
      if (_chatViewKey.currentState.scrollController.position.pixels >
          _chatViewKey.currentState.scrollController.position.maxScrollExtent -
              200) scrollToEnd();
    });
  }

  Future<void> loadNext20Message() async {
    if (reachEndList) return; // none to fetch
    // get list first 20 message by group id
    if (mounted)
      setState(() {
        onLoadMore = true;
      });
    final fbMessages = await _inboxBloc.get20Messages(widget.group.id,
        lastMessageId: messages[0].id);
    if (mounted)
      setState(() {
        onLoadMore = false;
      });
    if (fbMessages.length < 20) {
      // if return messages is smaller than 20 then it must have get everything
      if (mounted)
        setState(() {
          reachEndList = true;
        });
      if (fbMessages.length == 0) return; //if zero do not insert or setState
    }
    messages.insertAll(
        0,
        fbMessages.map((element) {
          return ChatMessage(
            user: _users.firstWhere((user) => user.uid == element.uid),
            text: element.text,
            id: element.id,
            image:
                'assets/image/loading.gif', // temp image, widget need temp string to build image builder
            customProperties: <String, dynamic>{
              'long': element.location?.longitude,
              'lat': element.location?.latitude,
              'files': element.filePaths ?? [],
            },
            createdAt: DateTime.tryParse(element.date),
          );
        }).toList());
    if (mounted) setState(() {});
  }

  void onSend(ChatMessage message) {
    List<String> _tempFiles = [];
    _tempFiles.addAll(_files);
    if (_tempFiles.length == 0 && message.text.trim() == '') return;
    if (_files.length > 0) {
      // add a loading gif
      if (message.text.trim() != '') {
        // send message text first then send image or video ...
        ChatMessage copyMessage = ChatMessage(
          // do this because every message gen unique id
          text: message.text,
          user: message.user,
          createdAt: message.createdAt,
        );
        setState(() {
          messages.add(copyMessage);
        });
        _inboxBloc.addMessage(
            widget.group.id,
            message.text,
            message.createdAt,
            _authBloc.userModel.id,
            _authBloc.userModel.name,
            _authBloc.userModel.avatar);
        message.text = '';
      }
      if (message.customProperties == null)
        message.customProperties = <String, dynamic>{};
      _files.forEach((path) {
        if (message.customProperties['cache_file_paths'] == null) {
          message.customProperties['cache_file_paths'] = <String>[];
        }
        if (FileUtil.getFilePathType(path) == FileType.video) {
          message.image = 'assets/image/loading.gif'; // temp
          message.customProperties['cache_file_paths'].add(path);
        }
        if (FileUtil.getFilePathType(path) == FileType.image) {
          message.image = 'assets/image/loading.gif'; // temp
          message.customProperties['cache_file_paths'].add(path);
        }
      });
    }
    // setState(() {
    _files.clear();
    messages.add(message);
    // });
    Future.delayed(Duration(seconds: 100), () => scrollToEnd());

    String text = message.text;

    _updateGroupPageText(
        widget.group.id,
        _authBloc.userModel.name,
        text,
        message.createdAt,
        message.user.avatar,
        [...widget.group.readers, AuthBloc.instance.userModel.id]);

    if (_tempFiles.length == 0) {
      _inboxBloc.addMessage(
          widget.group.id,
          text,
          message.createdAt,
          _authBloc.userModel.id,
          _authBloc.userModel.name,
          _authBloc.userModel.avatar);
    } else {
      Future.wait(
        _tempFiles.map((e) => FileUtil.uploadFireStorage(
              File(e),
              path:
                  'chats/group_${widget.group.id}/user_${_authBloc.userModel.id}',
              resizeWidth: 480,
            )),
      ).then((value) {
        // if (mounted)
        //   setState(() {
        //     messages
        //         .firstWhere((m) => m.id == message.id)
        //         ?.customProperties['files'] = value;
        //   });
        _inboxBloc.addMessage(
            widget.group.id,
            text,
            message.createdAt,
            _authBloc.userModel.id,
            _authBloc.userModel.name,
            _authBloc.userModel.avatar,
            filePaths: value,
            location: message.customProperties['lat'] != null
                ? LatLng(message.customProperties['lat'],
                    message.customProperties['long'])
                : null);
      });
    }
  }

  _updateGroupPageText(String groupid, String lastUser, String lastMessage,
      DateTime time, String image, List<String> readers) {
    if (lastMessage.length > 30) {
      lastMessage = lastMessage.substring(0, 30) + "...";
    }

    _inboxBloc.updateGroupOnMessage(groupid, lastUser, time, lastMessage, image,
        _severUsers.map((e) => e.avatar).toList(), readers);
  }

  void scrollToEnd() {
    _chatViewKey.currentState.scrollController
      ..animateTo(
        _chatViewKey.currentState.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
  }

  void jumpToEnd() {
    _chatViewKey.currentState.scrollController
      ..jumpTo(
        _chatViewKey.currentState.scrollController.position.maxScrollExtent,
      );
  }

  Future _onFilePick(String path) async {
    // if ((await File(path).length()) > 20000000) {
    //   showToast(
    //       'File có kích thước quá lớn, vui lòng upload file có dung lương < 20MB',
    //       context);
    //   return;
    // }
    if (path != null) {
      if (mounted)
        setState(() {
          _files.add(path);
        });
    } else {
      // User canceled the picker
    }
  }

  void _onMultiFilePick(List<String> paths) {
    if (paths != null) {
      if (mounted)
        setState(() {
          _files.addAll(paths);
        });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
        automaticallyImplyLeading: true,
        bgColor: Colors.white,
        elevation: 2,
        actions: [
          // Center(
          //   child: AnimatedSearchBar(
          //     width: MediaQuery.of(context).size.width / 2,
          //     height: 40,
          //   ),
          // ),
          IconButton(
              key: moreBtnKey,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black.withOpacity(0.7),
              ),
              onPressed: () {
                menu.show(widgetKey: moreBtnKey);
              }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              onTapNonKeyboard: () {
                if (showEmoj)
                  setState(() {
                    showEmoj = false;
                  });
              },
              messageImageBuilder: (url, [messages]) {
                if (messages.customProperties == null) return SizedBox.shrink();

                if (messages.customProperties['long'] != null) {
                  final location = LatLng(messages.customProperties['lat'],
                      messages.customProperties['long']);
                  if ((messages.customProperties['files'] == null ||
                          messages.customProperties['files'].length == 0) &&
                      (messages.customProperties['cache_file_paths'] == null ||
                          messages.customProperties['cache_file_paths']
                                  .length ==
                              0)) return SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      launchMaps(location.latitude, location.longitude);
                    },
                    child: AbsorbPointer(
                      child: ImageViewNetwork(
                        url: (messages.customProperties['files'] != null &&
                                messages.customProperties['files'].length > 0)
                            ? messages.customProperties['files'][0]
                            : null,
                        borderRadius: 10,
                        cacheFilePath: (messages
                                        .customProperties['cache_file_paths'] !=
                                    null &&
                                messages.customProperties['cache_file_paths']
                                        .length >
                                    0)
                            ? messages.customProperties['cache_file_paths'][0]
                            : null,
                      ),
                    ),
                  );
                }

                final files = messages.customProperties['files'];
                if (files != null && files.length > 0) {
                  return MediaGroupWidgetNetwork(
                    urls: files,
                  );
                }

                final cachePaths =
                    messages.customProperties['cache_file_paths'];
                if (cachePaths != null && cachePaths.length > 0) {
                  return MediaGroupWidgetCache(
                    paths: cachePaths,
                  );
                }
                return SizedBox.shrink();
              },
              scrollController: scrollController,
              textController: _chatC,
              key: _chatViewKey,
              inverted: false,
              onSend: onSend,
              sendOnEnter: true,
              textInputAction: TextInputAction.send,
              user: _users
                  .firstWhere((user) => user.uid == _authBloc.userModel.id),
              textCapitalization: TextCapitalization.sentences,
              messageTextBuilder: (text, [messages]) {
                if (text.trim() == '') {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: text,
                      style: ptBody().copyWith(
                          fontSize: 13.8,
                          color: messages.user.uid == _authBloc.userModel.id
                              ? Colors.white
                              : Colors.black),
                    ),
                  ])),
                );
              },
              messageTimeBuilder: (text, [messages]) {
                return SizedBox.shrink();
              },
              dateBuilder: (text) => Text(
                text,
                style: ptSmall().copyWith(
                    fontWeight: FontWeight.w600, color: Colors.black38),
              ),
              inputToolbarPadding:
                  EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              inputDecoration: InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  border: InputBorder.none,
                  filled: true,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  hintStyle:
                      ptBody().copyWith(color: Colors.black54, fontSize: 14),
                  fillColor: Colors.grey[200]),
              focusNode: _focusNode,
              dateFormat: DateFormat('d-M-yyyy'),
              timeFormat: DateFormat('HH:mm'),
              messages: messages,
              showUserAvatar: false,
              showAvatarForEveryMessage: false,
              scrollToBottom: true,
              onPressAvatar: (ChatUser user) {
                final svUser = _severUsers.firstWhere(
                  (element) => element.id == user.uid,
                  orElse: () => null,
                );
                if (svUser != null) ProfileOtherPage.navigate(svUser);
              },
              onLongPressAvatar: (ChatUser user) {
                print("OnLongPressAvatar: ${user.name}");
              },
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5, right: 10),
              alwaysShowSend: _files.length > 0,
              inputTextStyle: TextStyle(fontSize: 15.5),
              inputContainerStyle: BoxDecoration(
                color: Colors.white,
              ),
              messageDecorationBuilder: (message, isUser) {
                double topLeft = 20,
                    bottomLeft = 20,
                    topRight = 20,
                    bottomRight = 20;
                final index = messages.indexOf(message);
                if (messages.length >= 2) {
                  if (isUser) {
                    if (index == 0) {
                      if (messages[1].user.uid ==
                          AuthBloc.instance.userModel.id) {
                        bottomRight = 4;
                      }
                    } else if (index == messages.length - 1) {
                      if (messages[messages.length - 2].user.uid ==
                          AuthBloc.instance.userModel.id) {
                        topRight = 4;
                      }
                    } else {
                      if (messages[index - 1].user.uid ==
                              AuthBloc.instance.userModel.id &&
                          messages[index + 1].user.uid ==
                              AuthBloc.instance.userModel.id) {
                        topRight = 4;
                        bottomRight = 4;
                      } else if (messages[index - 1].user.uid ==
                          AuthBloc.instance.userModel.id) {
                        topRight = 4;
                      } else if (messages[index + 1].user.uid ==
                          AuthBloc.instance.userModel.id) {
                        bottomRight = 4;
                      }
                    }
                  } else {
                    String userId = message.user.uid;
                    if (index == 0) {
                      if (messages[1].user.uid == userId) {
                        bottomLeft = 4;
                      }
                    } else if (index == messages.length - 1) {
                      if (messages[messages.length - 2].user.uid == userId) {
                        topLeft = 4;
                      }
                    } else {
                      if (messages[index - 1].user.uid == userId &&
                          messages[index + 1].user.uid == userId) {
                        topLeft = 4;
                        bottomLeft = 4;
                      } else if (messages[index - 1].user.uid == userId) {
                        topLeft = 4;
                      } else if (messages[index + 1].user.uid == userId) {
                        bottomLeft = 4;
                      }
                    }
                  }
                }

                return BoxDecoration(
                  color: (message.customProperties != null &&
                          ((message.customProperties['cache_file_paths'] !=
                                      null &&
                                  message.customProperties['cache_file_paths']
                                          .length >
                                      0) ||
                              (message.customProperties['files'] != null &&
                                  message.customProperties['files'].length >
                                      0)))
                      ? Colors.white
                      : (isUser ? userColor : Colors.grey[200]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topLeft),
                    topRight: Radius.circular(topRight),
                    bottomLeft: Radius.circular(bottomLeft),
                    bottomRight: Radius.circular(bottomRight),
                  ),
                );
              },
              iconSendColor: userColor,
              messagePaddingBuilder: (message) {
                return message.text.trim() != ''
                    ? EdgeInsets.symmetric(vertical: 5, horizontal: 8)
                    : EdgeInsets.zero;
              },
              onQuickReply: (Reply reply) {},
              shouldShowLoadEarlier: true,
              showTraillingBeforeSend: true,
              showLoadEarlierWidget: () {
                if (!reachEndList)
                  return LoadEarlierWidget(
                    onLoadEarlier: () {
                      print("loading...");
                      loadNext20Message();
                    },
                    onLoad: onLoadMore,
                  );
                else
                  return SizedBox.shrink();
              },
              inputFooterBuilder: () => (_files != null || _files.length == 0)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: _files
                            .map(
                              (file) => Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.file_present,
                                          color: userColor,
                                        ),
                                        Text(
                                          path.basename(file),
                                          style: ptBody().copyWith(
                                            color: userColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : SizedBox.shrink(),
              leading: [
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ptPrimaryColorLight(context)),
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 25),
                                    child: Row(
                                      children: [
                                        ActionItem(
                                          img: 'assets/image/location.png',
                                          name: 'Gắn vị trí',
                                          onTap: () async {
                                            if (_files.length > 0) {
                                              final confirm =
                                                  await showConfirmDialog(
                                                      context,
                                                      'Xác nhận xóa các file đính kèm?',
                                                      confirmTap: () {},
                                                      navigatorKey:
                                                          navigatorKey);
                                              if (!confirm) return;
                                              setState(() {
                                                _files.clear();
                                              });
                                            }
                                            await navigatorKey.currentState
                                                .maybePop();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            final res =
                                                await showGoogleMap(context);

                                            print(res);

                                            // res[0] is long lat, res[1] is image file
                                            if (res != null &&
                                                res[0] != null &&
                                                res[1] != null) {
                                              Map<String, dynamic>
                                                  customProperties = {};
                                              customProperties['long'] =
                                                  (res[0] as LatLng).longitude;
                                              customProperties['lat'] =
                                                  (res[0] as LatLng).latitude;
                                              await _onFilePick(
                                                  (res[1] as File)?.path);
                                              onSend(ChatMessage(
                                                  text:
                                                      '${AuthBloc.instance.userModel.name} đã chia sẻ 1 địa điểm',
                                                  user: _users.firstWhere(
                                                      (user) =>
                                                          user.uid ==
                                                          AuthBloc.instance
                                                              .userModel.id),
                                                  customProperties:
                                                      customProperties));
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              6 /
                                              100,
                                        ),
                                        ActionItem(
                                          img: 'assets/image/invite_chat.jpg',
                                          name: 'Mới người khac',
                                          onTap: () async {
                                            showToast('Tính năng này chưa có',
                                                context);
                                            await navigatorKey.currentState
                                                .maybePop();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 14, bottom: 14, left: 8, right: 4),
                        child: Icon(
                          Icons.apps,
                          color: userColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 14, bottom: 14, left: 4, right: 4),
                        child: Icon(
                          Icons.file_present,
                          color: userColor,
                        ),
                      ),
                      onTap: () async {
                        imagePicker(context,
                            onCameraPick: _onFilePick,
                            onMultiImagePick: _onMultiFilePick,
                            onVideoPick: _onFilePick);
                      },
                    ),
                  ],
                ),
              ],
              trailing: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 14, bottom: 14, left: 4, right: 4),
                    child: Icon(
                      Icons.emoji_emotions_rounded,
                      color: userColor,
                    ),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Future.delayed(
                        Duration(milliseconds: 150),
                        () => setState(() {
                              showEmoj = true;
                            }));
                  },
                ),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         top: 14, bottom: 14, left: 8, right: 4),
                //     child: Icon(
                //       Icons.thumb_up_rounded,
                //       color: userColor,
                //     ),
                //   ),
                //   onTap: () async {
                //     FocusScope.of(context).requestFocus(FocusNode());
                //     Future.delayed(
                //         Duration(milliseconds: 150),
                //         () => setState(() {
                //               showEmoj = true;
                //             }));
                //   },
                // ),
              ],
            ),
          ),
          if (showEmoj)
            EmojiKeyboard(
              onEmojiSelected: (Emoji emoji) {
                setState(() {
                  _chatC.text += emoji.text;
                  print(_chatC.text.trim() == '');
                });
              },
            )
        ],
      ),
    );
  }

  initMenu() {
    menu = PopupMenu(
        items: [
          MenuItem(
              title: 'Gọi điện',
              image: Icon(
                Icons.phone,
                color: Colors.white,
              )),
          // MenuItem(
          //     title: 'Video call',
          //     image: Icon(
          //       Icons.video_call,
          //       color: Colors.white,
          //     )),
        ],
        onClickMenu: (val) {
          if (val.menuTitle == 'Gọi điện') {
            // try {
            //   CallKit.displayIncomingCall(context, _authBloc.userModel.id,
            //           _authBloc.userModel.name, _authBloc.userModel.phone)
            //       .then((value) => print('call has ended'));
            // } catch (e) {}
            launchCaller(_fbUsers
                .firstWhere((element) => element.id != _authBloc.userModel.id)
                .phone);
            // VoiceCallPage.navigate(widget.group.id, _fbUsers);
          }
          if (val.menuTitle == 'Video call') {
            VideoCallPage.navigate(widget.group.id, _fbUsers);
          }
        },
        stateChanged: (val) {},
        onDismiss: () {});
  }

  PopupMenu menu;
}

class LoadEarlierWidget extends StatelessWidget {
  const LoadEarlierWidget(
      {Key key, @required this.onLoadEarlier, @required this.onLoad})
      : super(key: key);

  final Function onLoadEarlier;
  final bool onLoad;

  @override
  Widget build(BuildContext context) {
    return onLoad
        ? SizedBox(
            width: 30,
            height: 30,
            child: Center(child: CircularProgressIndicator()),
          )
        : GestureDetector(
            onTap: () {
              if (onLoadEarlier != null) {
                onLoadEarlier();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1.0,
                      blurRadius: 5.0,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Text(
                "Cũ hơn",
                style: ptBody().copyWith(color: Colors.black87),
              ),
            ),
          );
  }
}

class ActionItem extends StatelessWidget {
  final String img;
  final String name;
  final Function onTap;

  const ActionItem({Key key, this.img, this.name, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(img),
          ),
          SizedBox(height: 6),
          Text(
            name,
            style: ptTiny().copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
