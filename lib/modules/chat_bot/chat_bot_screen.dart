import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/chat_bot_bloc.dart';
import 'package:datcao/modules/inbox/import/app_bar.dart';
import 'package:datcao/modules/inbox/import/dash_chat/dash_chat.dart';
import 'package:datcao/share/import.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotPage extends StatefulWidget {
  static Future navigate() async {
    return navigatorKey.currentState!.push(pageBuilder(ChatBotPage()));
  }

  ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  bool showEmoj = false;
  bool showMedia = false;
  bool showCamera = false;
  final userColor = HexColor('#4D94FF');
  double? keyboardHeight;
  FocusNode _focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final TextEditingController _chatC = TextEditingController();
  AuthBloc? _authBloc;
  ChatBotBloc? _chatBotBloc;

  PageController _footerC = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _chatBotBloc = Provider.of<ChatBotBloc>(context);
      _chatBotBloc!.init();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void onSend(ChatMessage? message) {
    if (message == null) return;
    _chatBotBloc!.sendMessCB(message);
  }

  @override
  Widget build(BuildContext context) {
    if ((keyboardHeight ?? 0) < MediaQuery.of(context).viewInsets.bottom)
      keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: 'Chat bot hỗ trợ',
        automaticallyImplyLeading: true,
        bgColor: Colors.white,
        icon: CircleAvatar(
          backgroundImage: AssetImage(_chatBotBloc!.bot.avatar!),
        ),
        elevation: 2,
        actions: [
          GestureDetector(
            onTap: _chatBotBloc!.clear,
            child: SizedBox(
              width: 50,
              child: Icon(
                Icons.restart_alt,
                color: Colors.blue,
                size: 27,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: DashChat(
                shouldStartMessagesFromTop: true,
                onTapNonKeyboard: () {
                  if (showEmoj || showCamera || showMedia)
                    setState(() {
                      showEmoj = false;
                      showCamera = false;
                      showMedia = false;
                    });
                },
                messageContainerWidthRadio: (message) {
                  if (message?.customProperties?['files'] != null &&
                      message?.customProperties?['files'].length > 0)
                    return 0.6 + 38 / MediaQuery.of(context).size.width;
                  return 0.6;
                },
                scrollController: scrollController,
                textController: _chatC,
                key: _chatBotBloc!.chatViewKey,
                inverted: false,
                onSend: onSend,
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: _chatBotBloc!.me,
                textCapitalization: TextCapitalization.sentences,
                messageTextBuilder: (text, [messages]) {
                  if (text!.trim() == '') {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          showToastNoContext('Đường dẫn hết hiệu lực');
                        }
                      },
                      text: text,
                      style: ptBody().copyWith(
                          fontSize: 13.8,
                          color: messages!.user!.uid == _authBloc!.userModel!.id
                              ? Colors.white
                              : Colors.black87.withOpacity(0.75)),
                      textAlign: TextAlign.start,
                      linkStyle: ptBody().copyWith(
                          color: messages.user!.uid == _authBloc!.userModel!.id
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                },
                messageTimeBuilder: (text, [messages]) {
                  return SizedBox.shrink();
                },
                dateBuilder: (text) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: ptSmall().copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                  ),
                ),
                inputToolbarPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                inputDecoration: InputDecoration(
                    hintText: "Nhập tin nhắn...",
                    border: InputBorder.none,
                    filled: true,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    hintStyle:
                        ptBody().copyWith(color: Colors.black54, fontSize: 14),
                    fillColor: Colors.blue[50]),
                focusNode: _focusNode,
                dateFormat: DateFormat('d-M-yyyy'),
                timeFormat: DateFormat('HH:mm'),
                messages: _chatBotBloc!.messages,
                showUserAvatar: false,
                avatarBuilder: (user) {
                  return SizedBox(
                    height: 35,
                    width: 35,
                    child: user?.uid == 'bot'
                        ? CircleAvatar(
                            backgroundImage: AssetImage(user!.avatar ?? ''),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(user!.avatar ?? ''),
                          ),
                  );
                },
                showAvatarForEveryMessage: false,
                scrollToBottom:
                    _chatBotBloc!.messages.length > 6 ? true : false,
                onPressAvatar: (ChatUser? user) {},
                onLongPressAvatar: (ChatUser? user) {
                  print("OnLongPressAvatar: ${user!.name}");
                },
                inputMaxLines: 5,

                messageContainerPadding: EdgeInsets.only(left: 5, right: 10),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 15.5),
                inputContainerStyle: BoxDecoration(
                  color: Colors.white,
                ),
                messageDecorationBuilder: (message, isUser) {
                  double topLeft = 20,
                      bottomLeft = 20,
                      topRight = 20,
                      bottomRight = 20;
                  final index = _chatBotBloc!.messages.indexOf(message!);
                  if (_chatBotBloc!.messages.length >= 2) {
                    if (isUser ?? false) {
                      if (index == 0) {
                        if (_chatBotBloc!.messages[1].user!.uid ==
                            AuthBloc.instance.userModel!.id) {
                          bottomRight = 4;
                        }
                      } else if (index == _chatBotBloc!.messages.length - 1) {
                        if (_chatBotBloc!
                                .messages[_chatBotBloc!.messages.length - 2]
                                .user!
                                .uid ==
                            AuthBloc.instance.userModel!.id) {
                          topRight = 4;
                        }
                      } else {
                        if (_chatBotBloc!.messages[index - 1].user!.uid ==
                                AuthBloc.instance.userModel!.id &&
                            _chatBotBloc!.messages[index + 1].user!.uid ==
                                AuthBloc.instance.userModel!.id) {
                          topRight = 4;
                          bottomRight = 4;
                        } else if (_chatBotBloc!
                                .messages[index - 1].user!.uid ==
                            AuthBloc.instance.userModel!.id) {
                          topRight = 4;
                        } else if (_chatBotBloc!
                                .messages[index + 1].user!.uid ==
                            AuthBloc.instance.userModel!.id) {
                          bottomRight = 4;
                        }
                      }
                    } else {
                      String? userId = message.user!.uid;
                      if (index == 0) {
                        if (_chatBotBloc!.messages[1].user!.uid == userId) {
                          bottomLeft = 4;
                        }
                      } else if (index == _chatBotBloc!.messages.length - 1) {
                        if (_chatBotBloc!
                                .messages[_chatBotBloc!.messages.length - 2]
                                .user!
                                .uid ==
                            userId) {
                          topLeft = 4;
                        }
                      } else {
                        if (_chatBotBloc!.messages[index - 1].user!.uid ==
                                userId &&
                            _chatBotBloc!.messages[index + 1].user!.uid ==
                                userId) {
                          topLeft = 4;
                          bottomLeft = 4;
                        } else if (_chatBotBloc!
                                .messages[index - 1].user!.uid ==
                            userId) {
                          topLeft = 4;
                        } else if (_chatBotBloc!
                                .messages[index + 1].user!.uid ==
                            userId) {
                          bottomLeft = 4;
                        }
                      }
                    }
                  }

                  return BoxDecoration(
                    color: (message.customProperties != null &&
                            ((message.customProperties!['cache_file_paths'] !=
                                        null &&
                                    message
                                            .customProperties![
                                                'cache_file_paths']
                                            .length >
                                        0) ||
                                (message.customProperties!['files'] != null &&
                                    message.customProperties!['files'].length >
                                        0)))
                        ? Colors.white
                        : (message.user!.containerColor ?? Colors.blue[50]),
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
                  return message?.text!.trim() != ''
                      ? EdgeInsets.symmetric(vertical: 5, horizontal: 8)
                      : EdgeInsets.zero;
                },
                onQuickReply: (Reply? reply) {},
                shouldShowLoadEarlier: true,
                showTraillingBeforeSend: true,
                showLoadEarlierWidget: () {
                  // if (!reachEndList)
                  //   return LoadEarlierWidget(
                  //     onLoadEarlier: () {
                  //       print("loading...");
                  //       loadNext20Message();
                  //     },
                  //     onLoad: onLoadMore,
                  //   );
                  // else
                  return SizedBox.shrink();
                },
                // inputFooterBuilder: _buildFooter,
                leading: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 6, right: 0),
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            color: userColor,
                            size: 27,
                          ),
                        ),
                        onTap: () async {
                          setState(() {
                            showEmoj = true;
                            showCamera = false;
                            showMedia = false;
                          });
                          FocusScope.of(context).requestFocus(FocusNode());
                          Future.delayed(Duration(milliseconds: 50), () {
                            if (_footerC.hasClients) _footerC.jumpToPage(0);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_focusNode.hasFocus)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            else
              Container(height: 0),
          ],
        ),
      ),
    );
  }
}
